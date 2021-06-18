import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:social_media/Classes/sizeconfigration.dart';
import 'package:social_media/Screens/sub-screens/upload_post_screen.dart';

class PopUpMenu extends StatelessWidget {
  static String recordedVideoFile;
  static String pickedVideoFile;

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Container(
      alignment: Alignment.center,
      height: SizeConfig.setHeight(120),
      padding: EdgeInsets.only(top: 15.0),
      child: Column(
        children: [
          Container(
            height: SizeConfig.setHeight(8),
            width: SizeConfig.setWidth(80),
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(25)
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  // Start camera
                  IconButton(icon: Icon(FontAwesomeIcons.cameraRetro), iconSize: 40,onPressed: (){
                    askpermission().then((isGranted){
                      if(isGranted) ImagePicker().getImage(source: ImageSource.camera,preferredCameraDevice: CameraDevice.front).then((file) {
                        // if image is captured navigate to post page
                        if(file != null) Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => UploadPost(imagepath: file.path)));
                      });
                    });
                  }),
                  Text("Camera")
                ],
              ),

              Column(
                children: [
                  // Open Gallery
                  IconButton(
                    icon: Icon(FontAwesomeIcons.image),iconSize: 40, onPressed: (){
                    // Ask user permission to access there storage unit
                    askpermission().then((isGranted){
                      if(isGranted) ImagePicker().getImage(source: ImageSource.gallery).then((file) {
                        // if image is selected navigate to post page
                        if(file != null) Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => UploadPost(imagepath: file.path,)));
                      });
                    });
                  }),
                  Text("Gallery")
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future askpermission() async{
    return await Permission.storage.request().isGranted ? true : false;
  }
}