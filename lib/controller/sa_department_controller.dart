import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../model/department_model.dart';
import '../utils/project_constants.dart';

class SaDepartmentController extends GetxController {
  RxList<DepartmentModel> deptList = <DepartmentModel>[].obs;

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  var isButtonClicked = false.obs; // Observable variable
  var isSaving = false.obs; // Flag to prevent duplicate calls

  void toggleButton() {
    isButtonClicked.value = !isButtonClicked.value; // Toggle state
  }

  var departmentButtonName = ''.obs;

  final departmentNameController = TextEditingController();

  // Updated saveOrUpdateDepartment method handling both add and update
  Future<void> saveOrUpdateDepartment(
      BuildContext context,
      DepartmentModel? selectedDepartment,
      SaDepartmentController saDepartmentController) async {
    // Check if department name is valid
    if (await validateFields(context)) {
      try {
        var currentDateTime = DateTime.now();

        // If selectedDepartment is not null, we are updating an existing department
        if (selectedDepartment != null) {
          var docRef = firebaseFirestore
              .collection(ProjectConstants.collectionDept)
              .doc(selectedDepartment.deptId);

          var updatedDepartment = DepartmentModel(
              deptId: selectedDepartment.deptId,
              deptName: departmentNameController.text.trim(),
              deptCreatedAt: selectedDepartment.deptCreatedAt,
              deptUpdatedAt: DateTime.now());

          await docRef.update(updatedDepartment.toMap());

          // Show success message for update
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Department updated successfully!',
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.black,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          // If selectedDepartment is null, we are adding a new department
          var docRef = firebaseFirestore
              .collection(ProjectConstants.collectionDept)
              .doc();
          var deptId = docRef.id; // Create new department ID

          var departmentData = DepartmentModel(
            deptId: deptId,
            deptName: departmentNameController.text.trim(),
            deptCreatedAt: currentDateTime,

            // Set the current date and time for creation
          );

          await docRef.set(departmentData.toMap());

          print(departmentData.toString());

          // Show success message for adding a new department
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Department saved successfully!',
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.green,
                    fontWeight: FontWeight.bold),
              ),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.lightBlueAccent,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }

        // Clear the input fields and reset UI
        clearController(context);
        saDepartmentController.toggleButton();
        saDepartmentController.fetchDepartment();
      } catch (e) {
        // Handle error for both add and update
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to save department: $e',
              style: const TextStyle(
                  fontSize: 12, color: Colors.red, fontWeight: FontWeight.bold),
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.yellowAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } finally {
        isSaving.value = false; // Reset the flag after operation
      }
    } else {
      isSaving.value = false; // Reset the flag in case of validation failure
    }
  }

  // Validation for department name
  validateFields(BuildContext context) async {
    if (departmentNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Please Enter The Department Field',
            style: TextStyle(
              fontSize: 12,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.yellowAccent,
          behavior: SnackBarBehavior.floating));
      return false;
    }

    // Check if the department name already exists
    bool exists = await checkIfDeptNameExists(departmentNameController.text);

    if (exists) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Department Name Already Exists',
            style: TextStyle(
              fontSize: 12,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.yellowAccent,
          behavior: SnackBarBehavior.floating));

      return false;
    }

    return true;
  }

  // Function to check if the department name already exists in Firestore
  Future<bool> checkIfDeptNameExists(String deptName) async {
    try {
      final snapshot = await firebaseFirestore
          .collection(ProjectConstants.collectionDept)
          .get();

      // Compare case-insensitively
      for (var doc in snapshot.docs) {
        String existingDeptName = doc['deptName'];
        if (existingDeptName.toLowerCase() == deptName.toLowerCase()) {
          return true; // Match found
        }
      }
      return false; // No match found
    } catch (e) {
      print("Error checking if department name exists: $e");
      return false;
    }
  }

  // Clears department name controller
  void clearController(BuildContext context) {
    departmentNameController.clear();
  }

  // Fetch departments from Firestore
  Future<void> fetchDepartment() async {
    try {
      final snapshot = await firebaseFirestore
          .collection(ProjectConstants.collectionDept)
          .orderBy('deptCreatedAt', descending: true)
          .get();

      // Ensure deptList is updated with the latest data
      deptList.value = snapshot.docs
          .map((doc) =>
              DepartmentModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Unable to fetch the details: $e");
    }
  }

  // Delete department data
  void deleteDepartmentData(BuildContext context, String deptId) {
    firebaseFirestore
        .collection(ProjectConstants.collectionDept)
        .doc(deptId)
        .delete();

    fetchDepartment();
  }
}
