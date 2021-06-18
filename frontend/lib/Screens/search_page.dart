import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:social_media/Classes/sizeconfigration.dart';
import 'package:social_media/Screens/sub-screens/splash-screen.dart';
import 'package:social_media/Screens/user_account.dart';
import 'package:social_media/Widgets/gradient_frame.dart';


class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  bool searchSomething = true;
  bool isLoaded = false;
  TextEditingController _editingController = TextEditingController();

  @override
  void initState() { 
    super.initState();
    if(apiController.users.value.authors != null){
      apiController.users.value.authors.clear();
    }
  }

  @override
  void dispose() { 
    if(apiController.users.value.authors != null){
      apiController.users.value.authors.clear();
    }
    _editingController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: Obx(
        () => Padding(
          padding: MediaQuery.of(context).viewPadding,
          child: Column(
            children: [
              Container(
                height: SizeConfig.setHeight(45),
                margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                padding: EdgeInsets.only(left: 15.0),
                decoration: BoxDecoration(
                    // color: Colors.lightGreenAccent.withOpacity(0.8),
                    gradient: LinearGradient(colors: [Colors.lightGreenAccent, Color(0xFFa8e063)]),
                    borderRadius: BorderRadius.circular(25)),
                child: TextField(
                  controller: _editingController,
                  onChanged: (input) {
                    if (input.length > 2) {
                      apiController.searchUsers(input);
                      searchSomething = false;
                    } else {
                      searchSomething = true;
                      apiController.users.value.authors.clear();
                    }
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search ...",
                      suffixIcon: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent)),
                ),
              ),
              Expanded(
                child: apiController.users.value.authors != null
                    ? ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.only(top: 2),
                      itemCount: apiController.users.value.authors.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(userid: apiController.users.value.authors[index].id)));
                          },
                          contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 23),
                          title: Text(apiController.users.value.authors[index].name),
                          subtitle: Text(apiController.users.value.authors[index].userId),
                          trailing: apiController.users.value.authors[index].isVerified
                          ? Icon(
                            Icons.verified,
                            color: Colors.green,
                          ) : null,
                          leading: GradientCircleAvatar(
                            radius: 23,
                            showFrame: apiController.userdetail.value.isVerified,
                            frameThickness: 3.0,
                            backgroundColor: Colors.white,
                            image: apiController.users.value.authors[index].avatar),
                        );
                      },
                      )
                    : searchSomething
                        ? Text("Search Something")
                        : Text("found nothing"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}