import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyA6mTyrnkf_M9BoBFO2o-gZ5cs_HL_9jMA",
            authDomain: "b-e-project-u-i-7uwhtn.firebaseapp.com",
            projectId: "b-e-project-u-i-7uwhtn",
            storageBucket: "b-e-project-u-i-7uwhtn.appspot.com",
            messagingSenderId: "863729529651",
            appId: "1:863729529651:web:1d721d2f0a89ca66be8446"));
  } else {
    await Firebase.initializeApp();
  }
}
