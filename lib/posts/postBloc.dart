import 'dart:convert';
import 'package:demojsonplaceholder/response/postsModel.dart';
import 'package:demojsonplaceholder/response/usersModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/states.dart';
import '../network/apiClient.dart';

enum PostEvent { getPost, getPostDataForDataTable }

enum PostState { success, error, loading }

class PostBloc extends Bloc<BlocEvent, ParentState> {

  List<PostsModel> posts = List<PostsModel>.empty(growable: true);
  List<UsersModel> users = List<UsersModel>.empty(growable: true);

  List<Map<String, dynamic>> postsForDataTable = List<Map<String, dynamic>>.empty(growable: true);
  List<Map<String, dynamic>> usersForDataTable = List<Map<String, dynamic>>.empty(growable: true);

  List<Map<String, dynamic>> combinedData = [];

  PostBloc() : super(InitState()) {
    on((BlocEvent event, emit) async {
      switch (event.event) {
        case PostEvent.getPost:
          {
            emit(BlocState(state: PostState.loading));
            try {
              var postResponse = ApiCallMethods.checkResponse(
                  response: await ApiCallMethods.get(
                url: ApiCallMethods.posts,
              ));

              posts = (json.decode(postResponse) as List<dynamic>)
                  .map((e) => PostsModel.fromJson(e as Map<String, dynamic>))
                  .toList();

              var usersResponse = ApiCallMethods.checkResponse(
                  response: await ApiCallMethods.get(
                url: ApiCallMethods.users,
              ));

              users = (json.decode(usersResponse) as List<dynamic>)
                  .map((e) => UsersModel.fromJson(e as Map<String, dynamic>))
                  .toList();

              emit(BlocState(state: PostState.success));
            } catch (e) {
              emit(BlocState(state: PostState.error, data: e.toString()));
            }
          }
          break;
        case PostEvent.getPostDataForDataTable:
          {
            emit(BlocState(state: PostState.loading));
            try {
              var postResponse = ApiCallMethods.checkResponse(
                  response: await ApiCallMethods.get(
                    url: ApiCallMethods.posts,
                  ));

              postsForDataTable = (json.decode(postResponse) as List<dynamic>).cast<Map<String, dynamic>>();


              var usersResponse = ApiCallMethods.checkResponse(
                  response: await ApiCallMethods.get(
                    url: ApiCallMethods.users,
                  ));

              usersForDataTable = (json.decode(usersResponse) as List<dynamic>).cast<Map<String, dynamic>>();


              for (var post in postsForDataTable) {
                var user = usersForDataTable.firstWhere((user) => user['id'] == post['userId']);
                combinedData.add({
                  'userId': user['id'],
                  'id': post['id'],
                  'name': user['name'],
                  'title': post['title'],
                  'body': post['body'],
                });
              }

              emit(BlocState(state: PostState.success));
            } catch (e) {
              emit(BlocState(state: PostState.error, data: e.toString()));
            }
          }
          break;
      }
    });
  }
}
