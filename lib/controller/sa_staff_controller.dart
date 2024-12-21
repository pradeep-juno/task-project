import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/staff_model.dart';
import '../utils/functions.dart';
import '../utils/project_constants.dart';

class SaStaffController extends GetxController {
  RxList<StaffModel> staffList = <StaffModel>[].obs;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  // Reactive list for department and position names
  RxList<String> departmentList = <String>[].obs;
  RxList<String> positionList = <String>[].obs;

  var buttonName = ''.obs;
  var staffId = ''.obs;
  var currentDateTime = ''.obs;

  RxBool isButtonClicked =
      false.obs; // isButtonClicked declare for clickable (add employee button)

  RxString selectedDepartment = ''.obs; // fetch the dept data
  RxString selectedPosition = ''.obs; //fetch the position data

  void toggleButton() {
    isButtonClicked.value =
        !isButtonClicked.value; // call for all button operations
  }

  final staffNameController = TextEditingController();
  final staffDateOfJoiningController = TextEditingController();
  final staffMobileNumberController = TextEditingController();
  final staffPasswordController = TextEditingController();
  final staffDateOfBirthController = TextEditingController();
  final staffMobileNumberTwoController = TextEditingController();
  final staffAddressController = TextEditingController();

  // After clicking done in staff screen this method do all validations to do ADD & UPDATE

  // Function to Save Staff Data
  Future<void> saveStaffData(
    BuildContext context,
    String? staffId,
  ) async {
    // Step 1: Validate Input Fields
    if (await validateStaffField(context)) {
      // Step 2: Retrieve Admin ID from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String id = prefs.getString('id') ?? 'Not Available';

      if (staffId != null) {
        var adminSnapshot = await firebaseFirestore
            .collection(ProjectConstants.collectionsaAdmin)
            .doc(id)
            .get();

        if (adminSnapshot.exists) {
          // Step 4: Retrieve Admin Details
          String saAdminName = adminSnapshot['name'] ?? 'Not Found';
          String saAdminId = adminSnapshot['sadminid'] ?? 'Not Found';

          print("admin name: $saAdminName");
          print("admin ID: $saAdminId");

          // Step 5: Prepare Data for Staff Entry

          var docRef = firebaseFirestore
              .collection(ProjectConstants.collectionStaff)
              .doc(staffId);

          // Step 6: Fetch Department Data
          var departmentSnapshot = await firebaseFirestore
              .collection(ProjectConstants.collectionDept)
              .where('deptName', isEqualTo: selectedDepartment.value)
              .limit(1)
              .get();

          final departmentId = departmentSnapshot.docs.isNotEmpty
              ? departmentSnapshot.docs.first.id
              : '';

          // Step 7: Fetch Position Data
          var positionSnapshot = await firebaseFirestore
              .collection(ProjectConstants.collectionPosition)
              .where('positionName', isEqualTo: selectedPosition.value)
              .limit(1)
              .get();

          final positionId = positionSnapshot.docs.isNotEmpty
              ? positionSnapshot.docs.first.id
              : '';

          // Step 8: Create Staff Data Object
          var staffData = StaffModel(
            staffId: staffId,
            staffName: staffNameController.text.trim(),
            staffJoiningDate: staffDateOfJoiningController.text.trim(),
            staffMobileNumber: staffMobileNumberController.text.trim(),
            staffPassword: staffPasswordController.text.trim(),

            deptId: departmentId,
            deptName: selectedDepartment.value,
            positionId: positionId,
            positionName: selectedPosition.value,

            staffDob: staffDateOfBirthController.text.trim(),
            staffMobileNumberTwo: staffMobileNumberTwoController.text.trim(),
            staffAddress: staffAddressController.text.trim(),
            staffCreatedAt: DateTime.parse(currentDateTime.value),
            createdByName: saAdminName, // Assign the admin name here
            createdById: saAdminId, // Assign the admin ID here
          );

          // Step 9: Save Staff Data to Firestore
          await docRef.update(staffData.toMap());

          print("StaffData : ${staffData.toString()}");

          // Step 10: Display Success Message
          buildScaffoldMessage(context, 'Staff Updated Successfully');

          // Step 11: Clear Form and Reset UI
          clearController(context);
          toggleButton();
          fetchStaff();
        } else {
          // Step 12: Handle Missing Admin Document Case
          print("Admin Data not found!");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Admin data not found!',
                style: TextStyle(fontSize: 12, color: Colors.red),
              ),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.orangeAccent,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        var adminSnapshot = await firebaseFirestore
            .collection(ProjectConstants.collectionsaAdmin)
            .doc(id)
            .get();

        if (adminSnapshot.exists) {
          // Step 4: Retrieve Admin Details
          String saAdminName = adminSnapshot['name'] ?? 'Not Found';
          String saAdminId = adminSnapshot['sadminid'] ?? 'Not Found';

          print("admin name: $saAdminName");
          print("admin ID: $saAdminId");

          // Step 5: Prepare Data for Staff Entry
          var currentDateTime = DateTime.now();
          var docRef = firebaseFirestore
              .collection(ProjectConstants.collectionStaff)
              .doc();
          var staffId = docRef.id; // Generate a unique staff ID

          // Step 6: Fetch Department Data
          var departmentSnapshot = await firebaseFirestore
              .collection(ProjectConstants.collectionDept)
              .where('deptName', isEqualTo: selectedDepartment.value)
              .limit(1)
              .get();

          final departmentId = departmentSnapshot.docs.isNotEmpty
              ? departmentSnapshot.docs.first.id
              : '';

          // Step 7: Fetch Position Data
          var positionSnapshot = await firebaseFirestore
              .collection(ProjectConstants.collectionPosition)
              .where('positionName', isEqualTo: selectedPosition.value)
              .limit(1)
              .get();

          final positionId = positionSnapshot.docs.isNotEmpty
              ? positionSnapshot.docs.first.id
              : '';

          // Step 8: Create Staff Data Object
          var staffData = StaffModel(
            staffId: staffId,
            staffName: staffNameController.text.trim(),
            staffJoiningDate: staffDateOfJoiningController.text.trim(),
            staffMobileNumber: staffMobileNumberController.text.trim(),
            staffPassword: staffPasswordController.text.trim(),

            deptId: departmentId,
            deptName: selectedDepartment.value,
            positionId: positionId,
            positionName: selectedPosition.value,

            staffDob: staffDateOfBirthController.text.trim(),
            staffMobileNumberTwo: staffMobileNumberTwoController.text.trim(),
            staffAddress: staffAddressController.text.trim(),
            staffCreatedAt: currentDateTime,
            createdByName: saAdminName, // Assign the admin name here
            createdById: saAdminId, // Assign the admin ID here
          );

          // Step 9: Save Staff Data to Firestore
          await docRef.set(staffData.toMap());

          print("StaffData : ${staffData.toString()}");

          // Step 10: Display Success Message
          buildScaffoldMessage(context, 'Staff Saved Successfully');

          // Step 11: Clear Form and Reset UI
          clearController(context);
          toggleButton();
          fetchStaff();
        } else {
          // Step 12: Handle Missing Admin Document Case
          print("Admin Data not found!");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Admin data not found!',
                style: TextStyle(fontSize: 12, color: Colors.red),
              ),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.orangeAccent,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
      // Step 3: Fetch Admin Data from Firestore
    } else {
      print("Validation doesn't Done");
    }
  }

  //-------------------for all Validation done here----------------------
  validateStaffField(BuildContext context) async {
    String staffName = staffNameController.text.trim();
    String staffJoiningDate = staffDateOfJoiningController.text.trim();
    String staffMobileNumber = staffMobileNumberController.text.trim();
    String staffPassword = staffPasswordController.text.trim();

    String staffDob = staffDateOfBirthController.text.trim();
    String staffMobileNumberTwo = staffMobileNumberTwoController.text.trim();
    String staffAddress = staffAddressController.text.trim();

    if (staffName.isEmpty) {
      buildScaffoldMessage(context, 'Please Fill The Name Field');

      return false;
    }
    if (staffJoiningDate.isEmpty) {
      buildScaffoldMessage(context, "Please Select The Date");
      return false;
    }
    if (staffMobileNumber.isEmpty) {
      buildScaffoldMessage(context, "Please Enter The Mobile Number");
      return false;
    } else if (staffMobileNumber.length < 10) {
      buildScaffoldMessage(
          context, 'Invalid mobile number, must be at least 10 digits');
      return false;
    }
//------------------this is the mobile exist validation --------------------
    bool mobileExists = await checkIfSaMobileNumberExists(staffMobileNumber);
    if (mobileExists) {
      buildScaffoldMessage(context,
          "Mobile number already exists. Please enter a unique number.");
      return false;
    }
//---------------------------End--------------------------------------------
    if (staffPassword.isEmpty) {
      buildScaffoldMessage(context, "Please Enter The Password");
      return false;
    } else if (staffPassword.length < 4) {
      buildScaffoldMessage(
          context, "Invalid Password , must be minimum four digits ");
      return false;
    }
    if (selectedDepartment.value.isEmpty) {
      buildScaffoldMessage(context, 'Please select the department');
      return false;
    }

    // Validate selectedPosition
    if (selectedPosition.value.isEmpty) {
      buildScaffoldMessage(context, 'Please select the position');
      return false;
    }
    if (staffDob.isEmpty) {
      buildScaffoldMessage(context, "Please Enter The DateOf Birth");
      return false;
    }
    if (staffMobileNumberTwo.isNotEmpty && staffMobileNumberTwo.length != 10) {
      buildScaffoldMessage(
          context, "Invalid mobile number, must be at least 10 digits");
      return false;
    }
    if (staffAddress.isEmpty) {
      buildScaffoldMessage(context, "Please Enter Address");
      return false;
    }
    return true;
  }

// -----------------Function to Check if a Mobile Number Exists in Firestore-----------
  Future<bool> checkIfSaMobileNumberExists(String mobilenumber) async {
    try {
      // Step 1: Fetch all documents from the 'saAdmin' collection
      final snapshot = await firebaseFirestore
          .collection(ProjectConstants.collectionsaAdmin)
          .get();

      // Step 2: Iterate through the documents and compare the mobile numbers
      for (var doc in snapshot.docs) {
        // Get the existing mobile number from the document
        String existingSaMobileNumber = doc['mobilenumber'];

        // Check if the provided mobile number matches any existing number
        if (existingSaMobileNumber == mobilenumber) {
          return true; // Match found, return true
        }
      }

      // Step 3: Return false if no match is found
      return false;
    } catch (e) {
      // Error Handling: Log and return false in case of an exception
      print("Error checking if Mobile Number exists: $e");
      return false;
    }
  }

//---------------------to fetch position , department and Staff from firestore----------------------------
  void fetchPositions() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(ProjectConstants.collectionPosition)
          .get();
      positionList.value =
          snapshot.docs.map((doc) => doc['positionName'] as String).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch positions: $e');
    }
  }

  void fetchDepartments() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(ProjectConstants.collectionDept)
          .get();
      departmentList.value =
          snapshot.docs.map((doc) => doc['deptName'] as String).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch department: $e');
    }
  }

  Future<void> fetchStaff() async {
    try {
      final snapshot = await firebaseFirestore
          .collection(ProjectConstants.collectionStaff)
          // .where('deptName', isEqualTo: "Event") // Uncomment if needed
          .orderBy('staffCreatedAt', descending: true)
          .get();

      staffList.value = snapshot.docs
          .map((doc) => StaffModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Unable to fetch the details: $e");
    }
  }

//----------------------------Clear Controller----------------------
  clearController(BuildContext context) {
    staffNameController.clear();
    staffDateOfJoiningController.clear();
    staffMobileNumberController.clear();
    staffPasswordController.clear();
    staffDateOfBirthController.clear();
    staffMobileNumberTwoController.clear();
    staffAddressController.clear();

    //after clear ,drop down data must be null
    selectedDepartment.value = '';
    selectedPosition.value = '';
  }

  //-----------------------------Delete Staff Data---------------
  void deleteStaffData(BuildContext context, String staffId) {
    firebaseFirestore
        .collection(ProjectConstants.collectionStaff)
        .doc(staffId)
        .delete();

    fetchStaff();
  }
}
