import 'package:cloud_firestore/cloud_firestore.dart';

///// Database Collections

class Room {
  String roomId;
  String requestDocId;
  String requester;
  String requestCategory;
  String requesterDisplayName;
  String requesterPhotoUrl;
  String requestCompensation;
  String serviceProvider;
  String serviceProviderPhotoUrl;
  String serviceProviderDisplayName;
  String serviceProviderUid;
  

  Room({
    this.roomId,
    this.requestDocId,
    this.requester,
    this.requestCategory,
    this.requesterDisplayName,
    this.requesterPhotoUrl,
    this.requestCompensation,
    this.serviceProvider,
    this.serviceProviderPhotoUrl,
    this.serviceProviderDisplayName,
    this.serviceProviderUid
  });
}

class Request {
  String docId;
  String status;
  String id;
  String category;
  String location;
  String compensation;
  String description;
  String requesterUid;
  String requesterEmail;
  String requesterDisplayName;
  String requesterPhotoUrl;
  List serviceProviders;
  Timestamp lastUpdated;

  Request(
      {this.docId,
      this.status,
      this.id,
      this.category,
      this.location,
      this.compensation,
      this.description,
      this.requesterUid,
      this.requesterEmail,
      this.requesterDisplayName,
      this.requesterPhotoUrl,
      this.serviceProviders,
      this.lastUpdated});

}

class User {
  String uid;
  String email;
  bool emailVerified;
  String phoneNumber;
  String displayName;
  String photoUrl;
  String status;
  DateTime lastActivity;

  User({this.uid, this.email,this.emailVerified,this.phoneNumber, this.displayName, this.photoUrl, this.status, this.lastActivity});

  factory User.fromMap(Map data) {
    return User(
        uid: data['uid'],
        email: data['email'] ?? '',
        emailVerified: data['emailVerified'],
        phoneNumber: data['phoneNumber'] ?? '',
        displayName: data['displayName'] ?? '',
        photoUrl: data['photoUrl'] ?? '',
        status: data['status'] ?? '',
        lastActivity: data['lastActivity']);
  }
}
