import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseHelper {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static CollectionReference get users => FirebaseFirestore.instance.collection('users');
  static CollectionReference get individualProfile => FirebaseFirestore.instance.collection('individuals');
  static CollectionReference get businessProfile => FirebaseFirestore.instance.collection('businesses');
  static CollectionReference get contentCreatorProfile => FirebaseFirestore.instance.collection('contentCreators');
  static CollectionReference get professionalProfile => FirebaseFirestore.instance.collection('professionals');
  static CollectionReference get posts => FirebaseFirestore.instance.collection('posts');
  static CollectionReference get videos => FirebaseFirestore.instance.collection('videos');
  static CollectionReference get audios => FirebaseFirestore.instance.collection('audios');
  static CollectionReference get memories => FirebaseFirestore.instance.collection('memories');
  static CollectionReference get chats => FirebaseFirestore.instance.collection('chats');
  //Current User Dto
  static String get currentUserId => _auth.currentUser?.uid ?? '';
  static DocumentReference get currentUserDoc => FirebaseFirestore.instance.collection('users').doc(currentUserId);
}
