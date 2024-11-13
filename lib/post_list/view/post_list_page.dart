import 'package:flutter/material.dart';
import 'package:flutter_3_fetch/post_list/cubit/post_list_cubit.dart';
import 'package:flutter_3_fetch/post_list/view/post_list_view.dart';
import 'package:flutter_3_fetch/post_list/view/post_detail_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostListPage extends StatelessWidget {
  const PostListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostListCubit()..fetchPosts(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Posts'),
        ),
        body: const PostListView(),
      ),
    );
  }
}

