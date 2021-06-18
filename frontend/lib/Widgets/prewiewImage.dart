import 'dart:ui';
import 'package:flutter/material.dart';

class ImageViewer extends StatefulWidget {
  ImageViewer({Key key}) : super(key: key);

  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: PageView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: InteractiveViewer(
                              child: Image.network(
                                  "https://www.wrangler-ap.com/storage/app/media/sftw/tw8/40lgkq0qic/uploads/40lgkq0qic-1555665510.jpeg")),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 6),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.lightGreen,
                                    maxRadius: 10,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "USER_ID",
                                    style: TextStyle(color: Colors.black),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "ollow is. .gt gkjhgrebjg isfeiguerb iguberbghgg oiihdgjgiur \nrfgrufrgfff irgfrg ifurrfhg fergfrjg \nefgref",
                                style: TextStyle(color: Colors.grey[800]),
                              ),
                            )
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey[600],
                                        offset: Offset(3, 0),
                                        spreadRadius: 2,
                                        blurRadius: 18.0),
                                  ],
                                ),
                                child: IconButton(
                                    icon: Icon(
                                      Icons.thumb_up_sharp,
                                      color: Colors.green[400],
                                    ),
                                    onPressed: () {}),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey[600],
                                        offset: Offset(3, 0),
                                        spreadRadius: 2,
                                        blurRadius: 18.0),
                                  ],
                                ),
                                child: IconButton(
                                    icon: Icon(
                                      Icons.comment,
                                      color: Colors.green[400],
                                    ),
                                    onPressed: () {}),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey[600],
                                        offset: Offset(3, 0),
                                        spreadRadius: 2,
                                        blurRadius: 18.0),
                                  ],
                                ),
                                child: IconButton(
                                    icon: Icon(
                                      Icons.share,
                                      color: Colors.green[400],
                                    ),
                                    onPressed: () {}),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                })));
  }
}
