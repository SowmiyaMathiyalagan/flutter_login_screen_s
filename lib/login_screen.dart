import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_login_screen_s/register_screen.dart';
import 'package:flutter_login_screen_s/userdetails_list_screen.dart';
import 'package:flutter_login_screen_s/database_helper.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formField = GlobalKey<FormState>();

  var usernameController = TextEditingController();
  var dobController = TextEditingController();
  var passwordController = TextEditingController();

  bool passwordToggle = true;
  DateTime? _selectedDate;

  late DatabaseHelper _databaseHelper;

  Future<void> _initializeDatabase() async {
    _databaseHelper = DatabaseHelper();
    await _databaseHelper.initialization();
  }

  @override
  void initState() {
    super.initState();
    _initializeDatabase();

  }


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

  Future<void> _loginUser() async {
    if (_formField.currentState!.validate()) {
      if (_databaseHelper == null) {
        return;
      }

      bool loginSuccessful = await _databaseHelper.checkLoginCredentials(
        usernameController.text,
        passwordController.text,
      );

      if (loginSuccessful) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => DisplayScreen(username: usernameController.text),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid username or password'),
          ),
        );
      }
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
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: usernameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
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
                  keyboardType: TextInputType.emailAddress,
                  controller: dobController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
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
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter the Password',
                    border: OutlineInputBorder(),
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
                      return 'Password length should be more than 8 characters.';
                    }
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    _loginUser();
                    if (_formField.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Successfully Validated'),
                        ),
                      );
                    }
                  },
                  child: Text('Login'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: SizedBox(
                  height: 50,
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
