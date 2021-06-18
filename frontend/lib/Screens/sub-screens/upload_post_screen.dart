import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_media/Classes/sizeconfigration.dart';
import 'package:social_media/Screens/sub-screens/splash-screen.dart';
import 'package:social_media/api/Models/Post.dart';
import 'package:social_media/api/api.dart';

class UploadPost extends StatefulWidget {
  final String imagepath;
  UploadPost({this.imagepath});

  @override
  _UploadPostState createState() => _UploadPostState();
}

class _UploadPostState extends State<UploadPost> {
  TextEditingController postCaption = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("New Post",style: TextStyle(color: Colors.black)),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                File(widget.imagepath),
                fit: BoxFit.cover,
                width: SizeConfig.setWidth(200),
                height: SizeConfig.setHeight(200),
              ),
            ),
            TextField(
              maxLines: 5,//null,
              controller: postCaption,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(hintText: "Write a caption...",border: InputBorder.none),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                child: Text('Upload Post'),
                textColor: Colors.white,
                color:  Colors.red[600],
                onPressed: () async{
                // Upload post data to server
                if(postCaption.text.length > 0){
                  List<PostModel> data = await APIServices.createPost(userid: '${apiController.userdetail.value.id}',imageFilePath: widget.imagepath,postCaption: postCaption.text);
                  apiController.userdetail.value.posts = data;
                  Navigator.pop(context,0);
                }else{
                  Fluttertoast.showToast(
                    msg: "Provide your post caption",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    fontSize: 16.0,
                    backgroundColor: Colors.black54,
                    textColor: Colors.white,
                  );
                }
              }),
            )
          ],
        ),
      ),
    );
  }
}

class PostDetail{
  final String image;
  final String caption;

  PostDetail({this.image, this.caption});
  
}