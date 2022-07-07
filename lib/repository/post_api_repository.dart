import 'package:infinite_list/Data/post_api_provider.dart';
import 'package:infinite_list/posts/model/post.dart';

class PostApiRepository {
  final PostApiProvider _postApiProvider = PostApiProvider();

  Future<List<Post>> fetchPosts() => _postApiProvider.getPosts();
}
