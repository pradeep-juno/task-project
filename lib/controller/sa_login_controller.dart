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
        bool isSuperAdmin =
            await isCheckedSaAdminData(context, mobileNumber, password);
        if (isSuperAdmin) return;

        // Check for Staff login if Super Admin login fails
        bool isStaff =
            await isCheckedStaffLoginData(mobileNumber, password, context);

        if (!isStaff) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid Credentials 18 '),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.blue,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (e) {
        /*ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went Wrong '),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.blue,
            behavior: SnackBarBehavior.floating,
          ),
        );*/

        print("Error during login: $e");
      }
    }
  }

  //--------------------------This is for Staff Login -------------------------
  Future<bool> isCheckedStaffLoginData(
      String mobileNumber, String password, BuildContext context) async {
    print("StaffAdminLogin");

    QuerySnapshot staffSnapshot = await FirebaseFirestore.instance
        .collection(ProjectConstants.collectionStaff)
        .where('staffMobileNumber', isEqualTo: mobileNumber)
        .where('staffPassword', isEqualTo: password)
        .get();

    if (staffSnapshot.docs.isNotEmpty) {
      var staffData = staffSnapshot.docs.first;
      String staffName = staffData['staffName'];
      String staffId = staffData['staffId'];

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Welcome $staffName'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.blue,
          behavior: SnackBarBehavior.floating,
        ),
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setString('staffId', staffId);

      getSaAdminDataDetailsFromPreference();

      clearController(context);
      Get.offNamed(ProjectRouter.STAFF_HOME_SCREEN);

      return true;
    }
    return false;
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
    print("SuperAdminLogin");

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
        return true;
      }
    }
    return false;
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
