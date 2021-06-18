import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:social_media/Classes/app_settings.dart';
import 'package:social_media/Screens/sub-screens/splash-screen.dart';
import 'package:social_media/Widgets/gradient_frame.dart';
import 'package:social_media/api/Models/Author.dart';
import 'package:social_media/api/Models/Comment.dart';
import 'package:social_media/api/api.dart';

import '../user_account.dart';

class CommentSection extends StatefulWidget {
  final int postid;
  CommentSection({this.postid});

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  TextEditingController commentField = TextEditingController();
  List<CommentModel> comments;
  bool isCommentsLoaded = false;

  // MyData
  Author user;

  @override
  void initState() {
    isCommentsLoaded = false;
    super.initState();
    final userInstance = apiController.userdetail.value;
    user = Author(name: userInstance.name, avatar: userInstance.avatar, isVerified: userInstance.isVerified, id: userInstance.id);
    APIServices.fetchComments(widget.postid).then((data){
      comments = data;
      isCommentsLoaded = true;
      setState((){});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[300],
        centerTitle: true,
        title: Text("Comments"),
      ),
      body: Column(
        children: [
          Expanded(
            child: isCommentsLoaded ? 
            ListView.builder(
              itemCount: comments != null ? comments.length : 0,
              scrollDirection: Axis.vertical,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                padding: EdgeInsets.symmetric(horizontal: 12,vertical: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(userid: comments[index].author.id)));
                            }, // Navigate to user profile page
                            child: GradientCircleAvatar(backgroundColor: Colors.white,radius: 15,image: comments[index].author.avatar,showFrame: comments[index].author.isVerified,frameThickness: 2,)),
                          Padding(padding: EdgeInsets.only(left: 8), child: Text(comments[index].author.name,style: TextStyle(color: Colors.green[400],fontWeight: FontWeight.bold),),)
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onLongPress: comments[index].author.id == apiController.userdetail.value.id
                            ? () async{
                              final selectedOption = await showDialog(
                                context: context,
                                builder: (context) => confirmDeletion(context),
                              );
                              if(selectedOption) APIServices.deleteComment('${comments[index].id}').then((_){
                                comments.remove(comments[index]);
                                setState(() {});
                              }); 
                            }
                            : () {},
                            child: Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4.0),
                              child: Text(utf8.decode(comments[index].content.codeUnits)),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.grey[200]),
                            ),
                          ),
                          Text(TimeAgo.timeAgoSinceDate(comments[index].commentedOn),style: TextStyle(fontSize: 10))
                        ],
                      ),

                    ],
                  ),
                );
              },
            ) 
            : Center(child: CircularProgressIndicator())
          ),
          // =================================================================
          apiController.userdetail.value.avatar != null
          ? Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: GradientCircleAvatar(backgroundColor: Colors.white,radius: 15,image: user.avatar,showFrame: true,frameThickness: 2),
              ),
              Expanded(child: Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                    cursorColor: Colors.black,
                    controller: commentField,
                    decoration: InputDecoration(hintText: "Add a comment", border: InputBorder.none),
                  ),
              )),
              IconButton(icon: Icon(Icons.send_outlined,color: Colors.green[900],), onPressed: (){
                if(commentField.text != null || commentField.text != " "){
                  FocusScope.of(context).unfocus();
                  comments.add(CommentModel(
                    author: user,
                    content: commentField.text,
                    commentedOn: '${DateTime.now()}'
                  ));
                  comments = comments.reversed.toList();
                  APIServices.commentOnPost('${widget.postid}','${user.id}','${commentField.text}');
                  commentField.clear();
                  setState(() {});
                }
              })
            ],
          ) : SizedBox()
        ],
      ),
    );
  }

  confirmDeletion(BuildContext context){
    return AlertDialog(
      title: Text('Alert',style: TextStyle(color: Colors.red)),
      content: Text('Are you sure you want to delete this comment'),
      actions: [
        FlatButton(child: Text('Yes'),onPressed: () => Navigator.of(context).pop(true)),
        FlatButton(child: Text('No'),onPressed: () => Navigator.of(context).pop(false)),
      ],
    );
  }
}