// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:infinite_list/posts/model/post.dart';

enum PostStatus { intial, sucess, failue }

class PostState {
  final PostStatus status;
  final List<Post> posts;
  final bool hasReachedMax;
  const PostState({
    this.status = PostStatus.intial,
    this.posts = const <Post>[],
    this.hasReachedMax = false,
  });

  @override
  String toString() {
    return '''PostState { status: $status, hasReachedMax: $hasReachedMax, posts: ${posts.length} }''';
  }

  PostState copyWith({
    PostStatus? status,
    List<Post>? posts,
    bool? hasReachedMax,
  }) {
    return PostState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}
