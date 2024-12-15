import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jk_event_management/router/project_router.dart';
import 'package:jk_event_management/utils/project_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaLoginController extends GetxController {
  var saAdminId = ''.obs;
  var saAdminName = ''.obs;

  late Stream<DocumentSnapshot> saAdminDataStream;

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();

  submit(BuildContext context) async {
    if (await validateFields(context)) {
      String mobileNumber = mobileController.text.trim().toString();
      String password = passwordController.text.trim().toString();

      try {
        await isCheckedSaAdminData(context, mobileNumber, password);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went Wrong '),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.blue,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  validateFields(BuildContext context) async {
    String mobileNumber = mobileController.text.trim();
    String password = passwordController.text.trim();

    if (mobileNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please Provide Mobile Number'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.blue,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }
    if (mobileNumber.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mobile Number must be 10 digits'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.blue,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }
    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please Provide password'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.blue,
          behavior: SnackBarBehavior.floating,
        ),
      );

      return false;
    }

    return true;
  }

  isCheckedSaAdminData(
      BuildContext context, String mobileNumber, String password) async {
    DocumentSnapshot saAdminSnapShot = await FirebaseFirestore.instance
        .collection(ProjectConstants.collectionsaAdmin)
        .doc(ProjectConstants.docsaAdminId)
        .get();

    if (saAdminSnapShot.exists) {
      String storedMobileNumber = saAdminSnapShot['mobilenumber'];
      String storedPassword = saAdminSnapShot['password'];

      if (mobileNumber == storedMobileNumber && password == storedPassword) {
        //to show mobilenumber and password in terminal
        print("Mobile number: $storedMobileNumber\nPassword: $storedPassword");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('saAdmin login Successfully'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.blue,
            behavior: SnackBarBehavior.floating,
          ),
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('mobile', mobileNumber);
        await prefs.setString('password', password);
        await prefs.setString('id', ProjectConstants.docsaAdminId);

        getSaAdminDataDetailsFromPreference();

        clearController(context);
        Get.offNamed(ProjectRouter.SA_HOME_SCREEN);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid Credentials'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.blue,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return false;
      }
    }
  }

  void clearController(BuildContext context) {
    mobileController.clear();
    passwordController.clear();
  }

  Future<void> getSaAdminDataDetailsFromPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mobileNumber = prefs.getString('mobile');
    String? password = prefs.getString('password');
    print("Retrive :\n MobileNumber:$mobileNumber\nPassWord:$password");
  }

  void listensaAdminDataUpdates(BuildContext context, String id) {
    try {
      saAdminDataStream = firebaseFirestore
          .collection(ProjectConstants.collectionsaAdmin)
          .doc(id)
          .snapshots();

      saAdminDataStream.listen((documentSnapshots) {
        if (documentSnapshots.exists) {
          saAdminName.value = documentSnapshots['name'] ?? 'Not Found';
          saAdminId.value = documentSnapshots['sadminid'] ?? 'Not Found';

          print("admin name :${saAdminName.value}");
          print("admin ID :${saAdminId.value}");
        } else {
          print("ID Not Found");
        }
      });
    } catch (e) {
      print("time out");
    }
  }
}
