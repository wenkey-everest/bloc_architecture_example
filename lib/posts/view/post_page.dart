import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../posts.dart';
import 'package:infinite_list/repository/post_api_repository.dart';

class PostPage extends StatelessWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Posts"),
      ),
      body: BlocProvider(
        create: (_) => PostBloc(PostApiRepository())..add(PostFetched()),
        child: const PostList(),
      ),
    );
  }
}
