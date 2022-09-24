import 'package:chatapp/services/database.dart';
import 'package:chatapp/services/sharedpref.dart';
import 'package:chatapp/views/conversationscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  //variables
  DatabaseMethods _data = DatabaseMethods();
  TextEditingController SeachedUser = TextEditingController();
  QuerySnapshot? userSnapShot;

  //functions

  // function to create search list
  Widget SearchList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: userSnapShot?.docs.length,
      itemBuilder: (context, index) {
        return SearchTile(
          otheruser: userSnapShot?.docs[index]["name"],
          Email: userSnapShot?.docs[index]["email"],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(children: [
              Expanded(
                child: Container(
                  // padding: const EdgeInsets.symmetric(
                  //   vertical: 10,
                  //   horizontal: 10,
                  // ),
                  child: TextField(
                    controller: SeachedUser,
                    decoration: const InputDecoration(
                      hintText: "Search Username",
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
                width: 55,
                child: ElevatedButton(
                  onPressed: () {
                    if (SeachedUser.text.isNotEmpty) {
                      _data.getUserByName(SeachedUser.text).then((value) {
                        debugPrint(userSnapShot?.docs[0]["email"]);
                        setState(() {
                          userSnapShot = value;
                        });
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(shape: const CircleBorder()),
                  child: const Icon(Icons.search),
                ),
              ),
              // ),
            ]),
          ),
          (userSnapShot != null) ? SearchList() : Container(),
        ],
      ),
    );
  }
}

class SearchTile extends StatelessWidget {
  //vairables
  Shared shared = Shared();
  final String otheruser;
  final String Email;
  String myuser = "s";
  String chatRoomId = "";
  final DatabaseMethods _data = DatabaseMethods();

  SearchTile({Key? key, required this.otheruser, required this.Email})
      : super(key: key);

  //functions
  String createChatRoomID(String a, String b) {
    int x = a.compareTo(b);
    if (x == -1) {
      String temp = a;
      a = b;
      b = temp;
    }
    String ans = a;
    ans += '@';
    ans += b;
    return ans;
  }

  // ignore: non_constant_identifier_names
  RunOnClick() async {
    myuser = await Shared.getMyName();
    debugPrint(myuser);
    chatRoomId = createChatRoomID(myuser, otheruser);
    List<String> user = [myuser, otheruser];
    Map<String, dynamic> chatroom = {
      "chatroomid": chatRoomId,
      "users": user,
    };
    await _data.addChatRoom(chatroom, chatRoomId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                otheruser,
                style: const TextStyle(letterSpacing: 2),
              ),
              Text(
                Email,
                style: const TextStyle(letterSpacing: 2),
              ),
            ],
          ),
          Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
            onPressed: () async {
              await RunOnClick();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return ConversationScreen(
                    ChatRoomId: chatRoomId,
                    myuser: myuser,
                    otheruser: otheruser,
                  );
                }),
              );
            },
            child: const Text("message"),
          ),
        ],
      ),
    );
  }
}
