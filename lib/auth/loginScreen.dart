
import 'package:crudapp/Widget/roundedButoon.dart';

import 'package:crudapp/auth/SignUpscreen.dart';
import 'package:crudapp/auth/posts.dart';
import 'package:crudapp/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  // use  to check whether the form is filled correctly or not
  final emailController = TextEditingController();
  final passWordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passWordController.dispose();
  }
  void login(){
    setState(() {
      loading=true;
    });
    _auth.signInWithEmailAndPassword(email: emailController.text, password: passWordController.text.toString()).then((value) {
      Utils().toastMessage(value.user!.email.toString());
      Navigator.push(context, MaterialPageRoute(builder: (context)=>const PostScreen()));
      setState(() {
        loading=false;
      });
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      Utils().toastMessage(error.toString());
    });

  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // this will allow to leave app screen with navigation of going back
      onWillPop: () async {
        SystemNavigator.pop();
        return true ;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Login'),
        automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                // this is used to check whether form is completely filled or not
                key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'Email',
                          hoverColor: Colors.blueAccent,
                          prefixIcon: Icon(Icons.email)
                        ),
                        // validator to validate it will late use while submiting in if N else condition
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Enter Email';
                          }
                          return null ;
                        },
                      ),
                      const SizedBox(height: 30,),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: passWordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'password',
                          hoverColor: Colors.blueAccent,
                          prefixIcon: Icon(Icons.password)
                        ),
                        // remember validator here is used to chechk form field
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Enter password';
                          }
                          return null ;
                        },
                      ),
                      const SizedBox(height: 50,),
                    ],
                  )

              ),

              RoundButton(title: "Login", loading: loading, onTap: (){
                if(_formKey.currentState!.validate()){
                  login();
                };
              }, ),
              const SizedBox(height: 40,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Don't Have an account"),
                  TextButton(child: const Text('SignUp'), onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const SignUpscreen()));
                  },),


                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
