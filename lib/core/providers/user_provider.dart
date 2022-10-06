import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enigma/core/models/user_model.dart';
import 'package:enigma/core/viewmodels/auth_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// SECTION AuthViewModel
/// UserProvider Class
///
/// @author Thomas Rey B Barcenas
class UserProvider extends ChangeNotifier {
  /// ANCHOR Global Variables
  final UserModel _user = UserModel();
  UserModel get userInfo => _user;

  /// SECTION setNewUser
  /// Provider function used in Creating a new user
  ///
  /// @param userCredentials data passed in setting up user data in Firestore
  ///
  /// @author Thomas Rey B Barcenas
  Future<void> setNewUser(User userCredentials) async {
    AuthViewModel authVM = AuthViewModel();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredentials.uid)
        .set({
      "uid": userCredentials.uid,
      "displayName": userCredentials.email!
          .substring(0, userCredentials.email!.indexOf('@')),
      "email": userCredentials.email,
      "photoURL": 'https://via.placeholder.com/150',
      "status": 'unverified',
      "fullName": '',
      "age": '',
      "school": '',
    }).then((value) async {
      _user.uid = userCredentials.uid;
      _user.displayName = userCredentials.email!
          .substring(0, userCredentials.email!.indexOf('@'));
      _user.email = userCredentials.email ?? '';
      _user.photoURL = 'https://via.placeholder.com/150';
      return userCredentials;
    }).then((document) => authVM.setNewPreferences(document));
  }

  /// !SECTION

  /// SECTION setUser
  /// Provider function responsible for setting a sort of "global" usage of the signed in user's credentials
  ///
  /// @param uid UID obtained from the Firestore database of the logged in user
  ///
  /// @author Thomas Rey B Barcenas
  Future<void> setUser(String uid) async {
    AuthViewModel authVM = AuthViewModel();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        print(documentSnapshot['school']);
        _user.uid = documentSnapshot['uid'];
        _user.displayName = documentSnapshot['displayName'];
        _user.email = documentSnapshot['email'];
        _user.photoURL = documentSnapshot['photoURL'];
        _user.school = documentSnapshot['school'];
        return documentSnapshot;
      }
    }).then((document) => authVM.setPreferences(document!));
  }

  /// SECTION setUser
  /// Provider function responsible for setting a sort of "global" usage of the signed in user's credentials
  ///
  /// @param uid UID obtained from the Firestore database of the logged in user
  ///
  /// @author Thomas Rey B Barcenas
  Future<bool> getUserPreference() async {
    return await SharedPreferences.getInstance().then((pref) {
      if (pref.getString('user') != null) {
        final data = jsonDecode(pref.getString('user')!);
        _user.uid = data["uid"];
        _user.email = data["email"];
        _user.displayName = data["displayName"];
        _user.photoURL = data["photoURL"];
        _user.school = data["school"];
        return true;
      } else {
        return false;
      }
    });
  }

  /// !SECTION

}

/// !SECTION
