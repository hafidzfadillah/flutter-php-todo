import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:messaging_app/api.dart';
import 'package:messaging_app/custom_components.dart';
import 'package:messaging_app/models/model_user.dart';
import 'package:messaging_app/screens/parent.dart';
import 'package:messaging_app/signin_helper.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  void signingIn() async {
    EasyLoading.show(status: 'Please wait..');
    var user = await GoogleSignInHelper().signInWithGoogle();

    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');

    final doc = await users.doc(user!.uid).get();

    if (!doc.exists) {
      final newUser = {
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
        'photoURL': user.photoURL,
      };

      await users.doc(user.uid).set(newUser);
      final rsp = await API().tambahUser(ModelUser(
          userId: '-',
          userUid: user.uid,
          userEmail: user.email ?? 'guest@mail.com',
          userNama: user.displayName ?? 'Guest',
          userImg: user.photoURL ??
              'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png'));

      print("Response Add User: ${rsp.body}");
    }
    var pref = await SharedPreferences.getInstance();
    pref.setString(USER_ID, user.uid);
    pref.setString(USER_NAME, user.displayName!);
    pref.setString(USER_EMAIL, user.email!);
    // pref.setString(USER_PHONE, user.phoneNumber!);
    pref.setString(
        USER_IMG,
        user.photoURL ??
            'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png');

    EasyLoading.showSuccess('Signing in success');
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => ParentScreen()));
  }

  void cekSession() async {
    EasyLoading.show(status: 'Checking session');
    if (GoogleSignInHelper().isUserLoggedIn()) {
      await Future.delayed(Duration(seconds: 2));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => ParentScreen()));
    } else {}
    EasyLoading.dismiss();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cekSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(4.h),
        child: Column(
          children: [
            Expanded(
                child: Center(
              child: Image.asset(
                'assets/images/chat.png',
                width: 50.w,
              ),
            )),
            Expanded(
                child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.h),
                child: MyText(
                  'A new way to connect with your friends',
                  weight: FontWeight.w600,
                  size: 24,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
            )),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.h))),
                  onPressed: () {
                    signingIn();
                  },
                  icon: Image.asset(
                    'assets/images/search.png',
                    width: 3.h,
                  ),
                  label: MyText('Sign In with Google')),
            )
          ],
        ),
      ),
    );
  }
}
