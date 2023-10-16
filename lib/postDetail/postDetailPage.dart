import 'package:demojsonplaceholder/common/commonWidget.dart';
import 'package:demojsonplaceholder/common/states.dart';
import 'package:demojsonplaceholder/postDetail/postDetailsBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostDetailsPage extends StatefulWidget {
  final dynamic postId;

  const PostDetailsPage({super.key, this.postId});

  @override
  State<PostDetailsPage> createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  late PostDetailsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = PostDetailsBloc();
    _bloc.add(BlocEvent(
        event: PostDetailsEvent.getPostDetail, data: widget.postId.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Post Detail & Comments"),
          elevation: 10,
        ),
        body: BlocConsumer<PostDetailsBloc, ParentState>(
          listener: (context, state) {
            if (state.state == PostDetailsState.loading) {
              showLoader(context);
            } else if (state.state == PostDetailsState.success) {
              cancelLoader(context);
            } else if (state.state == PostDetailsState.error) {
              cancelLoader(context);
              showToast(state.data.toString());
            }
          },
          builder: (context, state) {
            if(state.state == PostDetailsState.success)
              {
                return ListView(
                  children: [
                    const Card(
                      elevation: 10,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: Text("Details",
                            style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    IntrinsicHeight(
                      child: Card(
                        elevation: 2,
                        margin: const EdgeInsets.all(10),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Expanded(child: Text("Title")),
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      _bloc.postDetails.title,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Expanded(child: Text("Body")),
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      _bloc.postDetails.body,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Card(
                      elevation: 10,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: Text("Comments",
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _bloc.postCommentsList.length,
                      itemBuilder: (context, index) {
                        final post = _bloc.postCommentsList[index];
                        return Card(
                          margin: const EdgeInsets.all(5),
                          elevation: 2,
                          child: ListTile(
                            title: Row(
                              children: [
                                const Expanded(child: Text("Name")),
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    post.name,
                                    overflow: TextOverflow.visible,
                                    style: const TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              post.body,
                              style: const TextStyle(fontWeight: FontWeight.w400),
                            ),
                          ),
                        );
                      },
                    )
                  ],
                );
              }else if (state.state == PostDetailsState.error){
              return const Center(
                child: Text("Something Went Wrong"),
              );
            }else
              {
                return Container();
              }
          },
        ),
      ),
    );
  }
}
