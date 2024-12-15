import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jk_event_management/model/staff_model.dart';
import 'package:jk_event_management/utils/project_constants.dart';

class SaStaffController extends GetxController {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  // Reactive list for department and position names
  RxList<String> departmentList = <String>[].obs;
  RxList<String> positionList = <String>[].obs;

  // Reactive variables for selected department and position
  RxString selectedDepartment = ''.obs;
  RxString selectedPosition = ''.obs;

  // Controllers for other fields
  final staffNameController = TextEditingController();
  final staffJoiningDateController = TextEditingController();
  final staffMobileNumberController = TextEditingController();
  final staffPasswordController = TextEditingController();
  final staffDateOfBirthController = TextEditingController();
  final staffMobileNumber2Controller = TextEditingController();
  final staffAddressController = TextEditingController();

  RxBool isButtonClicked = false.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    selectedPosition.value = ProjectConstants.selectThePosition;
  }

  // Toggle button function
  void toggleButton() {
    isButtonClicked.value = !isButtonClicked.value;
  }

  // Save employee details (example placeholder)
  Future<void> saveEmployeeDetails(BuildContext context) async {
    if (await validateFields(context)) {
      var currentDateTime = DateTime.now();
      var docRef =
          firebaseFirestore.collection(ProjectConstants.collectionStaff).doc();
      var staffId = docRef.id; // Create new position ID

      var staffData = StaffModel(
          staffId: staffId,
          staffName: staffNameController.text.trim(),
          staffJoiningDate: staffJoiningDateController.text.trim(),
          staffMobileNumber: staffMobileNumberController.text.trim(),
          staffPassword: staffPasswordController.text.trim(),
          staffDob: staffDateOfBirthController.text.trim(),
          staffMobileNumber2: staffMobileNumber2Controller.text.trim(),
          staffAddress: staffAddressController.text..trim(),
          staffCreatedAt: currentDateTime);

      await docRef.set(staffData.toMap());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Staff saved successfully!',
            style: TextStyle(
                fontSize: 12, color: Colors.green, fontWeight: FontWeight.bold),
          ),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.lightBlueAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    clearController(context);
  }

  // Validation for form fields
  bool validateFields(BuildContext context) {
    String staffName = staffNameController.text.trim();
    String staffJoiningDate = staffJoiningDateController.text.trim();
    String staffMobileNumber = staffMobileNumberController.text.trim();
    String staffPassword = staffMobileNumberController.text.trim();
    String staffDob = staffDateOfBirthController.text.trim();
    String staffMobileNumber2 = staffMobileNumber2Controller.text.trim();
    String staffAddress = staffAddressController.text.trim();

    if (staffName.isEmpty) {
      showError(context, 'Please fill the name field');
      return false;
    }
    if (staffJoiningDate.isEmpty) {
      showError(context, 'Please fill the joining date field');
      return false;
    }
    if (staffMobileNumber.isEmpty) {
      showError(context, 'Please fill the mobile number field');
      return false;
    }
    if (staffPassword.isEmpty) {
      showError(context, 'Please fill the password field');
      return false;
    }
    if (selectedDepartment.value.isEmpty) {
      showError(context, 'Please select the department');
      return false;
    }
    if (selectedPosition.value.isEmpty) {
      showError(context, 'Please select the position');
      return false;
    }
    if (staffDob.isEmpty) {
      showError(context, 'Please select your DOB');
      return false;
    }
    if (staffAddress.isEmpty) {
      showError(context, 'Please fill the address field');
      return false;
    }
    return true;
  }

  // Show error message in Snackbar
  void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.yellowAccent,
      behavior: SnackBarBehavior.floating,
    ));
  }

  // Fetch departments from Firestore
  Future<void> fetchDepartments() async {
    try {
      QuerySnapshot querySnapshot = await firebaseFirestore
          .collection(ProjectConstants.collectionDept)
          .get();
      departmentList.clear(); // Clear existing data
      for (var doc in querySnapshot.docs) {
        departmentList
            .add(doc['deptName']); // Assuming 'deptName' holds the name
      }
      if (departmentList.isNotEmpty) {
        selectedDepartment.value = departmentList.first; // Default selection
      }
    } catch (e) {
      print("Error fetching departments: $e");
    }
  }

  // Fetch positions from Firestore
  Future<void> fetchPosition() async {
    try {
      QuerySnapshot querySnapshot = await firebaseFirestore
          .collection(ProjectConstants.collectionPosition)
          .get();
      positionList.clear(); // Clear existing data
      for (var doc in querySnapshot.docs) {
        positionList
            .add(doc['positionName']); // Assuming 'positionName' holds the name
      }
      if (positionList.isNotEmpty) {
        selectedPosition.value = positionList.first; // Default selection
      }
    } catch (e) {
      print("Error fetching positions: $e");
    }
  }

  clearController(BuildContext context) {
    staffNameController.clear();
    staffJoiningDateController.clear();
    staffMobileNumberController.clear();
    staffPasswordController.clear();
    staffDateOfBirthController.clear();
    staffMobileNumber2Controller.clear();
    staffAddressController.clear();
  }

  isCheckEmployeeData(
      BuildContext context,
      String staffName,
      String staffJoiningDate,
      String staffMobileNumber,
      String staffPassword,
      String staffDob,
      String staffMobileNumber2,
      String staffAddress) {}
}
