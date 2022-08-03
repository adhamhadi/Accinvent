import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:barcode_scanner/screens/widget/header_widget.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../theme_helper/themes.dart';
import 'home.dart';
import 'main_menu.dart';

class LoginPage extends StatefulWidget{

  @override
  _LoginPageState createState() => _LoginPageState();
  }

class _LoginPageState extends State<LoginPage> {
  bool _isloading=false;
  var emailController= TextEditingController();
  var passwordController= TextEditingController();
  double _headerHeight =200;
  Key _formKey=GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,

      body:_isloading? Center(child: CircularProgressIndicator(),):
     SingleChildScrollView(child:
      Column(
        children:[
          Container(
            height: _headerHeight,
            child: HeaderWidget(_headerHeight,true,Icons.login_rounded),
          ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),

              child: Column(
                children: [
                  const Text(
                    'أهلًا بك',
                    style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30.0,),
                  Form(
                    key: _formKey,

                      child:Column(
                        children: [
                          TextField(
                            controller:emailController,
                            decoration: ThemeHelper().textInputDecoration( 'اسم المستخدم', 'أدخل اسم المستخدم'),
                          ),
                          const SizedBox(height: 30.0,),
                          TextField(
                            obscureText: true,
                            controller:passwordController,
                            decoration: ThemeHelper().textInputDecoration( 'كلمة المرور', 'أدخل كلمة المرور'),
                          ),
                          const SizedBox(height:30.0,),
                          Container(
                            decoration: ThemeHelper().buttonBoxDecoration(context),
                            child: ElevatedButton(
                               style: ThemeHelper().buttonStyle(),
                               child:Padding(
                                 padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child:Text('تسجيل دخول'.toUpperCase(),style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
                          ),
                              onPressed:() {
                              login();
                                setState(() {
                                  _isloading=true;
                                });
                                Navigator.push(context,  MaterialPageRoute(builder: (context)=>home()));

                              },
                            )
                          )
                        ],
                      )
                  )
                ],
              ),
            ),
          )
        ],
      ),
     ),
    );
  }
  Future<void> login() async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    var Role='';
    if(passwordController.text.isNotEmpty && emailController.text.isNotEmpty){
      var response= await http.post(Uri.parse("http://192.168.43.110:8888/api/login"),body:{
        'email': "A@g.com",
       'password' : "12345678"});

     if(response.statusCode==200){
       print('\n\n\ntoken adam');
       var token =json.decode(response.body)['data']['token'];
       Role=json.decode(response.body)['data']['Role'];
       String id=json.decode(response.body)['data']['id'].toString();
       print(token);
       var token1="Bearer "+token;
    //   var token =json.decode(response.body)['token'];
       setState(() {
         _isloading=false;
         sharedPreferences.setString('token', token1);
         sharedPreferences.setString('Role', Role);
         sharedPreferences.setString('user_id', id);
         Navigator.push(context,  MaterialPageRoute(builder: (context)=>menuPage()));
       });

     }else{
       _isloading=false;
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:  Text("invalid Credentials."),));
     }
    } else{
      _isloading=false;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Black field not allowed"),));
    }

  }
}
