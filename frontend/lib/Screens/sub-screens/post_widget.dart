import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_media/Classes/app_settings.dart';
import 'package:social_media/Screens/sub-screens/splash-screen.dart';
import 'package:social_media/Widgets/custom_image_viewer.dart';
import 'package:social_media/Widgets/gradient_frame.dart';
import 'package:social_media/api/Models/Post.dart';
import 'package:social_media/api/api.dart';
import 'package:social_media/api/api_management.dart';
import '../user_account.dart';
import 'comment_section_page.dart';
import 'dialogBoxes.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

class PostsListWidget extends StatefulWidget {
  PostsModel postsData;
  final int currentPostIndex;
  PostsListWidget({this.postsData, this.currentPostIndex});

  @override
  _PostsListWidgetState createState() => _PostsListWidgetState();
}

class _PostsListWidgetState extends State<PostsListWidget> {
  APIController _apiController = APIController();
  ItemScrollController itemScrollController = ItemScrollController();
  ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();


  @override
  void initState() {
    super.initState();
    if(widget.currentPostIndex != null) WidgetsBinding.instance.addPostFrameCallback((_) => control());
  }

  control() => itemScrollController.scrollTo(alignment: 0.0, index: widget.currentPostIndex, duration: Duration(milliseconds: 500));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async{
          if(widget.currentPostIndex == null ){
            _apiController.storeFetchedPosts().then((c) {
              setState(() => widget.postsData = _apiController.feeds.value);
            });
          }
        },
        child: widget.postsData.count != null
        ? Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top, bottom: widget.currentPostIndex != null ? 0 : 50),
          child: LazyLoadScrollView(
            onEndOfPage: () => loadMore(),
            child: ScrollablePositionedList.builder(
              itemPositionsListener: itemPositionsListener,
              itemScrollController: itemScrollController,
              itemCount: widget.postsData.posts.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 13,vertical: 10),
                  decoration: BoxDecoration(boxShadow: [BoxShadow(blurRadius: 6.0,color: Colors.grey)],color: Colors.white,borderRadius: BorderRadius.circular(15.0)),
                  child: PostWidget(post: widget.postsData.posts[index], postIndex: index));
            }),
          ),
        ) : Center(child: CircularProgressIndicator()),
      ),
    );
  }

  loadMore() {
    if(widget.currentPostIndex == null ){
      _apiController.storeFetchedPosts(url: widget.postsData.next).then((c) {
        setState(() => widget.postsData = _apiController.feeds.value);
      });
    }
  }
}

class PostWidget extends StatefulWidget {
  final int postIndex;
  final PostModel post;
  PostWidget({this.post, this.postIndex});

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool showMore = false,isLiked = false,showLikeButton = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Auther details
        ListTile(
          dense: true,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(userid: widget.post.author.id))),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0),topRight: Radius.circular(15.0))),
          contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
          leading: GradientCircleAvatar(
            radius: 16,
            showFrame: true,
            backgroundColor: AppDataLightMode.avatarBackgroundColor,
            image: widget.post.author.avatar),
          title: Text(widget.post.author.name,style: TextStyle(fontSize: 14)),
          subtitle: Text(TimeAgo.timeAgoSinceDate(widget.post.postedOn),style: TextStyle(fontSize: 10,fontWeight: FontWeight.w500)),
          trailing: IconButton(icon: Icon(Icons.more_horiz_rounded),onPressed: (){
            showDialog(context: context,builder: (context) => ReportPostDialog(postId: widget.post.id,index: widget.postIndex,));
          }),
        ),
        // Post Image
        InkWell(
          onDoubleTap: () async{
            if(apiController.userdetail.value.avatar != null){
              showLikeButton = true;
              isLiked = true;
              setState(() {});
              // Delay for 1 sec to display Heart Icon
              await Future.delayed(Duration(seconds: 1));
              setState(() => showLikeButton = false);
            }else{
              showToast(message: "Something went wrong",);
            }
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomImageViewer(imageUrl: widget.post.image,),
              AnimatedOpacity(
                // If the widget is visible, animate to 0.0 (invisible).
                // If the widget is hidden, animate to 1.0 (fully visible).
                opacity: showLikeButton ? 1.0 : 0.0,
                duration: Duration(milliseconds: 150),
                // The green box must be a child of the AnimatedOpacity widget.
                child: Icon(Icons.favorite_rounded,size: 100,color: Colors.white),
              )
            ],
          ),
        ),


        // Post feeds
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Wrap(
            children: [
              // Like Button
              IconButton(
                icon: isLiked 
                ? Icon(Icons.favorite_rounded, color: Colors.redAccent,size: 30)
                : Icon(FontAwesomeIcons.heart), 
                onPressed: !isLiked ? () {
                  if(apiController.userdetail.value.avatar != null){
                    setState(() => isLiked = isLiked ? false : true);
                    APIServices.like(widget.post.id);
                    widget.post.likes++;
                  }else{showToast();}
                } : () {},
                tooltip: '${widget.post.likes}',
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              // Comment button
              IconButton(icon: Icon(FontAwesomeIcons.comment), 
                splashColor: Colors.transparent,highlightColor: Colors.transparent,
                onPressed: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context) => CommentSection(postid: widget.post.id,)));
                }
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.download_rounded),
            onPressed: (){ 
              APIServices.downloadPost(widget.post.image).then((_){
                Fluttertoast.showToast(
                  msg: "Saved in Downloads folder",
                  backgroundColor: Colors.black54,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  fontSize: 16.0,
                  textColor: Colors.white
                );
              });
            })
        ]),
        // Divider(thickness: 2.0 ,
        
        widget.post.caption != null ? postDescriptionSection() : SizedBox(height: 0.0),
        widget.post.caption != null ? SizedBox(height: 10.0) : SizedBox(height: 0.0)
      ],
    );
  }

  Widget postDescriptionSection(){
    return InkWell(
      onTap: () {
        showMore = showMore ? false : true;
        setState(() {});
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 2.0),
        child: Text(utf8.decode(widget.post.caption.codeUnits).toString(),
          overflow: !showMore ? TextOverflow.ellipsis : null,
          maxLines: !showMore ? 1 : null,
        ),
      ),
    );
  }
}