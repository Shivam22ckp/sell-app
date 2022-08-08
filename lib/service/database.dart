import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sellapp/service/shared_pref.dart';

class DatabaseMethods {
  Future addUserDetail(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }

  Future addUserSellingItem(
      Map<String, dynamic> userInfoMap, String data, String id) async {
    return await FirebaseFirestore.instance
        .collection(data)
        .doc(id)
        .set(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getSearchedItem(String data) async {
    return FirebaseFirestore.instance.collection(data).snapshots();
  }

  Future<Stream<QuerySnapshot>> getOwnItem(String data) async {
    return FirebaseFirestore.instance
        .collection("Product")
        .where("AdminId", isEqualTo: data)
        .snapshots();
  }

  Future<QuerySnapshot> Search(String date) async {
    return await FirebaseFirestore.instance
        .collection("Product")
        .where("Key", isEqualTo: date.substring(0, 1).toUpperCase())
        .get();
  }

  Future addUserItem(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Product")
        .doc(id)
        .set(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getLocatedItems() async {
    return FirebaseFirestore.instance.collection("Product").snapshots();
  }

  Future<Stream<QuerySnapshot>> getUserByUserName(String username) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: username)
        .snapshots();
  }

  Future addMessage(String chatRoomId, String messageId,
      Map<String, dynamic> messageInfoMap) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .doc(messageId)
        .set(messageInfoMap);
  }

  Future addSoldItem(String Id, Map<String, dynamic> messageInfoMap) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(Id)
        .collection("Sold")
        .add(messageInfoMap);
  }

  Future addBuyItem(String Id, Map<String, dynamic> messageInfoMap) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(Id)
        .collection("Buy")
        .add(messageInfoMap);
  }

  updateLastMessageSend(
      String chatRoomId, Map<String, dynamic> lastMessageInfoMap) {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .update(lastMessageInfoMap);
  }

  createChatRoom(
      String chatRoomId, Map<String, dynamic> chatRoomInfoMap) async {
    final snapShot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .get();

    if (snapShot.exists) {
      // chatroom already exists
      return true;
    } else {
      // chatroom does not exists
      return FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }

  Future<Stream<QuerySnapshot>> getChatRoomMessages(chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("ts", descending: true)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getSoldItem(chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(chatRoomId)
        .collection("Sold")
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getBuyItem(chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(chatRoomId)
        .collection("Buy")
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getChatRooms() async {
    String? myUsername = await SharedPreferenceHelper().getUserName();
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .orderBy("lastMessageSendTs", descending: true)
        .where("users", arrayContains: myUsername)
        .snapshots();
  }

  Future<QuerySnapshot> getUserInfo(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: username)
        .get();
  }
}
