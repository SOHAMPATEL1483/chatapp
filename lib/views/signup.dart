import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/services/sharedpref.dart';
import 'package:chatapp/views/signin.dart';
import 'package:flutter/material.dart';
import 'homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  //variables
  TextEditingController EmailController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();
  TextEditingController UsernameController = TextEditingController();
  bool isloading = false;
  final formkey = GlobalKey<FormState>();
  AuthService authService = AuthService();
  DatabaseMethods databaseMethods = DatabaseMethods();
  //functions
  // ignore: non_constant_identifier_names

  SignMeUp() async {
    if (formkey.currentState != null) {
      if (formkey.currentState!.validate()) {
        setState(() {
          isloading = true;
        });
      }
      await authService.SignUpEmailPassword(
              EmailController.text, PasswordController.text)
          .then(
        (value) async {
          if (value != null) {
            Map<String, String> userdata = {
              "email": EmailController.text,
              "name": UsernameController.text
            };

            await databaseMethods.AddUserInfo(userdata);

            await Shared.setIsLoggedIn(true);
            await Shared.setMyEmail(EmailController.text);
            await Shared.setMyName(UsernameController.text);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          }
        },
      );
    }
  }

  // build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
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
                            return val!.isEmpty || val.length < 3
                                ? "Enter Username 3+ characters"
                                : null;
                          },
                          controller: UsernameController,
                          decoration: const InputDecoration(
                            hintText: "Username",
                          ),
                        ),
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
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder()),
                      onPressed: SignMeUp,
                      child: const Text("Sign Up"),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have account?  "),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  SignIn(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                          );
                        },
                        child: const Text("Sign In"),
                      )
                    ],
                  )
                ],
              ),
            ),
    );
  }
}
