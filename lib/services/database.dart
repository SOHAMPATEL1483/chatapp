import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class DatabaseMethods {
  Future getUserByName(String username) {
    return FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .get();
  }

  getUserByEmail(String email) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get();
  }

  Future? AddUserInfo(userdata) {
    FirebaseFirestore.instance
        .collection("users")
        .add(userdata)
        .catchError((e) {
      debugPrint(e.toString());
    });
  }

  addChatRoom(chatroom, chatRoomId) {
    FirebaseFirestore.instance
        .collection("chatroom")
        .doc(chatRoomId)
        .set(chatroom)
        .catchError((e) {
      debugPrint(e.toString());
    });
  }

  addmessage(chatRoomId, messagemap) {
    FirebaseFirestore.instance
        .collection("chatroom")
        .doc(chatRoomId)
        .collection("chat")
        .add(messagemap)
        .catchError((e) {
      debugPrint(e.toString());
    });
  }

  getchats(chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatroom")
        .doc(chatRoomId)
        .collection("chat")
        .orderBy("time")
        .snapshots();
  }

  getchatforuser(myname) {
    return FirebaseFirestore.instance
        .collection("chatroom")
        .where("users", arrayContains: myname)
        .snapshots();
  }
}
