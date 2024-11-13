import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_3_fetch/post_list/model/post.dart';

part 'post_list_state.dart';

class PostListCubit extends Cubit<PostListState> {
  final Dio _dio;
  List<Post> _posts = [];

  PostListCubit() : 
    _dio = Dio(BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    )),
    super(PostListInitial());

  Future<void> fetchPosts() async {
    try {
      emit(PostListLoading());
      final response = await _dio.get('/posts');
      _posts = (response.data as List)
          .map((json) => Post.fromJson(json))
          .toList();
      emit(PostListLoaded(_posts));
    } on DioException catch (e) {
      emit(PostListError(_handleError(e)));
    } catch (e) {
      emit(PostListError(e.toString()));
    }
  }

  Future<Post?> fetchPostDetail(int id) async {
    try {
      final response = await _dio.get('/posts/$id');
      return Post.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  void removePost(int id) {
    _posts.removeWhere((post) => post.id == id);
    emit(PostListLoaded(_posts));
  }

  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timed out';
      case DioExceptionType.receiveTimeout:
        return 'Unable to receive data';
      case DioExceptionType.badResponse:
        return 'Invalid response from server';
      case DioExceptionType.connectionError:
        return 'No internet connection';
      default:
        return 'Something went wrong';
    }
  }
}