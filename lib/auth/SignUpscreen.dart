
import 'package:crudapp/Widget/roundedButoon.dart';
import 'package:crudapp/auth/loginScreen.dart';
import 'package:crudapp/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpscreen extends StatefulWidget {
  const SignUpscreen({Key? key}) : super(key: key);

  @override
  State<SignUpscreen> createState() => _SignUpscreenState();
}

class _SignUpscreenState extends State<SignUpscreen> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>(); // use  to check whether the form is filled correctly or not
  final emailController = TextEditingController();
  final passWordController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passWordController.dispose();
  }
  void isLogin(){
    if(_formKey.currentState!.validate()){
      //signup krne prr kuch action nhi mil rha  h isilieh isko use kr rhe h//
      setState(() {
        loading = true ;
      });
      // to create user with email and password //
      _auth.createUserWithEmailAndPassword(email: emailController.text.toString(),
          password: passWordController.text.toString()).then((value) {
        setState(() {
          loading = false;
        });
      }).onError((error, stackTrace) {
        Utils().toastMessage(error.toString());
        setState(() {
          loading = false;
        });
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

            RoundButton(title: "Sign Up", onTap: (){
             isLogin();
            }, loading: loading,),
            const SizedBox(height: 40,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Already Have an account"),
                TextButton(child: const Text('Login'), onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
                },)
              ],
            )

          ],
        ),
      ),
    );
  }
}
