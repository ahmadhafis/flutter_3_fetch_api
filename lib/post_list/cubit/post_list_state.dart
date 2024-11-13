part of 'post_list_cubit.dart';

abstract class PostListState extends Equatable {
  const PostListState();

  @override
  List<Object?> get props => [];
}

class PostListInitial extends PostListState {}

class PostListLoading extends PostListState {}

class PostListLoaded extends PostListState {
  final List<Post> posts;

  const PostListLoaded(this.posts);

  @override
  List<Object?> get props => [posts];
}

class PostListError extends PostListState {
  final String message;

  const PostListError(this.message);

  @override
  List<Object?> get props => [message];
}
