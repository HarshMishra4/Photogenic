import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:social_media/Classes/sizeconfigration.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media/Screens/sub-screens/splash-screen.dart';
import 'dart:io';
import 'package:social_media/api/api.dart';

class AccountSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              child: TweenAnimationBuilder(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: Duration(milliseconds: 800),
                  builder: (context, value, child) {
                    return ShaderMask(
                        shaderCallback: (rect) {
                          return RadialGradient(
                            radius: value * 5,
                            colors: [Colors.white, Colors.white, Colors.transparent, Colors.transparent],
                            stops: [0.0, 0.55, 0.6, 1.0], center: FractionalOffset(0.95, 0.0)
                          ).createShader(rect);
                        },
                        child: MyProfile());
                  }),
          );
        },
      )
    );
  }
}


class MyProfile extends StatefulWidget {

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {

  String imagePath,genderChoose;
  DateTime selectedDate;

  void getImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imagePath = pickedFile.path;
      setState(() {});
    }
  }

  void _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950, 1),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  TextEditingController name_c;
  TextEditingController userId_c;
  TextEditingController about_c;

  @override
  void initState() { 
    super.initState();
    selectedDate = apiController.userdetail.value.dob != '' ? DateTime.parse(apiController.userdetail.value.dob) : null;
    name_c = TextEditingController(text: apiController.userdetail.value.name);
    userId_c = TextEditingController(text: apiController.userdetail.value.userId);
    about_c = TextEditingController(text: utf8.decode(apiController.userdetail.value.bio.codeUnits));
    
  }
 
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
        // ===============================================
        // ============APP BAR============================
        // ===============================================
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          leading: IconButton(
              icon: Icon(Icons.arrow_back,color: Colors.green),
              onPressed: () => Navigator.pop(context)),
          title: Text(
            "My Profile",
            style: TextStyle(color: Colors.green, fontSize: SizeConfig.setText(23)),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.done,color: Colors.lightGreen), 
              onPressed: () async{
                FocusScope.of(context).unfocus();
                final data = await APIServices.updateAccountDetails(
                  about: about_c.text != null ? about_c.text : '',
                  gender: genderChoose != null ? genderChoose : '',
                  dob: selectedDate != null ? '$selectedDate' : '',
                  id: '${apiController.userdetail.value.id}',
                  image: imagePath,
                  name: name_c.text
                );
                apiController.userdetail.value = data;
                Navigator.pop(context);
            })
          ],
        ),
        body: ListView(
          children: [
            SizedBox(height: SizeConfig.setHeight(15)),
            SizedBox(
              child:
                  // ===================================================
                  // ===================USER IMAGE======================
                  // ===================================================
                  Center(
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(80),
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: imagePath != null
                                ? FileImage(File(imagePath))
                                : NetworkImage(apiController.userdetail.value.avatar)
                              )
                          ),
                          height: SizeConfig.setHeight(150),
                          width: SizeConfig.setWidth(150)),
                    ),
                    // =================================================================
                    // ====================CAMERA BUTTON=================================
                    // ==================================================================
                    Center(
                      child: SizedBox(
                        height: SizeConfig.setHeight(150),
                        width: SizeConfig.setWidth(150),
                        child: Align(
                          child: Container(
                            decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            child: IconButton(
                                icon: Icon(
                                  Icons.add_a_photo,
                                  color: Colors.green,
                                ),
                                iconSize: 30,
                                onPressed: () => getImage()),
                          ),
                          alignment: Alignment.bottomRight,
                        ),
                        // alignment: Alignment.bottomLeft,
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: SizeConfig.setHeight(40)),
            // ===========================================================
            // ==============TEXT FIELD===================================
            // ===========================================================
            customTextField(
              name_c,
              hintText: "username",
              helperText: "eg. User Name",
            ),
            SizedBox(
              height: SizeConfig.setHeight(10),
            ),

            customTextField(
              userId_c,
              readOnly: true,
              hintText: "User ID",
              helperText: "eg. USER_ID",
            ),

            SizedBox(
              height: SizeConfig.setHeight(10)),

            // ===========================================================================================
            // ================================ABOUT======================================================
            // ===========================================================================================
            customTextField(
              about_c,
              hintText: "About",
              helperText: "eg. Your intrests,hobby etc",
              maxLines: 5,
              maxLength: 200
            ),

            SizedBox(
              height: SizeConfig.setHeight(10),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: SizedBox(
                width: SizeConfig.setWidth(390),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: Container(
                        height: SizeConfig.setHeight(45),
                        width: SizeConfig.setWidth(MediaQuery.of(context).size.width / 2.3),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              selectedDate == null
                                  ? "D.O.B"
                                  : selectedDate.toString().substring(0, 10),
                              style:TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            Icon(
                              Icons.calendar_today_rounded,
                              color: Colors.white,
                              size: 20,
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: SizeConfig.setHeight(45),
                      width: SizeConfig.setWidth(MediaQuery.of(context).size.width /2.5),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(5)
                      ),
                      alignment: Alignment.center,
                      child: DropdownButton(
                        // isExpanded: true,
                        // underline: SizedBox(),
                        // dropdownColor: Colors.grey[700],
                        icon: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Icon(Icons.arrow_drop_down_circle,color: Colors.white,size: 20),
                        ),
                        hint: Text(
                          apiController.userdetail.value.gender != '' 
                              ? apiController.userdetail.value.gender
                              : "Gender",style: TextStyle(color: Colors.white,fontSize: 18),
                        ),
                        onChanged: (value){
                          genderChoose=value;
                          setState(() {});
                        },
                        value: genderChoose,
                        items: ["Male","Female","Other"].map((e) {
                          return(DropdownMenuItem(child: Text(e),
                          value:e));
                        }).toList(),
                      ),
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5.0),
              child: RaisedButton(
                color: Colors.red[800],
                textColor: Colors.white,
                child: Text('Logout'),
                onPressed: () {},
              ),
            ),
          ],
        ));
  }


}

Widget customTextField(TextEditingController controller,{String hintText,String helperText,int maxLines = 1, int maxLength = 50, bool readOnly = false}){
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 15,vertical: 4),
      child: TextField(
        readOnly: readOnly,
        controller: controller,
        keyboardType: TextInputType.multiline,
        maxLines: maxLines,
        maxLength: maxLength,
        decoration: InputDecoration(
          suffixIcon: Icon(Icons.edit,color: Colors.grey[700]),
          hintText: hintText,
          helperText: helperText,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.green, width: 4)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.green, width: 2))),
    ),
  );
}