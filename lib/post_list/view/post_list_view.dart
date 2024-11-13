import 'package:flutter/material.dart';
import 'package:flutter_3_fetch/post_list/cubit/post_list_cubit.dart';
import 'package:flutter_3_fetch/post_list/view/post_detail_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostListView extends StatelessWidget {
  const PostListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostListCubit, PostListState>(
      builder: (context, state) {
        if (state is PostListLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PostListLoaded) {
          return ListView.builder(
            itemCount: state.posts.length,
            itemBuilder: (context, index) {
              final post = state.posts[index];
              return ListTile(
                leading: CircleAvatar(
                  radius: 20,
                  child: Text(
                    state.posts[index].title.substring(0, 1).toUpperCase(),
                  ),
                ),
                title: Text(post.title),
                subtitle: Text(
                  post.body.length > 50
                      ? '${post.body.substring(0, 50)}...'
                      : post.body,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostDetailPage(
                        post: post,
                        index: index,
                        totalPosts: state.posts.length,
                      ),
                    ),
                  );
                },
                onLongPress: () => _showDeleteConfirmation(context, post.id),
              );
            },
          );
        } else if (state is PostListError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox();
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, int postId) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Remove this post?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<PostListCubit>().removePost(postId);
                    Navigator.pop(context);
                  },
                  child: const Text('Remove'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
