import 'dart:ui';

import 'package:chatapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/services.dart';

class ConversationScreen extends StatefulWidget {
  String? ChatRoomId;
  String? myuser;
  String? otheruser;
  ConversationScreen(
      {Key? key,
      required this.ChatRoomId,
      required this.myuser,
      required this.otheruser})
      : super(key: key);

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  // variables
  TextEditingController messageTextEditingController = TextEditingController();
  DatabaseMethods databaseMethods = DatabaseMethods();
  late Stream<QuerySnapshot> chatstream;
  final ScrollController _scrollController = ScrollController();
  bool ischatstreamstarted = false;

  //functions
  sendMessage() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    Map<String, dynamic> messagemap = {
      "message": messageTextEditingController.text,
      "sendby": widget.myuser,
      "time": DateTime.now().millisecondsSinceEpoch
    };
    databaseMethods.addmessage(widget.ChatRoomId, messagemap);
    messageTextEditingController.clear();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  Widget chatbuilder() {
    return StreamBuilder(
      stream: chatstream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: (snapshot.data! as QuerySnapshot).docs.length,
                controller: _scrollController,
                itemBuilder: (context, index) {
                  return messageTile(
                      message: (snapshot.data! as QuerySnapshot).docs[index]
                          ["message"],
                      sendbyme: ((snapshot.data! as QuerySnapshot).docs[index]
                                  ["sendby"] ==
                              widget.myuser)
                          ? true
                          : false);
                },
              )
            : Container();
      },
    );
  }

  //build methods
  @override
  void initState() {
    // TODO: implement initState
    databaseMethods.getchats(widget.ChatRoomId).then((value) {
      setState(() {
        chatstream = value;
        ischatstreamstarted = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.otheruser.toString()),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Stack(
          children: [
            ischatstreamstarted
                ? Container(
                    padding: const EdgeInsets.only(bottom: 60),
                    child: chatbuilder())
                : Container(),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Row(children: [
                Expanded(
                  child: Container(
                    // padding: const EdgeInsets.symmetric(
                    //   vertical: 10,
                    //   horizontal: 10,
                    // ),
                    child: TextField(
                      controller: messageTextEditingController,
                      decoration: const InputDecoration(
                        hintText: "....",
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      if (messageTextEditingController.text.isNotEmpty) {
                        sendMessage();
                      }
                    },
                    style:
                        ElevatedButton.styleFrom(shape: const CircleBorder()),
                    child: const Icon(Icons.send),
                  ),
                ),
                // ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}

class messageTile extends StatelessWidget {
  final String message;
  final bool sendbyme;
  const messageTile({Key? key, required this.message, required this.sendbyme})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8, bottom: 8, left: sendbyme ? 0 : 8, right: sendbyme ? 8 : 0),
      alignment: sendbyme ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: sendbyme
            ? const EdgeInsets.only(left: 30)
            : const EdgeInsets.only(right: 30),
        padding:
            const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
          borderRadius: sendbyme
              ? const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                )
              : const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
          color: sendbyme
              ? const Color.fromARGB(255, 218, 207, 239)
              : const Color.fromARGB(255, 218, 207, 239),
        ),
        child: Text(
          message,
          textAlign: TextAlign.start,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
