// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:jk_event_management/demo_code_pages/demo_staff_controller.dart';
// import 'package:jk_event_management/model/staff_model.dart';
//
// import '../../utils/Project_colors.dart';
// import '../../utils/functions.dart';
// import '../../utils/project_constants.dart';
//
// class SaStaffScreen extends StatefulWidget {
//   const SaStaffScreen({super.key});
//
//   @override
//   State<SaStaffScreen> createState() => __SaStafScreenState();
// }
//
// class __SaStafScreenState extends State<SaStaffScreen> {
//   final SaStafController stfController = Get.put(SaStafController());
//
// // Track the active tab
//
//   @override
//   void initState() {
//     super.initState();
//     stfController.fetchDepartments();
//     stfController.fetchPosition();
//     stfController.fetchStaff();
//   }
//
//   StaffModel? selectedStaff;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Button to toggle container visibility
//             Obx(
//               () => buildContainerButtonFun(
//                 context,
//                 ProjectConstants.addEmployee,
//                 isSmallSize: true,
//                 color: stfController.isButtonClicked.value
//                     ? ProjectColors.greyColorA6A6A6
//                     : ProjectColors.accentPink,
//                 onPressed: () {
//                   setState(() {
//                     stfController.staffButtonName.value = 'Done';
//                   });
//                   stfController.clearController(context);
//                   stfController.toggleButton();
//                 },
//               ),
//             ),
//             const SizedBox(height: 20),
//
//             showStaffData(
//               context,
//               stfController,
//               selectedStaff,
//               setState,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   showStaffData(BuildContext context, SaStafController stfController,
//       StaffModel? selectedStaff, void Function(VoidCallback fn) setState) {}
// }
