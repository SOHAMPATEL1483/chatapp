import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/services/sharedpref.dart';
import 'package:chatapp/views/signup.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'homepage.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  //variables
  TextEditingController EmailController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();
  final formkey = GlobalKey<FormState>();
  bool isloading = false;
  AuthService authService = AuthService();
  DatabaseMethods databaseMethods = DatabaseMethods();
  Shared shared = Shared();
  // Functions

  SignMeIn() async {
    if (formkey.currentState != null) {
      if (formkey.currentState!.validate()) {
        setState(() {
          isloading = true;
        });
      }
      await authService.SignInEmailPassword(
              EmailController.text, PasswordController.text)
          .then(
        (value) {
          if (value != null) {
            Shared.setIsLoggedIn(true);
            Shared.setMyEmail(EmailController.text);
            databaseMethods
                .getUserByEmail(EmailController.text)
                .then((userSnapShot) {
              Shared.setMyName(userSnapShot.docs[0]["name"]);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
              );
            });
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
        elevation: 0,
      ),
      body: isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 350, bottom: 20),
              child: Column(
                children: [
                  Form(
                    key: formkey,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (val) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val!)
                                ? null
                                : "Enter correct email";
                          },
                          controller: EmailController,
                          decoration: const InputDecoration(
                            hintText: "Email",
                          ),
                        ),
                        TextFormField(
                          validator: (val) {
                            return val!.length < 6
                                ? "Enter Password 6+ characters"
                                : null;
                          },
                          obscureText: true,
                          controller: PasswordController,
                          decoration: const InputDecoration(
                            hintText: "Password",
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder()),
                      onPressed: SignMeIn,
                      child: const Text("Sign In"),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have account?  "),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  SignUp(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                          );
                        },
                        child: const Text("Sign Up"),
                      )
                    ],
                  )
                ],
              ),
            ),
    );
  }
}
