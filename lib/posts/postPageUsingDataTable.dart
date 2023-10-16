import 'package:demojsonplaceholder/common/commonWidget.dart';
import 'package:demojsonplaceholder/common/states.dart';
import 'package:demojsonplaceholder/posts/postBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../postDetail/postDetailPage.dart';

class PostPageUsingDataTable extends StatefulWidget {
  const PostPageUsingDataTable({super.key});

  @override
  State<PostPageUsingDataTable> createState() => _PostPageUsingDataTableState();
}

class _PostPageUsingDataTableState extends State<PostPageUsingDataTable> {
  late PostBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = PostBloc();
    _bloc.add(BlocEvent(event: PostEvent.getPostDataForDataTable));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Posts"),
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
            if (state.state == PostState.success) {
              return RefreshIndicator(
                onRefresh: () {
                  _bloc.add(BlocEvent(event: PostEvent.getPost));
                  return Future.value();
                },
                child: ListView(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 0.0,
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.black), // Add a border
                        ),
                        columns: const <DataColumn>[
                          DataColumn(label: Text('Author Name')),
                          DataColumn(label: Text('Post Title')),
                        ],
                        rows: _bloc.combinedData
                            .map(
                              (data) => DataRow(
                                cells: <DataCell>[
                                  DataCell(Text(data['name']),),
                                  DataCell(Text(data['title']),
                                  onTap: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (BuildContext context) =>
                                            PostDetailsPage(postId: data["id"]),
                                      ),
                                    );
                                  }
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
