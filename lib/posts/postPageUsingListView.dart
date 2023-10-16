import 'package:demojsonplaceholder/common/commonWidget.dart';
import 'package:demojsonplaceholder/common/states.dart';
import 'package:demojsonplaceholder/postDetail/postDetailPage.dart';
import 'package:demojsonplaceholder/posts/postBloc.dart';
import 'package:demojsonplaceholder/posts/postPageUsingDataTable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  late PostBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = PostBloc();
    _bloc.add(BlocEvent(event: PostEvent.getPost));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Posts"),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: (value) {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        const PostPageUsingDataTable(),
                  ),
                );
              },
              itemBuilder: (BuildContext context) {
                return <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'datatable',
                    child: Text('Posts Using Data Table'),
                  ),

                ];
              },
            ),
          ],
          elevation: 10,
        ),
        body: BlocConsumer<PostBloc, ParentState>(
          listener: (context, state) {
            if (state.state == PostState.loading) {
              showLoader(context);
            } else if (state.state == PostState.success) {
              cancelLoader(context);
            } else if (state.state == PostState.error) {
              cancelLoader(context);
              showToast(state.data.toString());
            }
          },
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () {
                _bloc.add(BlocEvent(event: PostEvent.getPost));
                return Future.value();
              },
              child: ListView.builder(
                itemCount: _bloc.posts.length,
                itemBuilder: (context, index) {
                  final post = _bloc.posts[index];
                  final user =
                      _bloc.users.firstWhere((user) => user.id == post.userId);
                  return Card(
                    margin: const EdgeInsets.all(5),
                    elevation: 2,
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                PostDetailsPage(postId: post.id),
                          ),
                        );
                      },
                      title: Text(
                        post.title,
                        overflow: TextOverflow.visible,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          "Author: ${user.name}",
                          style: const TextStyle(fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
