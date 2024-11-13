import 'package:flutter/material.dart';
import 'package:flutter_3_fetch/post_list/post_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostDetailPage extends StatefulWidget {
  final Post post;
  final int index;
  final int totalPosts;

  const PostDetailPage({
    Key? key,
    required this.post,
    required this.index,
    required this.totalPosts,
  }) : super(key: key);

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late Post currentPost;
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentPost = widget.post;
    currentIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteConfirmation(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              currentPost.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              currentPost.body,
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => _loadPost(true),
                  child: const Text('Previous'),
                ),
                ElevatedButton(
                  onPressed: () => _loadPost(false),
                  child: const Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadPost(bool isPrevious) async {
    final nextIndex = isPrevious
        ? (currentIndex > 0 ? currentIndex - 1 : widget.totalPosts - 1)
        : (currentIndex < widget.totalPosts - 1 ? currentIndex + 1 : 0);

    final nextPost =
        await context.read<PostListCubit>().fetchPostDetail(nextIndex + 1);

    if (nextPost != null) {
      setState(() {
        currentPost = nextPost;
        currentIndex = nextIndex;
      });
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Post'),
        content: const Text('Are you sure you want to remove this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<PostListCubit>().removePost(currentPost.id);
              Navigator.of(context)
                ..pop()
                ..pop();
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}
