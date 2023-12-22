import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_login_screen_s/register_screen.dart';

import 'database_helper.dart';
import 'login_screen.dart';
import 'user_details_model.dart';
import 'main.dart';

class DisplayScreen extends StatefulWidget {
  final String username;

  const DisplayScreen({super.key, required this.username});




  @override
  State<DisplayScreen> createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  late List<LoginDetailsModel> _userNameList;

  @override
  void initState() {
    super.initState();
    getAllLoginDetails();
  }

  getAllLoginDetails() async {
    _userNameList = <LoginDetailsModel>[];

    var loginDetailsRecords =
        await dbHelper.queryAllRows(DatabaseHelper.loginDetailsTable);

    loginDetailsRecords.forEach((loginDetail) {
      setState(() {
        // Display in log
        print(loginDetail['_id']);
        print(loginDetail['user_name']);
        print(loginDetail['_dob']);
        print(loginDetail['_password']);
        print(loginDetail['_mobileNo']);
        print(loginDetail['_emailID']);

        // Data model

          var loginDetailModel = LoginDetailsModel(
            loginDetail['_id'],
            loginDetail['user_name'],
            loginDetail['_dob'],
            loginDetail['_password'],
            loginDetail['_mobileNo'],
            loginDetail['_emailID'],
          );

          // Add in List
        if(widget.username == loginDetail['user_name']){
          _userNameList.add(loginDetailModel);
        }

        }
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Login Details'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Expanded(
                  child: ListView.builder(
                itemCount: _userNameList.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      print('------------->Edit or Delete: Send Data');
                      print(_userNameList[index].id);
                      print(_userNameList[index].userName);
                      print(_userNameList[index].dob);
                      print(_userNameList[index].password);
                      print(_userNameList[index].mobileNo);
                      print(_userNameList[index].emailID);

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                          settings: RouteSettings(
                            arguments: _userNameList[index],
                          )));
                    },
                    child: ListTile(
                      title: Text(_userNameList[index].userName!),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('DOB: ${_userNameList[index].dob}'),
                          Text('Email: ${_userNameList[index].emailID}'),
                          Text('Mobile No: ${_userNameList[index].mobileNo}'),
                        ],
                      ),
                    ),
                  );
                },
              ))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('-------------> FAB Clicked');
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => RegisterScreen(),
          ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
