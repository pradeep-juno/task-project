// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:jk_event_management/model/staff_model.dart';
// import 'package:jk_event_management/utils/project_constants.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class SaStafController extends GetxController {
//   RxList<StaffModel> staffList = <StaffModel>[].obs;
//
//   final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
//
//   //late Stream<DocumentSnapshot> saAdminDataStream;
//
//   // Reactive list for department and position names
//   RxList<String> departmentList = <String>[].obs;
//   RxList<String> positionList = <String>[].obs;
//
//   RxString activeTab = 'Employee'.obs;
//
//   // Reactive variables for selected department and position
//   RxString selectedDepartment = ''.obs;
//   RxString selectedPosition = ''.obs;
//
//   // Controllers for other fields
//   final staffNameController = TextEditingController();
//   final staffJoiningDateController = TextEditingController();
//   final staffMobileNumberController = TextEditingController();
//   final staffPasswordController = TextEditingController();
//   final staffDateOfBirthController = TextEditingController();
//   final staffMobileNumber2Controller = TextEditingController();
//   final staffAddressController = TextEditingController();
//
//   RxBool isButtonClicked = false.obs;
//
//   var staffButtonName = ''.obs;
//
//   var staffId = ''.obs;
//
//   RxBool isUpdateButtonClicked = false.obs;
//
//   // Toggle button function
//   void toggleButton() {
//     isButtonClicked.value = !isButtonClicked.value;
//   }
//
//   // Save employee details (example placeholder)
//   saveOrUpdateStaff(
//     BuildContext context,
//     String? staffId,
//     SaStafController stfController,
//   ) async {
//     if (await validateFields(context)) {
//       try {
//         if (staffId != true) {
//           print("storeUpdateTrue");
//           var docRef = firebaseFirestore
//               .collection(ProjectConstants.collectionStaff)
//               .doc(staffId.toString());
//
//           // selectedStaff - db , staffPasswordController - user
//           var departmentSnapshot = await firebaseFirestore
//               .collection(ProjectConstants.collectionDept)
//               .where('deptName', isEqualTo: selectedDepartment.value)
//               .limit(1)
//               .get();
//
//           final departmentId = departmentSnapshot.docs.isNotEmpty
//               ? departmentSnapshot.docs.first.id
//               : '';
//
//           var positionSnapshot = await firebaseFirestore
//               .collection(ProjectConstants.collectionPosition)
//               .where('positionName', isEqualTo: selectedPosition.value)
//               .limit(1)
//               .get();
//
//           final positionId = positionSnapshot.docs.isNotEmpty
//               ? positionSnapshot.docs.first.id
//               : '';
//
//           var updatedStaff = StaffModel(
//               staffId: staffId.toString(),
//               staffName: staffNameController.text.trim(),
//               staffJoiningDate: staffJoiningDateController.text.trim(),
//               staffMobileNumber: staffMobileNumberController.text.trim(),
//               staffPassword: staffPasswordController.text.trim(),
//               deptId: departmentId,
//               deptName: selectedDepartment.value,
//               positionId: positionId,
//               positionName: selectedPosition.value,
//               staffDob: staffDateOfBirthController.text.trim(),
//               staffMobileNumber2: staffMobileNumber2Controller.text.trim(),
//               staffAddress: staffAddressController.text.trim(),
//               staffCreatedAt: DateTime.now());
//
//           await docRef.update(updatedStaff.toMap());
//
//           clearController(context);
//
//           // Show success message for update
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text(
//                 'staff updated successfully!',
//                 style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold),
//               ),
//               duration: Duration(seconds: 2),
//               backgroundColor: Colors.black,
//               behavior: SnackBarBehavior.floating,
//             ),
//           );
//
//           //  stfController.toggleButton();
//           stfController.fetchStaff();
//
//           isButtonClicked.value = false;
//           activeTab.value == 'Employee';
//         } else {
//           print("storeAddTrue");
//           SharedPreferences prefs = await SharedPreferences.getInstance();
//
//           String id = prefs.getString('id') ?? 'Not Available';
//
//           // Wait for the admin data before proceeding
//           var documentSnapshot = await firebaseFirestore
//               .collection(ProjectConstants.collectionsaAdmin)
//               .doc(id)
//               .get();
//
//           if (documentSnapshot.exists) {
//             //For createdByName and createdByName
//             // Assign admin data to variables
//             String saAdminName = documentSnapshot['name'] ?? 'Not Found';
//             String saAdminId = documentSnapshot['sadminid'] ?? 'Not Found';
//
//             print("admin name: $saAdminName");
//             print("admin ID: $saAdminId");
//
//             // Now that the admin data is ready, proceed with saving staff data
//             var currentDateTime = DateTime.now();
//             var docRef = firebaseFirestore
//                 .collection(ProjectConstants.collectionStaff)
//                 .doc();
//             var staffId = docRef.id; // Create new position ID
//
//             var departmentSnapshot = await firebaseFirestore
//                 .collection(ProjectConstants.collectionDept)
//                 .where('deptName', isEqualTo: selectedDepartment.value)
//                 .limit(1)
//                 .get();
//
//             final departmentId = departmentSnapshot.docs.isNotEmpty
//                 ? departmentSnapshot.docs.first.id
//                 : '';
//
//             var positionSnapshot = await firebaseFirestore
//                 .collection(ProjectConstants.collectionPosition)
//                 .where('positionName', isEqualTo: selectedPosition.value)
//                 .limit(1)
//                 .get();
//
//             final positionId = positionSnapshot.docs.isNotEmpty
//                 ? positionSnapshot.docs.first.id
//                 : '';
//
//             var staffData = StaffModel(
//               staffId: staffId,
//               staffName: staffNameController.text.trim(),
//               staffJoiningDate: staffJoiningDateController.text.trim(),
//               staffMobileNumber: staffMobileNumberController.text.trim(),
//               staffPassword: staffPasswordController.text.trim(),
//
//               deptId: departmentId,
//               deptName: selectedDepartment.value,
//               positionId: positionId,
//               positionName: selectedPosition.value,
//
//               staffDob: staffDateOfBirthController.text.trim(),
//               staffMobileNumber2: staffMobileNumber2Controller.text.trim(),
//               staffAddress: staffAddressController.text.trim(),
//               staffCreatedAt: currentDateTime,
//               createdByName: saAdminName, // Assign the admin name here
//               createdById: saAdminId, // Assign the admin ID here
//             );
//
//             await docRef.set(staffData.toMap());
//
//             print("StaffData : ${staffData.toString()}");
//
//             // Show success message
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text(
//                   'Staff saved successfully!',
//                   style: TextStyle(
//                       fontSize: 12,
//                       color: Colors.green,
//                       fontWeight: FontWeight.bold),
//                 ),
//                 duration: Duration(seconds: 2),
//                 backgroundColor: Colors.lightBlueAccent,
//                 behavior: SnackBarBehavior.floating,
//               ),
//             ); //------
//
//             clearController(context);
//             stfController.toggleButton();
//             stfController.fetchStaff();
//             activeTab.value == 'Employee';
//           } else {
//             // Handle the case where the admin document does not exist
//             print("Admin document not found!");
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text(
//                   'Admin data not found!',
//                   style: TextStyle(fontSize: 12, color: Colors.red),
//                 ),
//                 duration: Duration(seconds: 2),
//                 backgroundColor: Colors.orangeAccent,
//                 behavior: SnackBarBehavior.floating,
//               ),
//             );
//           }
//         }
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               'Failed to save staff: $e',
//               style: const TextStyle(
//                   fontSize: 12, color: Colors.red, fontWeight: FontWeight.bold),
//             ),
//             duration: const Duration(seconds: 2),
//             backgroundColor: Colors.yellowAccent,
//             behavior: SnackBarBehavior.floating,
//           ),
//         );
//       }
//     }
//   }
//
//   Future<void> EmployeeDetails(
//       BuildContext context, StaffModel? selectedStaff) async {
//     if (await EmployeeValidateFields(context, selectedStaff)) {
//       activeTab.value = 'Personal Details';
//     }
//   }
//
//   Future<bool> EmployeeValidateFields(
//       BuildContext context, StaffModel? selectedStaff) async {
//     String staffName = staffNameController.text.trim();
//     String staffJoiningDate = staffJoiningDateController.text.trim();
//     String staffMobileNumber = staffMobileNumberController.text.trim();
//     String staffPassword = staffPasswordController.text.trim();
//
//     // Validate staffName
//     if (staffName.isEmpty) {
//       showError(context, 'Please fill the name field');
//       return false;
//     }
//
//     // Validate staffJoiningDate
//     if (staffJoiningDate.isEmpty) {
//       showError(context, 'Please fill the joining date field');
//       return false;
//     }
//
//     // Validate staffMobileNumber
//     if (staffMobileNumber.isEmpty) {
//       showError(context, 'Please fill the mobile number field');
//       return false;
//     } else if (staffMobileNumber.length < 10) {
//       showError(context, 'Invalid mobile number, must be at least 10 digits');
//       return false;
//     }
//     bool staffExists = await checkIfSaMobileNumberExists(staffMobileNumber);
//     if (staffExists) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text(
//             'Mobile Number Already Exists',
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.red,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           duration: Duration(seconds: 2),
//           backgroundColor: Colors.yellowAccent,
//           behavior: SnackBarBehavior.floating));
//
//       return false;
//     }
//     // Check for mobile number uniqueness only if it's been changed
//     if (selectedStaff == null ||
//         staffMobileNumber != selectedStaff.staffMobileNumber) {
//       bool saExists = await checkIfSaMobileNumberExists(staffMobileNumber);
//       if (saExists) {
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//             content: Text(
//               'Mobile Number Already Exists',
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.red,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             duration: Duration(seconds: 2),
//             backgroundColor: Colors.yellowAccent,
//             behavior: SnackBarBehavior.floating));
//
//         return false;
//       }
//     }
//
//     // Validate staffPassword
//     if (staffPassword.isEmpty) {
//       showError(context, 'Please fill the password field');
//       return false;
//     } else if (staffPassword.length < 4) {
//       showError(context, 'Password must be at least 4 characters');
//       return false;
//     }
//
//     if (selectedDepartment.value == ProjectConstants.selectTheDepartment) {
//       showError(context, 'Please select the Department');
//       return false;
//     }
//
//     if (selectedPosition.value == ProjectConstants.selectThePosition) {
//       showError(context, 'Please select the position');
//       return false;
//     }
//
//     return true;
//   }
//
//   Future<bool> checkIfSaMobileNumberExists(String mobilenumber) async {
//     try {
//       final snapshot = await firebaseFirestore
//           .collection(ProjectConstants.collectionsaAdmin)
//           .get();
//
//       // Compare case-insensitively
//       for (var doc in snapshot.docs) {
//         String existingSaMobileNumber = doc['mobilenumber'];
//         if (existingSaMobileNumber == mobilenumber) {
//           return true; // Match found
//         }
//       }
//       return false; // No match found
//     } catch (e) {
//       print("Error checking if Mobile Number exists: $e");
//       return false;
//     }
//   }
//
//   Future<void> fetchStaff() async {
//     try {
//       await Future.microtask(() async {
//         final snapshot = await firebaseFirestore
//             .collection(ProjectConstants.collectionStaff)
//             //.where('deptName', isEqualTo: "Event")
//             .orderBy('staffCreatedAt', descending: true)
//             .get();
//
//         staffList.value = snapshot.docs
//             .map(
//                 (doc) => StaffModel.fromMap(doc.data() as Map<String, dynamic>))
//             .toList();
//       });
//     } catch (e) {
//       print("Unable to fetch the details: $e");
//     }
//   }
//   // Validation for form fields
//
//   bool validateFields(BuildContext context) {
//     String staffDob = staffDateOfBirthController.text.trim();
//     String staffMobileNumberTwo = staffMobileNumber2Controller.text.trim();
//     String staffAddress = staffAddressController.text.trim();
//
//     // Validate selectedDepartment
//     if (selectedDepartment.value.isEmpty) {
//       showError(context, 'Please select the department');
//       return false;
//     }
//
//     // Validate selectedPosition
//     if (selectedPosition.value.isEmpty) {
//       showError(context, 'Please select the position');
//       return false;
//     }
//
//     // Validate staffDob
//     if (staffDob.isEmpty) {
//       showError(context, 'Please select your DOB');
//       return false;
//     }
//
//     // Mobile Number 2 validation (optional, but should be 10 digits if entered)
//     if (staffMobileNumberTwo.isNotEmpty && staffMobileNumberTwo.length != 10) {
//       showError(context, "Invalid mobile number, must be at least 10 digits'");
//
//       return false;
//     }
//
//     // Validate staffAddress
//     if (staffAddress.isEmpty) {
//       showError(context, 'Please fill the address field');
//       return false;
//     }
//
//     return true;
//   }
//
//   // Show error message in Snackbar
//   void showError(BuildContext context, String message) {
//     // Example of showing a snackbar or dialog for the error
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red,
//       ),
//     );
//   }
//
//   // Fetch departments from Firestore
//   Future<void> fetchDepartments() async {
//     try {
//       QuerySnapshot querySnapshot = await firebaseFirestore
//           .collection(ProjectConstants.collectionDept)
//           .get();
//       departmentList.clear(); // Clear existing data
//
//       departmentList.add(ProjectConstants.selectTheDepartment);
//
//       for (var doc in querySnapshot.docs) {
//         departmentList
//             .add(doc['deptName']); // Assuming 'deptName' holds the name
//       }
//       if (departmentList.isNotEmpty) {
//         selectedDepartment.value = departmentList.first; // Default selection
//       }
//     } catch (e) {
//       print("Error fetching departments: $e");
//     }
//   }
//
//   // Fetch positions from Firestore
//   Future<void> fetchPosition() async {
//     try {
//       QuerySnapshot querySnapshot = await firebaseFirestore
//           .collection(ProjectConstants.collectionPosition)
//           .get();
//       positionList.clear(); // Clear existing data
//
//       positionList.add(ProjectConstants.selectThePosition);
//
//       for (var doc in querySnapshot.docs) {
//         positionList
//             .add(doc['positionName']); // Assuming 'positionName' holds the name
//       }
//       if (positionList.isNotEmpty) {
//         selectedPosition.value = positionList.first; // Default selection
//       }
//     } catch (e) {
//       print("Error fetching positions: $e");
//     }
//   }
//
//   clearController(BuildContext context) {
//     staffNameController.clear();
//     staffJoiningDateController.clear();
//     staffMobileNumberController.clear();
//     staffPasswordController.clear();
//     staffDateOfBirthController.clear();
//     staffMobileNumber2Controller.clear();
//     staffAddressController.clear();
//
//     selectedDepartment.value = ProjectConstants.selectTheDepartment;
//     selectedPosition.value = ProjectConstants.selectThePosition;
//   }
//
//   void deleteStaffData(BuildContext context, String staffId) {
//     firebaseFirestore
//         .collection(ProjectConstants.collectionStaff)
//         .doc(staffId)
//         .delete();
//
//     fetchStaff();
//   }
// }
