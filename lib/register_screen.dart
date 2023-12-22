import 'package:flutter/material.dart';

import 'package:flutter_login_screen_s/database_helper.dart';

import 'package:flutter_login_screen_s/login_screen.dart';
import 'package:intl/intl.dart';

import 'main.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formField = GlobalKey<FormState>();

  var userNameController = TextEditingController();
  var dobController = TextEditingController();
  var passwordController = TextEditingController();
  var mobileIDController = TextEditingController();
  var emailIDController = TextEditingController();

  bool passwordToggle = true;
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
            key: _formField,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: TextFormField(

                    controller: userNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      prefixIcon: Icon(Icons.account_circle),
                      labelText: 'UserName',
                      hintText: 'Enter the UserName',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter your Name or Email.';
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: TextFormField(
                    controller: dobController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      prefixIcon: Icon(Icons.calendar_today),
                      labelText: 'Date of Birth',
                      hintText: 'Enter the DOB',
                    ),
                    onTap: () => _selectDate(context),
                    readOnly: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter the Date of Birth.';
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: TextFormField(
                    obscureText: passwordToggle,
                    keyboardType: TextInputType.emailAddress,
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter the Password',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      prefixIcon: Icon(Icons.lock),
                      suffix: InkWell(
                        onTap: () {
                          setState(() {
                            passwordToggle = !passwordToggle;
                          });
                        },
                        child: Icon(passwordToggle
                            ? Icons.visibility_off
                            : Icons.visibility),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ' Enter Password.';
                      } else if (passwordController.text.length < 8) {
                        return 'Password lenth should be more then 8 characters.';
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: TextFormField(
                    controller: mobileIDController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      prefixIcon: Icon(Icons.phone),
                      labelText: 'Mobile Number',
                      hintText: 'Enter the MobileNo',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter the Mobile Number.';
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: TextFormField(
                    controller: emailIDController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      prefixIcon: Icon(Icons.calendar_today),
                      labelText: 'EmailID',
                      hintText: 'Enter the EmailID',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter the EmailId.';
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formField.currentState!.validate()) {
                      print('-----------> Register Button Clicked');
                      _save();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Successfully Validated'),
                        ),
                      );
                    }
                  },
                  child: Text('Register'),
                ),

              ],
            )),
      ),
    );
  }

  void _save() async {
    print('----------> Register');
    print('----------> UserName:${userNameController.text}');
    print('----------> DOB :${dobController.text}');
    print('---------> Password:${passwordController.text}');
    print('---------> MobileNo: ${mobileIDController.text}');
    print('---------> emailID: ${emailIDController.text}');

    Map<String, dynamic> row = {
      DatabaseHelper.colUserName: userNameController.text,
      DatabaseHelper.colDOB: dobController.text,
      DatabaseHelper.colPassword: passwordController.text,
      DatabaseHelper.colMobileNo: mobileIDController.text,
      DatabaseHelper.colEmailID: emailIDController.text
    };

    final result = await dbHelper.insertDirectorDetails(
        row, DatabaseHelper.loginDetailsTable);
    debugPrint('--------> Inserted Row Id: $result');

    if (result > 0) {
      _showSuccessSnackBar(context, 'Saved');

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(new SnackBar(content: new Text(message)));
  }
}
