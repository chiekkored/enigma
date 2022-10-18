import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enigma/core/providers/user_provider.dart';
import 'package:enigma/views/commons/popups_commons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// SECTION NewProfileViewModel
/// NewProfileViewModel Class
///
/// @author Thomas Rey B Barcenas
class NewProfileViewModel {
  /// SECTION updateProfile
  /// Function for updating the profile of a New User
  ///
  /// @param photoURL URL string for the user's avatar
  /// @param displayName string for user's display name
  /// @param fullName string for user's full name
  /// @param age string for user's age
  /// @param school string for user's school
  ///
  /// @author Thomas Rey B Barcenas
  Future<bool> updateProfile(
    String photoURL,
    String displayName,
    String fullName,
    String age,
    String school,
    String uid,
    List<String> academicInterests,
    List<String> sportsInterests,
    List<String> gameInterests,
    List<String> tvShowInterests,
  ) async {
    String imageURL = '';
    FirebaseAuth user = FirebaseAuth.instance;
    DateTime now = DateTime.now();
    final storageRef = FirebaseStorage.instance.ref();
    Reference storageRefPath = storageRef.child('users/$uid/resources/$now');
    if (school == '') {
      // NOTE only goes through here when schoolTextController.text is empty because school is already populated in the database
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.currentUser!.uid)
          .collection('interests')
          .doc('academics')
          .set(
        {"name": "Academics", "interestList": academicInterests},
      );
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.currentUser!.uid)
          .collection('interests')
          .doc('sports')
          .set(
        {"name": "Sports", "interestList": sportsInterests},
      );
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.currentUser!.uid)
          .collection('interests')
          .doc('games')
          .set(
        {"name": "Games", "interestList": gameInterests},
      );
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.currentUser!.uid)
          .collection('interests')
          .doc('tvShows')
          .set(
        {"name": "TV Shows", "interestList": tvShowInterests},
      );
      if (photoURL.split('.').last != 'svg') {
        await storageRefPath.putFile(File(photoURL));
        imageURL = await storageRefPath.getDownloadURL();
      } else {
        const key = "avatar";
        final file =
            await DefaultCacheManager().getSingleFile(photoURL, key: key);
        await storageRefPath.putFile(file);
        imageURL = await storageRefPath.getDownloadURL();
      }

      return FirebaseFirestore.instance
          .collection('users')
          .doc(user.currentUser!.uid)
          .update({
            "photoURL": imageURL,
            "displayName": displayName,
            "fullName": fullName,
            "age": age,
          })
          .then((value) => true)
          .catchError((err) {
            debugPrint(err);
            return false;
          });
    } else {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.currentUser!.uid)
          .collection('interests')
          .add(
        {"name": "Academics", "interestList": academicInterests},
      );
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.currentUser!.uid)
          .collection('interests')
          .add(
        {"name": "Sports", "interestList": sportsInterests},
      );
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.currentUser!.uid)
          .collection('interests')
          .add(
        {"name": "Games", "interestList": gameInterests},
      );
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.currentUser!.uid)
          .collection('interests')
          .add(
        {"name": "TV Shows", "interestList": tvShowInterests},
      );
      if (photoURL.split('.').last != 'svg') {
        await storageRefPath.putFile(File(photoURL));
        imageURL = await storageRefPath.getDownloadURL();
      } else {
        const key = "avatar";
        final file =
            await DefaultCacheManager().getSingleFile(photoURL, key: key);
        await storageRefPath.putFile(file);
        imageURL = await storageRefPath.getDownloadURL();
      }
      return FirebaseFirestore.instance
          .collection('users')
          .doc(user.currentUser!.uid)
          .update({
            "photoURL": imageURL,
            "displayName": displayName,
            "fullName": fullName,
            "age": age,
            "school": school
          })
          .then((value) => true)
          .catchError((err) {
            debugPrint(err);
            return false;
          });
    }
  }

  // !SECTION
}

/// !SECTION
