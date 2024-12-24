import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:jk_event_management/utils/functions.dart';

import '../model/position_model.dart';
import '../utils/project_constants.dart';

class SaPositionController extends GetxController {
  RxList<PositionModel> positionList = <PositionModel>[].obs;

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  final searchNameController = TextEditingController();
  var filteredSearchList = <PositionModel>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    filteredSearchList.value = positionList;
    searchNameController.addListener(() {
      filterPositionName();
    });
  }

  void filterPositionName() {
    String query = searchNameController.text.toLowerCase();

    if (query.isEmpty) {
      filteredSearchList.value = positionList;
    } else {
      filteredSearchList.value = positionList
          .where((positionName) =>
              positionName.positionName.toLowerCase().startsWith(query))
          .toList();
    }
  }

  var isButtonClicked = false.obs; // Observable variable
  var isSaving = false.obs; // Flag to prevent duplicate calls

  var positionButtonName = ''.obs;

  void toggleButton() {
    isButtonClicked.value = !isButtonClicked.value; // Toggle state
  }

  final positionNameController = TextEditingController();

  // Updated saveOrUpdatePosition method handling both add and update
  Future<void> saveOrUpdatePosition(
      BuildContext context,
      PositionModel? selectedPosition,
      SaPositionController saPositionController) async {
    // Check if position name is valid
    if (await validateFields(context)) {
      try {
        var currentDateTime = DateTime.now();

        // If selectedPosition is not null, we are updating an existing position
        if (selectedPosition != null) {
          var docRef = firebaseFirestore
              .collection(ProjectConstants.collectionPosition)
              .doc(selectedPosition.positionId);

          var updatedPosition = PositionModel(
              positionId: selectedPosition.positionId,
              positionName: positionNameController.text.trim(),
              positionCreatedAt: selectedPosition.positionCreatedAt,
              positionUpdatedAt: DateTime.now());

          await docRef.update(updatedPosition.toMap());

          // Show success message for update
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Position updated successfully!',
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
          // If selectedPosition is null, we are adding a new position
          var docRef = firebaseFirestore
              .collection(ProjectConstants.collectionPosition)
              .doc();
          var positionId = docRef.id; // Create new position ID

          var positionData = PositionModel(
            positionId: positionId,
            positionName: positionNameController.text.trim(),
            positionCreatedAt:
                currentDateTime, // Set the current date and time for creation
            // Set the current date and time for creation
          );

          await docRef.set(positionData.toMap());

          // Show success message for adding a new position
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Position saved successfully!',
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
        saPositionController.toggleButton();
        saPositionController.fetchPosition();
      } catch (e) {
        // Handle error for both add and update
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to save position: $e',
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

  // Validation for position name
  validateFields(BuildContext context) {
    if (positionNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Please Enter The Position Field',
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

  // Clears position name controller
  void clearController(BuildContext context) {
    positionNameController.clear();
  }

  // Fetch positions from Firestore
  Future<void> fetchPosition() async {
    try {
      final snapshot = await firebaseFirestore
          .collection(ProjectConstants.collectionPosition)
          .orderBy('positionCreatedAt', descending: true)
          .get();
      positionList.value = snapshot.docs
          .map((doc) =>
              PositionModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("unable to fetch the details");
    }
  }

  // Delete position data
  void deletePositionData(BuildContext context, String positionId) {
    firebaseFirestore
        .collection(ProjectConstants.collectionPosition)
        .doc(positionId)
        .delete();

    fetchPosition();
    buildScaffoldMessage(context, "Position Deleted Successfully");
  }
}
