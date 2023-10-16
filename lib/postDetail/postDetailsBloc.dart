import 'dart:convert';
import 'package:demojsonplaceholder/response/postsModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../common/states.dart';
import '../network/apiClient.dart';

enum PostDetailsEvent { getPostDetail }

enum PostDetailsState { success, error, loading }

class PostDetailsBloc extends Bloc<BlocEvent, ParentState> {
  var postDetails = PostsModel();
  List<PostsCommentModel> postCommentsList = List<PostsCommentModel>.empty(growable: true);

  PostDetailsBloc() : super(InitState()) {
    on((BlocEvent event, emit)async {
      switch (event.event) {
        case PostDetailsEvent.getPostDetail:
          {
            var postId = event.data;

            emit(BlocState(state: PostDetailsState.loading));

            try {
              var postResponse = ApiCallMethods.checkResponse(
                  response: await ApiCallMethods.get(
                    url: "${ApiCallMethods.posts}/$postId",));

              postDetails = PostsModel.fromJson(json.decode(postResponse));

              var postComments = ApiCallMethods.checkResponse(
                  response: await ApiCallMethods.get(
                    url: "${ApiCallMethods.posts}/$postId/comments",));

              postCommentsList = (json.decode(postComments) as List<dynamic>)
                  .map((e) =>
                  PostsCommentModel.fromJson(e as Map<String, dynamic>))
                  .toList();

              emit(BlocState(state: PostDetailsState.success));
            } catch (e) {
              emit(BlocState(state: PostDetailsState.error,data: e.toString()));
            }
          }
      }
    });
  }
}