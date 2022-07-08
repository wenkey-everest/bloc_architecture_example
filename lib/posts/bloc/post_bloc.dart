import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_list/repository/post_api_repository.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';

import '../model/post.dart';

part 'post_state.dart';
part 'post_event.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostApiRepository postApiRepository;

  PostBloc(this.postApiRepository) : super(const PostState()) {
    on<PostFetched>(_onPostFetched,
        transformer: throttleDroppable(throttleDuration));
  }

  Future<void> _onPostFetched(
      PostFetched event, Emitter<PostState> emit) async {
    if (!state.hasReachedMax) {
      try {
        if (state.status == PostStatus.initial) {
          final posts = await postApiRepository.fetchPosts();
          return emit(state.copyWith(
            status: PostStatus.success,
            posts: posts,
            hasReachedMax: false,
          ));
        }
        final posts = await postApiRepository.fetchPosts();
        posts.isEmpty
            ? emit(state.copyWith(hasReachedMax: true))
            : emit(state.copyWith(
                status: PostStatus.success,
                posts: List.of(state.posts)..addAll(posts),
                hasReachedMax: false));
      } catch (e) {
        emit(state.copyWith(status: PostStatus.failure));
      }
    }
  }
}
