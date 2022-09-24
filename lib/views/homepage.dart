import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/services/sharedpref.dart';
import 'package:chatapp/views/search.dart';
import 'package:chatapp/views/signin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'conversationscreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //variables
  final AuthService _auth = AuthService();
  DatabaseMethods databaseMethods = DatabaseMethods();
  String myname = "";
  late Stream chatstream;
  bool isstreaminitialized = false;
  //functions

  //build method

  Widget ChatRoomList() {
    return StreamBuilder(
        stream: chatstream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: (snapshot.data! as QuerySnapshot).docs.length,
                  shrinkWrap: true,
                  itemBuilder: (cotext, index) {
                    return ChatRoomTile(
                      ChatRoomId: (snapshot.data! as QuerySnapshot).docs[index]
                          ["chatroomid"],
                      otheruser: (snapshot.data! as QuerySnapshot)
                          .docs[index]["chatroomid"]
                          .toString()
                          .replaceAll('@', "")
                          .replaceAll(myname, ""),
                    );
                  },
                )
              : Container();
        });
  }

  temp() async {
    Shared.getMyName().then((value) async {
      myname = value;
      chatstream = await databaseMethods.getchatforuser(myname);
      setState(() {
        isstreaminitialized = true;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    temp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () {
              Shared.clearData();
              _auth.SignOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => SignIn(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: const Icon(Icons.exit_to_app),
            ),
          )
        ],
      ),
      body: isstreaminitialized ? ChatRoomList() : Container(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.search),
        onPressed: () {
          Shared.getIsLoggedIn().then(
            (value) => debugPrint(value.toString()),
          );
          Shared.getMyName().then(
            (value) => debugPrint(value.toString()),
          );
          Shared.getMyEmail().then(
            (value) => debugPrint(value.toString()),
          );
          // ignore: use_build_context_synchronously
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchPage()));
        },
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  String otheruser;
  String ChatRoomId;
  ChatRoomTile({Key? key, required this.otheruser, required this.ChatRoomId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) {
            return ConversationScreen(
              ChatRoomId: ChatRoomId,
              myuser: ChatRoomId.toString()
                  .replaceAll("@", "")
                  .replaceAll(otheruser, ""),
              otheruser: otheruser,
            );
          }),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey),
          ),
        ),
        child: Text(
          otheruser,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
