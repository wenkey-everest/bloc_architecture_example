import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_list/posts/bloc/post_event.dart';
import 'package:infinite_list/posts/bloc/post_state.dart';
import 'package:infinite_list/repository/post_api_repository.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

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
        if (state.status == PostStatus.intial) {
          final posts = await postApiRepository.fetchPosts();
          return emit(state.copyWith(
            status: PostStatus.sucess,
            posts: posts,
            hasReachedMax: false,
          ));
        }
        final posts = await postApiRepository.fetchPosts();
        posts.isEmpty
            ? emit(state.copyWith(hasReachedMax: true))
            : emit(state.copyWith(
                status: PostStatus.sucess,
                posts: List.of(state.posts)..addAll(posts),
                hasReachedMax: false));
      } catch (e) {
        emit(state.copyWith(status: PostStatus.failue));
      }
    }
  }
}
