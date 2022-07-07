import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:infinite_list/posts/model/post.dart';
import 'package:http/http.dart' as http;

class PostApiProvider {
  String baseUrl = "https://jsonplaceholder.typicode.com";
  String endPoint = "/posts";
  String statusCode = "200";

  Future<List<Post>> getPosts() async {
    final httpResponse = Uri.parse(baseUrl + endPoint);

    final response = await http.get(httpResponse);

    //compute function uses to run in seperate isolate.
    return compute(parsePosts, response);
  }

  List<Post> parsePosts(http.Response response) {
    print(response);
    if (response.statusCode == 200) {
      final parsedPosts =
          jsonDecode(response.body).cast<Map<String, dynamic>>();
      return parsedPosts.map<Post>((json) => Post.fromJson(json)).toList();
    }
    throw Exception("Error fetching posts");
  }
}
