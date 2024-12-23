import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jk_event_management/router/project_router.dart';
import 'package:jk_event_management/utils/project_constants.dart';

import '../controller/sa_department_controller.dart';
import '../controller/sa_position_controller.dart';
import '../controller/sa_staff_controller.dart';
import '../model/department_model.dart';
import '../model/position_model.dart';
import 'Project_colors.dart';

buildImageFunction(BuildContext context, String image) {
  return Image.asset(image);
}

//-----------------------------buildCircleAvatarFun-----------------
buildCircleAvatarFun(
  BuildContext context, {
  required double radius,
  required imagePath,
  String? text,
  BoxFit fit = BoxFit.cover,
  Color? color,
  double? fontsize,
  FontWeight? fontweight,
  MaterialColor? backgroundColor,
}) {
  return CircleAvatar(
      radius: radius,
      child: ClipOval(
        child: Image.asset(
          imagePath,
          fit: fit,
        ),
      ));
}

//-----------------------------buildSizedBoxHeightFun-----------------
buildSizedBoxHeightFun(BuildContext context, {required double height}) {
  return SizedBox(
    height: height,
  );
}

//-----------------------------buildSizedBoxWidthFun-----------------
buildSizedBoxWidthFun(BuildContext context, {required double width}) {
  return SizedBox(
    width: width,
  );
}

//-----------------------------buildContainerButtonFun-----------------
buildContainerButtonFun(BuildContext context, String title,
    {Color? color,
    Color? borderColor, // Added borderColor for external color
    Function()? onPressed,
    bool isSmallSize = false,
    bool showIcon = true,
    bool isBordered = false,
    double? customHeight,
    double? customWidth}) {
  return InkWell(
      onTap: onPressed,
      child: Container(
          height: customHeight ?? (isSmallSize ? 40 : 44),
          width: customWidth ?? (isSmallSize ? 165 : 298),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: isBordered
                ? Colors.transparent
                : (color ?? Colors.pink), // Default color is pink
            border: isBordered
                ? Border.all(
                    color: borderColor ?? Colors.black,
                    width: 2) // Border color
                : null, // No border if isBordered is false
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showIcon) ...[
                  // Conditionally render the icon
                  Icon(Icons.add,
                      color: isBordered
                          ? (borderColor ?? Colors.black)
                          : Colors.white, // Icon color based on border
                      size: 16),
                  SizedBox(width: 8), // Space between icon and text
                ],
                buildTextFun(
                  context,

                  title: title,

                  fontsize: 12,
                  fontweight: FontWeight.w800,
                  color: isBordered
                      ? (borderColor ?? Colors.black)
                      : Colors.white, // Text color based on border
                ),
              ],
            ),
          )));
}

//-----------------------------buildTextFun-----------------
buildTextFun(BuildContext context,
    {required String title,
    required double fontsize,
    required FontWeight fontweight,
    required Color color,
    int maxLines = 1,
    String? fontFamily}) {
  return Text(
    title,
    style: TextStyle(
        fontSize: fontsize,
        fontWeight: fontweight,
        color: color,
        fontFamily: 'poppins'),
    maxLines: maxLines, // Limits the number of lines to display
    overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
  );
}

//-----------------------------buildImageAssetsFun------------
Widget buildImageAssetsFun(
  BuildContext context, {
  required double width,
  required double height,
  required String imagePath,
  required bool circleAvatar,
}) {
  return circleAvatar
      ? CircleAvatar(
          radius: width / 2,
          backgroundImage: AssetImage(imagePath),
        )
      : Image.asset(
          imagePath,
          width: width,
          height: height,
        );
}

//-----------------------buildSidebarItem------------------
Widget buildSidebarItem(
  BuildContext context, {
  required IconData icon,
  required String title,
  required int index,
  required int selectedIndex,
  required VoidCallback onMenuItemTap,
}) {
  bool isSelected = selectedIndex == index;
  return Container(
    decoration: isSelected
        ? BoxDecoration(
            color: ProjectColors.primaryGreen,
            borderRadius: BorderRadius.circular(8),
          )
        : null, // No decoration if not selected
    child: ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Colors.white : ProjectColors.green51ADAA,
      ),
      title: buildTextFun(
        context,
        title: title,
        fontsize: 14,
        fontweight: FontWeight.bold,
        color:
            isSelected ? ProjectColors.whiteColor : ProjectColors.green51ADAA,
      ),
      onTap: onMenuItemTap,
    ),
  );
}

//-----------------------buildTextFormFieldFun------------------
buildTextFormFieldFun(
  BuildContext context, {
  String? hint,
  TextEditingController? controller,
  Color? color,
  IconData? icon,
  required bool isPassword,
  TextInputType? keyboardType,
  List<TextInputFormatter>? inputFormatters,
  int maxLines = 1,
  bool? border,
  double? height,
  TextStyle? hintStyle,
}) {
  bool obscureText = isPassword;

  return StatefulBuilder(
    builder: (context, setState) {
      return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey),
            borderRadius: border == true
                ? BorderRadius.circular(2.0)
                : BorderRadius.circular(10.0)),
        //height: maxLines == 1 ? 50 : height,
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: hintStyle,
            border: InputBorder.none,
            prefixIcon: Icon(
              icon,
              color: color,
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                  )
                : null,
          ),
          maxLines: maxLines,
        ),
      );
    },
  );
}

//---------------------------------buildTextFormFieldFunTwo---------------
Widget buildTextFormFieldFunTwo(
  BuildContext context, {
  required String hint,
  TextEditingController? controller,
  bool isSmallSize = true,
  required double fontSize,
  bool dropdown = false, // Add the dropdown boolean parameter
  List<String>? dropdownItems, // Add the dropdown items parameter
  String? selectedValue, // Add selected value parameter
  Function(String?)? onChanged, // Add onChanged callback for dropdown
}) {
  if (dropdown) {
    return Container(
      height: isSmallSize ? 40 : 70,
      width: isSmallSize ? 243 : 505,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: ProjectColors.greyColorA6A6A6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: DropdownButton<String>(
          value: selectedValue,
          hint: Text(
            "${hint}",
            style: TextStyle(
              fontSize: fontSize,
            ),
          ),
          onChanged: onChanged,
          isExpanded: true,
          underline: SizedBox(), // This removes the underline
          items: dropdownItems?.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                    fontSize: fontSize,
                    color: ProjectColors
                        .accentPink), // Set the font size for each dropdown item
              ),
            );
          }).toList(),
        ),
      ),
    );
  } else {
    return Container(
      height: isSmallSize ? 40 : 70,
      width: isSmallSize ? 243 : 505,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: ProjectColors.greyColorA6A6A6),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none, // Removes the bottom border line
          hintStyle: TextStyle(
              fontSize: fontSize,
              color: ProjectColors.blackColor191919
                  .withOpacity(0.6)), // Set the font size here
          contentPadding:
              EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        ),
      ),
    );
  }
}

//----------------------------------buildTextFormFieldFunThree-----------------
Widget buildTextFormFieldFunThree(
  BuildContext context, {
  required String hint,
  TextEditingController? controller,
  bool isSmallSize = true,
  required double fontSize,
  TextInputType? keyboardType,
  List<TextInputFormatter>? inputFormatters,
  bool isPassword = false,
}) {
  bool obscureText = isPassword; // Initialize obscureText here

  return StatefulBuilder(
    builder: (context, setState) {
      return Container(
        height: isSmallSize ? 40 : 70,
        width: isSmallSize ? 243 : 505,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: ProjectColors.greyColorA6A6A6),
        ),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          obscureText: isPassword ? obscureText : false, // Toggle obscureText
          decoration: InputDecoration(
            hintText: hint,
            border: InputBorder.none,
            hintStyle: TextStyle(
                fontSize: fontSize,
                color: ProjectColors.blackColor191919.withOpacity(0.6)),
            contentPadding:
                EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureText = !obscureText; // Toggle the state
                      });
                    },
                  )
                : null,
          ),
        ),
      );
    },
  );
}

//--------------------------buildCircleAvatarFunTwo-----------------
buildCircleAvatarFunTwo({
  required double radius,
  String? imagePath,
  String? text,
  BoxFit fit = BoxFit.cover,
  Color? color,
  double? fontsize,
  FontWeight? fontweight,
  Color? backgroundColor,
}) {
  if (imagePath != null)
    return CircleAvatar(
      radius: radius,
      child: ClipOval(
        child: Image.asset(
          imagePath!,
          fit: fit,
        ),
      ),
    );
  else if (text != null)
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      child: Text(
        text,
        style:
            TextStyle(color: color, fontSize: fontsize, fontWeight: fontweight),
      ),
    );
}

//---------------------buildDatePickerField-----------------------
Widget buildDatePickerField(
  BuildContext context, {
  required String hint,
  TextEditingController? controller, // Optional controller
  bool isSmallSize = true,
  required double fontSize,
}) {
  DateTime? selectedDate; // Internal state for date management

  return StatefulBuilder(
    builder: (context, setState) {
      return GestureDetector(
        onTap: () async {
          final DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );

          if (pickedDate != null) {
            setState(() {
              selectedDate = pickedDate; // Update the internal state
              // Update the controller if provided
              controller?.text = "${pickedDate.toLocal()}".split(' ')[0];
            });
          }
        },
        child: Container(
          height: isSmallSize ? 40 : 70,
          width: isSmallSize ? 243 : 505,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: ProjectColors.greyColorA6A6A6),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          alignment: Alignment.centerLeft,
          child: Text(
            controller != null && controller.text.isNotEmpty
                ? controller.text // Show text from the controller
                : (selectedDate != null
                    ? "${selectedDate!.toLocal()}"
                        .split(' ')[0] // Show selected date
                    : hint), // Show hint if nothing selected
            style: TextStyle(
              fontSize: fontSize,
              color: (controller != null && controller.text.isNotEmpty) ||
                      selectedDate != null
                  ? Colors.black
                  : Colors.grey,
            ),
          ),
        ),
      );
    },
  );
}

// Employee Content
// Widget buildEmployeeContent(BuildContext context,
//     SaStaffController staffController, StaffModel? selectedStaff) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 buildTextFun(context,
//                     title: ProjectConstants.name,
//                     fontsize: 12,
//                     fontweight: FontWeight.w500,
//                     color: ProjectColors.blackColor575757),
//                 buildTextFormFieldFunTwo(
//                   context,
//                   hint: ProjectConstants.enterTheName,
//                   fontSize: 10,
//                   controller: staffController.staffNameController,
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(width: 16), // Spacing between fields
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 buildTextFun(context,
//                     title: ProjectConstants.dateOfJoin,
//                     fontsize: 12,
//                     fontweight: FontWeight.w500,
//                     color: ProjectColors.blackColor575757),
//                 buildDatePickerField(context,
//                     hint: ProjectConstants.joiningDate,
//                     fontSize: 10,
//                     controller: staffController.staffJoiningDateController)
//               ],
//             ),
//           ),
//         ],
//       ),
//       SizedBox(height: 16), // Spacing between rows
//       Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 buildTextFun(context,
//                     title: ProjectConstants.mobileNumber,
//                     fontsize: 12,
//                     fontweight: FontWeight.w500,
//                     color: ProjectColors.blackColor575757),
//                 buildTextFormFieldFunThree(context,
//                     hint: ProjectConstants.enterMobileNumber,
//                     fontSize: 10,
//                     controller: staffController.staffMobileNumberController,
//                     inputFormatters: [
//                       FilteringTextInputFormatter.digitsOnly,
//                       LengthLimitingTextInputFormatter(10)
//                     ])
//               ],
//             ),
//           ),
//           SizedBox(width: 16), // Spacing between fields
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 buildTextFun(context,
//                     title: ProjectConstants.password,
//                     fontsize: 12,
//                     fontweight: FontWeight.w500,
//                     color: ProjectColors.blackColor575757),
//                 buildTextFormFieldFunThree(context,
//                     hint: ProjectConstants.enterPassword,
//                     fontSize: 10,
//                     controller: staffController.staffPasswordController,
//                     isPassword: true,
//                     keyboardType: TextInputType.text,
//                     inputFormatters: [LengthLimitingTextInputFormatter(8)])
//               ],
//             ),
//           ),
//         ],
//       ),
//       SizedBox(height: 16), // Spacing between rows
//       Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 buildTextFun(context,
//                     title: ProjectConstants.department,
//                     fontsize: 12,
//                     fontweight: FontWeight.w500,
//                     color: ProjectColors.blackColor575757),
//                 buildTextFormFieldFunTwo(
//                   context,
//                   hint: ProjectConstants.selectTheDepartment,
//                   fontSize: 10,
//                   dropdown: true,
//                   selectedValue:
//                       staffController.selectedDepartment.value.isEmpty
//                           ? ProjectConstants.selectTheDepartment
//                           : staffController.selectedDepartment.value,
//                   // Show selected department after selection
//                   dropdownItems: staffController.departmentList,
//                   // Populate dropdown
//                   onChanged: (value) {
//                     staffController.selectedDepartment.value =
//                         value ?? ''; // Update selected department
//                   },
//                 )
//               ],
//             ),
//           ),
//           SizedBox(width: 16), // Spacing between fields
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 buildTextFun(context,
//                     title: ProjectConstants.position,
//                     fontsize: 12,
//                     fontweight: FontWeight.w500,
//                     color: ProjectColors.blackColor575757),
//                 buildTextFormFieldFunTwo(
//                   context,
//                   hint: ProjectConstants.selectThePosition,
//                   // Default hint shown initially
//                   fontSize: 10,
//                   dropdown: true,
//
//                   selectedValue:
//                       staffController.selectedPosition.value.isNotEmpty
//                           ? staffController.selectedPosition.value
//                           : null,
//                   // Default to null if no value is selected
//                   dropdownItems: staffController.positionList,
//                   onChanged: (value) {
//                     // Ensure the default hint is not selectable
//                     if (value != ProjectConstants.selectThePosition) {
//                       staffController.selectedPosition.value = value ?? '';
//                     }
//                   },
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//       buildSizedBoxHeightFun(context, height: 24),
//       Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           buildContainerButtonFun(
//             context,
//             ProjectConstants.clear,
//             isBordered: true,
//             borderColor: ProjectColors.blackColor575757,
//             onPressed: () {},
//             isSmallSize: true,
//             showIcon: false, // No icon for "Clear" button
//           ),
//           buildContainerButtonFun(
//             context,
//             ProjectConstants.next,
//
//             color: ProjectColors.accentPink,
//             onPressed: () {
//               staffController.EmployeeDetails(context, selectedStaff);
//               //staffController.activeTab.value = 'Personal Details';
//             },
//             isSmallSize: true,
//             showIcon: false, // No icon for "Clear" button
//           ),
//           // Spacing between buttons
//         ],
//       ),
//     ],
//   );
// }

// buildStaffUiFun(
//   BuildContext context,
//   StaffModel? selectedStaff,
//   SaStaffController staffController,
// ) {
//   return Container(
//     height: 370,
//     width: 560,
//     decoration: BoxDecoration(
//       color: ProjectColors.whiteColor,
//       borderRadius: BorderRadius.circular(10),
//       border: Border.all(color: Colors.grey[200]!),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black.withOpacity(0.1),
//           blurRadius: 5,
//           offset: Offset(0, 2),
//         ),
//       ],
//     ),
//     child: Padding(
//       padding: const EdgeInsets.all(25.0),
//       child: Column(
//         children: [
//           // Tab Navigation
//           Obx(
//             () => Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 GestureDetector(
//                   onTap: () => staffController.activeTab.value = 'Employee',
//                   child: Text(
//                     "Employee",
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                       color: staffController.activeTab.value == 'Employee'
//                           ? ProjectColors.accentPink
//                           : ProjectColors.blackColor575757,
//                       decoration: staffController.activeTab.value == 'Employee'
//                           ? TextDecoration.underline
//                           : null,
//                     ),
//                   ),
//                 ),
//                 GestureDetector(
//                   // onTap: () => staffController
//                   //     .activeTab.value = 'Personal Details',
//                   child: Text(
//                     "Personal Details",
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                       color:
//                           staffController.activeTab.value == 'Personal Details'
//                               ? ProjectColors.accentPink
//                               : ProjectColors.blackColor575757,
//                       decoration:
//                           staffController.activeTab.value == 'Personal Details'
//                               ? TextDecoration.underline
//                               : null,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           buildSizedBoxHeightFun(context, height: 20),
//
//           // Tab Content
//           Expanded(
//             child: Obx(
//               () => staffController.activeTab.value == 'Employee'
//                   ? buildEmployeeContent(
//                       context, staffController, selectedStaff)
//                   : buildPersonalDetailsContent(
//                       context, staffController, selectedStaff),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

// Personal Details Content
// Widget buildPersonalDetailsContent(BuildContext context,
//     SaStaffController staffController, StaffModel? selectedStaff) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 buildTextFun(context,
//                     title: ProjectConstants.dateOfBirth,
//                     fontsize: 12,
//                     fontweight: FontWeight.w500,
//                     color: ProjectColors.blackColor575757),
//                 buildDatePickerField(context,
//                     hint: ProjectConstants.enterDOB,
//                     fontSize: 10,
//                     controller: staffController.staffDateOfBirthController)
//               ],
//             ),
//           ),
//           SizedBox(width: 16), // Spacing between fields
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 buildTextFun(context,
//                     title: ProjectConstants.mobileNumberTwo,
//                     fontsize: 12,
//                     fontweight: FontWeight.w500,
//                     color: ProjectColors.blackColor575757),
//                 buildTextFormFieldFunThree(context,
//                     hint: ProjectConstants.enterMobileNumber,
//                     fontSize: 10,
//                     controller: staffController.staffMobileNumber2Controller,
//                     inputFormatters: [
//                       FilteringTextInputFormatter.digitsOnly,
//                       LengthLimitingTextInputFormatter(10)
//                     ])
//               ],
//             ),
//           ),
//         ],
//       ),
//       SizedBox(height: 16), // Spacing between rows
//       Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 buildTextFun(context,
//                     title: ProjectConstants.enterAddress,
//                     fontsize: 12,
//                     fontweight: FontWeight.w500,
//                     color: ProjectColors.blackColor575757),
//                 buildTextFormFieldFunTwo(
//                   context,
//                   isSmallSize: false,
//                   hint: ProjectConstants.enterAddress,
//                   fontSize: 10,
//                   controller: staffController.staffAddressController,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       buildSizedBoxHeightFun(context, height: 24),
//       Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           buildContainerButtonFun(
//             context,
//             "Clear",
//             isBordered: true,
//             borderColor: ProjectColors.blackColor575757,
//             onPressed: () {},
//             isSmallSize: true,
//             showIcon: false, // No icon for "Clear" button
//           ),
//           buildContainerButtonFun(
//             context,
//
//             staffController.staffButtonName.value,
//
//             color: ProjectColors.accentPink,
//             onPressed: () async => {
//               if (staffController.staffId != null)
//                 {
//                   print("updateTrue"),
//                   await staffController.saveOrUpdateStaff(
//                       context, staffController.staffId.value, staffController)
//                 }
//               else
//                 {
//                   print("addTrue"),
//                   await staffController.saveOrUpdateStaff(
//                       context, null, staffController)
//                 },
//               staffController.fetchStaff(),
//             },
//
//             isSmallSize: true,
//             showIcon: false, // No icon for "Clear" button
//           ),
//           // Spacing between buttons
//         ],
//       ),
//     ],
//   );
// }
//

//---------------------------------Department-------------------------------------------------

buildDepartmentUiFun(BuildContext context, DepartmentModel? selectedDepartment,
    SaDepartmentController saDepartmentController) {
  return Container(
    height: 220,
    width: 320,
    decoration: BoxDecoration(
      color: ProjectColors.whiteColor,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey[200]!),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 5,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.only(left: 30, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                saDepartmentController.clearController(context);
                saDepartmentController.toggleButton();
              },
            ),
          ),
          buildTextFun(
            context,
            title: ProjectConstants.nameOfTheDepartment,
            fontsize: 12,
            fontweight: FontWeight.w500,
            color: Colors.black,
          ),
          buildSizedBoxHeightFun(context, height: 5),
          buildTextFormFieldFunTwo(
            context,
            hint: ProjectConstants.enterTheDepartment,
            fontSize: 12,
            controller: saDepartmentController.departmentNameController,
          ),
          buildSizedBoxHeightFun(context, height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: buildContainerButtonFun(
                context, saDepartmentController.departmentButtonName.value,
                color: ProjectColors.accentPink,
                isSmallSize: true,
                showIcon: false,
                onPressed: () async => {
                      saDepartmentController.fetchDepartment(),
                      if (selectedDepartment != null)
                        {
                          await saDepartmentController.saveOrUpdateDepartment(
                              context,
                              selectedDepartment,
                              saDepartmentController)
                        }
                      else
                        {
                          await saDepartmentController.saveOrUpdateDepartment(
                              context, null, saDepartmentController)
                        }
                    }),
          ),
        ],
      ),
    ),
  );
}

buildDepartmentUiFunTwo(
    BuildContext context,
    SaDepartmentController saDepartmentController,
    void Function(VoidCallback fn) setState,
    DepartmentModel? selectedDepartment) {
  return Expanded(
    child: Column(
      children: [
        Container(
          height: 56,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[300],
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Center(
                  child: buildTextFun(
                    context,
                    title: ProjectConstants.department,
                    fontsize: 16,
                    fontweight: FontWeight.w600,
                    color: ProjectColors.blackColor575757,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: buildTextFun(
                    context,
                    title: ProjectConstants.createdDate,
                    fontsize: 16,
                    fontweight: FontWeight.w600,
                    color: ProjectColors.blackColor575757,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: buildTextFun(
                    context,
                    title: ProjectConstants.createdTime,
                    fontsize: 16,
                    fontweight: FontWeight.w600,
                    color: ProjectColors.blackColor575757,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: buildTextFun(
                    context,
                    title: ProjectConstants.manage,
                    fontsize: 16,
                    fontweight: FontWeight.w600,
                    color: ProjectColors.blackColor575757,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Obx(
            () => ListView.builder(
              itemCount: saDepartmentController.deptList.length,
              itemBuilder: (context, index) {
                final department = saDepartmentController.deptList[index];
                return Container(
                  height: 56,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.4),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: buildTextFun(
                            context,
                            title: department.deptName,
                            fontsize: 16,
                            fontweight: FontWeight.w500,
                            color: ProjectColors.blackColor575757,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: buildTextFun(
                            context,
                            title: DateFormat('dd-MM-yyyy')
                                .format(department.deptCreatedAt),
                            fontsize: 16,
                            fontweight: FontWeight.w500,
                            color: ProjectColors.blackColor575757,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: buildTextFun(
                            context,
                            title: DateFormat('hh:mm a')
                                .format(department.deptCreatedAt),
                            fontsize: 16,
                            fontweight: FontWeight.w500,
                            color: ProjectColors.blackColor575757,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .center, // Align icons at the center
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    saDepartmentController
                                        .departmentButtonName.value = 'Update';

                                    saDepartmentController
                                        .departmentNameController
                                        .text = department.deptName;
                                  });

                                  saDepartmentController.toggleButton();
                                  selectedDepartment = department;
                                },
                              ),
                              buildDeleteContainerFun(
                                  context,
                                  saDepartmentController,
                                  department,
                                  'department')
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    ),
  );
}

//----------------------------------Position------------------------------------
buildPositionUiFun(BuildContext context, PositionModel? selectedPosition,
    SaPositionController saPositionController) {
  return Container(
    height: 220,
    width: 320,
    decoration: BoxDecoration(
      color: ProjectColors.whiteColor,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey[200]!),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 5,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.only(left: 30, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                saPositionController.clearController(context);
                saPositionController.toggleButton();
              },
            ),
          ),
          buildTextFun(
            context,
            title: ProjectConstants.nameOfThePosition,
            fontsize: 12,
            fontweight: FontWeight.w500,
            color: Colors.black,
          ),
          buildSizedBoxHeightFun(context, height: 5),
          buildTextFormFieldFunTwo(
            context,
            hint: ProjectConstants.enterThePosition,
            fontSize: 12,
            controller: saPositionController.positionNameController,
          ),
          buildSizedBoxHeightFun(context, height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: buildContainerButtonFun(
                context, saPositionController.positionButtonName.value,
                color: ProjectColors.accentPink,
                isSmallSize: true,
                showIcon: false,
                onPressed: () async => {
                      saPositionController.fetchPosition(),
                      if (selectedPosition != null)
                        {
                          await saPositionController.saveOrUpdatePosition(
                              context, selectedPosition, saPositionController)
                        }
                      else
                        {
                          await saPositionController.saveOrUpdatePosition(
                              context, null, saPositionController)
                        }
                    }),
          ),
        ],
      ),
    ),
  );
}

buildPositionUIFunTwo(
    BuildContext context,
    SaPositionController saPositionController,
    void Function(VoidCallback fn) setState,
    PositionModel? selectedPosition) {
  return Expanded(
    child: Column(
      children: [
        Container(
          height: 56,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[300],
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Center(
                  child: buildTextFun(
                    context,
                    title: ProjectConstants.position,
                    fontsize: 16,
                    fontweight: FontWeight.w600,
                    color: ProjectColors.blackColor575757,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: buildTextFun(
                    context,
                    title: ProjectConstants.createdDate,
                    fontsize: 16,
                    fontweight: FontWeight.w600,
                    color: ProjectColors.blackColor575757,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: buildTextFun(
                    context,
                    title: ProjectConstants.createdTime,
                    fontsize: 16,
                    fontweight: FontWeight.w600,
                    color: ProjectColors.blackColor575757,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: buildTextFun(
                    context,
                    title: ProjectConstants.manage,
                    fontsize: 16,
                    fontweight: FontWeight.w600,
                    color: ProjectColors.blackColor575757,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Obx(
            () => ListView.builder(
              itemCount: saPositionController.positionList.length,
              itemBuilder: (context, index) {
                final position = saPositionController.positionList[index];
                return Container(
                  height: 56,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.4),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: buildTextFun(
                            context,
                            title: position.positionName,
                            fontsize: 16,
                            fontweight: FontWeight.w500,
                            color: ProjectColors.blackColor575757,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: buildTextFun(
                            context,
                            title: DateFormat('dd-MM-yyyy')
                                .format(position.positionCreatedAt),
                            fontsize: 16,
                            fontweight: FontWeight.w500,
                            color: ProjectColors.blackColor575757,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: buildTextFun(
                            context,
                            title: DateFormat('hh:mm a')
                                .format(position.positionCreatedAt),
                            fontsize: 16,
                            fontweight: FontWeight.w500,
                            color: ProjectColors.blackColor575757,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    saPositionController
                                        .positionButtonName.value = "Update";

                                    saPositionController.positionNameController
                                        .text = position.positionName;
                                  });

                                  saPositionController.toggleButton();
                                  selectedPosition = position;
                                },
                              ),
                              buildDeleteContainerFun(context,
                                  saPositionController, position, 'position')
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    ),
  );
}

//--------------------------------DropdownContainerFunction----------------

Widget buildDropdownContainer({
  required double fontSize,
  String? selectedValue,
  List<String>? dropdownItems,
  Function(String?)? onChanged,
  required String hint,
}) {
  return Container(
    height: 40,
    width: 243,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      border: Border.all(color: ProjectColors.greyColorA6A6A6),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: DropdownButton<String>(
        value: selectedValue,
        hint: Text(
          hint,
          style: TextStyle(fontSize: fontSize),
        ),
        onChanged: onChanged,
        isExpanded: true,
        underline: SizedBox(),
        items: dropdownItems?.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(fontSize: fontSize),
            ),
          );
        }).toList(),
      ),
    ),
  );
}

//--------------------------staff Functions--------------------------------

//--------------------------buildStaffDetailsUiFun-----------------------
//inside
//--------------------------buildContainerButtonFunTwo-----------------------

buildStaffDetailsUiFun(
  BuildContext context,
  SaStaffController saStaffController,
) {
  return Container(
    height: 370,
    width: 560,
    decoration: BoxDecoration(
      color: ProjectColors.whiteColor,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey[200]!),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 5,
          offset: Offset(0, 2),
        )
      ],
    ),
    child: Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            children: [
              Spacer(), // Push Employee Details to the center
              buildTextFun(
                context,
                title: ProjectConstants.employeeDetails,
                fontsize: 16,
                fontweight: FontWeight.bold,
                color: ProjectColors.accentPink,
              ),
              Spacer(), // Equal spacing on the right side
              IconButton(
                onPressed: () {
                  print("close icon pressed");
                  saStaffController.clearController(context);
                  saStaffController.toggleButton();
                },
                icon: Icon(Icons.close),
              ),
            ],
          ),
          buildSizedBoxHeightFun(context, height: 10),
          // Scrollable content
          Expanded(
            child: ScrollbarTheme(
              data: ScrollbarThemeData(
                thumbColor:
                    WidgetStateProperty.all(ProjectColors.greyColorA6A6A6),
                thickness: WidgetStateProperty.all(2.0),
                radius: const Radius.circular(5),
                thumbVisibility: WidgetStateProperty.all(true),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildTextFun(context,
                                  title: ProjectConstants.staffName,
                                  fontsize: 12,
                                  fontweight: FontWeight.w500,
                                  color: ProjectColors.blackColor191919),
                              buildTextFormFieldFunTwo(context,
                                  hint: ProjectConstants.staffEnterTheName,
                                  fontSize: 10,
                                  controller:
                                      saStaffController.staffNameController),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildTextFun(context,
                                  title: ProjectConstants.staffJoiningDate,
                                  fontsize: 12,
                                  fontweight: FontWeight.w500,
                                  color: ProjectColors.blackColor575757),
                              buildDatePickerField(context,
                                  hint: ProjectConstants.staffJoiningDate,
                                  fontSize: 10,
                                  controller: saStaffController
                                      .staffDateOfJoiningController),
                            ],
                          ),
                        ),
                      ],
                    ),
                    buildSizedBoxHeightFun(context, height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildTextFun(
                                context,
                                title: ProjectConstants.staffMobileNumber,
                                fontsize: 12,
                                fontweight: FontWeight.w500,
                                color: ProjectColors.blackColor575757,
                              ),
                              buildTextFormFieldFunThree(context,
                                  hint: ProjectConstants.staffEnterMobileNumber,
                                  fontSize: 10,
                                  controller: saStaffController
                                      .staffMobileNumberController,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(10),
                                  ]),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildTextFun(context,
                                  title: ProjectConstants.staffPassword,
                                  fontsize: 12,
                                  fontweight: FontWeight.w500,
                                  color: ProjectColors.blackColor575757),
                              buildTextFormFieldFunThree(context,
                                  hint: ProjectConstants.staffEnterPassword,
                                  fontSize: 10,
                                  controller:
                                      saStaffController.staffPasswordController,
                                  isPassword: true,
                                  inputFormatters: [
                                    FilteringTextInputFormatter
                                        .singleLineFormatter,
                                    LengthLimitingTextInputFormatter(8),
                                  ]),
                            ],
                          ),
                        ),
                      ],
                    ),
                    buildSizedBoxHeightFun(context, height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildTextFun(context,
                                  title: ProjectConstants.department,
                                  fontsize: 12,
                                  fontweight: FontWeight.w500,
                                  color: ProjectColors.blackColor575757),
                              buildDropdownContainer(
                                fontSize: 10,
                                hint: ProjectConstants.selectTheDepartment,
                                dropdownItems: saStaffController.departmentList,
                                selectedValue: saStaffController
                                        .selectedDepartment.value.isEmpty
                                    ? null
                                    : saStaffController
                                        .selectedDepartment.value,
                                onChanged: (value) {
                                  if (value != null) {
                                    saStaffController.selectedDepartment.value =
                                        value;
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildTextFun(context,
                                  title: ProjectConstants.position,
                                  fontsize: 12,
                                  fontweight: FontWeight.w500,
                                  color: ProjectColors.blackColor575757),
                              buildDropdownContainer(
                                fontSize: 10,
                                hint: ProjectConstants.selectThePosition,
                                dropdownItems: saStaffController.positionList,
                                selectedValue: saStaffController
                                        .selectedPosition.value.isEmpty
                                    ? null
                                    : saStaffController.selectedPosition.value,
                                onChanged: (value) {
                                  if (value != null) {
                                    saStaffController.selectedPosition.value =
                                        value;
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    buildSizedBoxHeightFun(context, height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildTextFun(context,
                                  title: ProjectConstants.staffDateOfBirth,
                                  fontsize: 12,
                                  fontweight: FontWeight.w500,
                                  color: ProjectColors.blackColor575757),
                              buildDatePickerField(context,
                                  hint: ProjectConstants.staffEnterDOB,
                                  fontSize: 10,
                                  controller: saStaffController
                                      .staffDateOfBirthController),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildTextFun(context,
                                  title: ProjectConstants.staffMobileNumberTwo,
                                  fontsize: 12,
                                  fontweight: FontWeight.w500,
                                  color: ProjectColors.blackColor575757),
                              buildTextFormFieldFunThree(context,
                                  hint: ProjectConstants.staffEnterMobileNumber,
                                  fontSize: 10,
                                  controller: saStaffController
                                      .staffMobileNumberTwoController,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(10),
                                  ]),
                            ],
                          ),
                        ),
                      ],
                    ),
                    buildSizedBoxHeightFun(context, height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildTextFun(context,
                                  title: ProjectConstants.staffEnterAddress,
                                  fontsize: 12,
                                  fontweight: FontWeight.w500,
                                  color: ProjectColors.blackColor575757),
                              buildTextFormFieldFunTwo(context,
                                  hint: ProjectConstants.staffEnterAddress,
                                  fontSize: 10,
                                  controller:
                                      saStaffController.staffAddressController,
                                  isSmallSize: false),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          buildSizedBoxHeightFun(context, height: 25),
          Center(
            child: buildContainerButtonFun(
              context,
              saStaffController.buttonName.value,
              showIcon: false,
              customHeight: 30,
              customWidth: 130,
              onPressed: () {
                print("Done Presses");
                print("staffId23 : ${saStaffController.staffId}");

                if (saStaffController.staffId.value.isEmpty) {
                  print("add");
                  saStaffController.saveStaffData(context, null);
                } else {
                  print("update");
                  saStaffController.saveStaffData(
                      context, saStaffController.staffId.toString());
                }
              },
            ),
          ),
        ],
      ),
    ),
  );
}

//--------------------------buildStaffDetailsUiFunTwo-----------------------
buildStaffDetailsUiFunTwo(
  BuildContext context, {
  required double width,
  required String employee,
  required String credentials,
  required String department,
  required String manage,
  required bool isSmallSize,
  required SaStaffController staffController,
}) {
  return Expanded(
      child: Column(
    children: [
      Container(
        height: isSmallSize ? 56 : 80,
        width: width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: ProjectColors.lytWhiteColor),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                flex: 3,
                child: Center(
                  child: buildTextFun(context,
                      title: employee,
                      fontsize: 16,
                      fontweight: FontWeight.w600,
                      color: ProjectColors.secondaryTextColor),
                )),
            Expanded(
                flex: 3,
                child: Center(
                  child: buildTextFun(context,
                      title: credentials,
                      fontsize: 16,
                      fontweight: FontWeight.w600,
                      color: ProjectColors.secondaryTextColor),
                )),
            Expanded(
                flex: 2,
                child: Center(
                  child: buildTextFun(context,
                      title: department,
                      fontsize: 16,
                      fontweight: FontWeight.w600,
                      color: ProjectColors.secondaryTextColor),
                )),
            Expanded(
                flex: 2,
                child: Center(
                  child: buildTextFun(context,
                      title: manage,
                      fontsize: 16,
                      fontweight: FontWeight.w600,
                      color: ProjectColors.secondaryTextColor),
                )),
          ],
        ),
      ),
      buildSizedBoxHeightFun(context, height: 10),
      Expanded(
        child: Obx(
          () => ListView.builder(
            itemCount: staffController.staffList.length,
            itemBuilder: (context, index) {
              final staff = staffController.staffList[index];
              return Column(
                children: [
                  Container(
                    height: isSmallSize ? 80 : 56,
                    width: width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.4),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildTextFun(context,
                                    title: staff.staffName,
                                    maxLines: 1,
                                    fontsize: 16,
                                    fontweight: FontWeight.bold,
                                    color: Colors.black),
                                SizedBox(height: 4),
                                buildTextFun(context,
                                    title: staff.positionName,
                                    fontsize: 16,
                                    fontweight: FontWeight.bold,
                                    color: Colors.grey),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildTextFun(context,
                                    title: staff.staffMobileNumber,
                                    fontsize: 16,
                                    fontweight: FontWeight.bold,
                                    color: ProjectColors.blackColor575757),
                                SizedBox(height: 4),
                                buildTextFun(context,
                                    title: staff.staffPassword,
                                    fontsize: 16,
                                    fontweight: FontWeight.bold,
                                    color: ProjectColors.grey),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: buildTextFun(context,
                                title: staff.deptName,
                                fontsize: 16,
                                fontweight: FontWeight.bold,
                                color: ProjectColors.blackColor575757),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.red),
                                  onPressed: () {
                                    staffController.buttonName.value =
                                        ProjectConstants.update;

                                    print("staffID : ${staff.staffId}");
                                    staffController.staffId.value =
                                        staff.staffId;

                                    staffController.currentDateTime.value =
                                        staff.staffCreatedAt.toString();

                                    staffController.staffNameController.text =
                                        staff.staffName;
                                    staffController.staffDateOfJoiningController
                                        .text = staff.staffJoiningDate;
                                    staffController.staffMobileNumberController
                                        .text = staff.staffMobileNumber;
                                    staffController.staffPasswordController
                                        .text = staff.staffPassword;
                                    staffController.selectedDepartment.value =
                                        staff.deptName.toString();
                                    staffController.selectedPosition.value =
                                        staff.positionName.toString();
                                    staffController.staffDateOfBirthController
                                        .text = staff.staffDob;
                                    staffController
                                        .staffMobileNumberTwoController
                                        .text = staff.staffMobileNumberTwo;
                                    staffController.staffAddressController
                                        .text = staff.staffAddress;

                                    staffController.toggleButton();
                                  },
                                ),
                                buildDeleteContainerFun(
                                    context, staffController, staff, "staff")
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10), // Add spacing here
                ],
              );
            },
          ),
        ),
      )
    ],
  ));
}

Widget buildDeleteContainerFun(
  BuildContext context,
  dynamic
      controller, // The controller (staffController, saPositionController, or saDepartmentController)
  dynamic item, // The staff, position, or department object
  String type,
) {
  return IconButton(
    icon: Icon(Icons.delete, color: Colors.red),
    onPressed: () {
      Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTextFun(
                context,
                title: ProjectConstants.doYouWantToDelete,
                fontsize: 14,
                fontFamily: 'Poppins',
                fontweight: FontWeight.w500,
                color: ProjectColors.blackColor575757,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Cancel Button
                  TextButton(
                    style: TextButton.styleFrom(
                      side: BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      Get.back(); // Close the dialog
                    },
                    child: buildTextFun(
                      context,
                      title: ProjectConstants.cancel,
                      fontsize: 12,
                      fontweight: FontWeight.w800,
                      fontFamily: 'Poppins',
                      color: ProjectColors.orange,
                    ),
                  ),
                  // Delete Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      Get.back(); // Close the dialog
                      if (type == "staff") {
                        // Call deleteStaffData for staff
                        controller.deleteStaffData(context, item.staffId);
                      } else if (type == "position") {
                        // Call deletePositionData for position
                        controller.deletePositionData(context, item.positionId);
                      } else if (type == "department") {
                        // Call deleteDepartmentData for department
                        controller.deleteDepartmentData(context, item.deptId);
                      }
                    },
                    child: buildTextFun(
                      context,
                      title: ProjectConstants.yes,
                      fontsize: 12,
                      fontweight: FontWeight.w800,
                      fontFamily: 'Poppins',
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

//---------------------------Scaffold MessageFun--------------------------

void buildScaffoldMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(
          fontSize: 12,
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.yellowAccent,
      behavior: SnackBarBehavior.floating));
}

//--------------------------------Logout Container---------------------------

Widget buildLogoutButton(BuildContext context) {
  return InkWell(
    onTap: () {
      Get.dialog(
        AlertDialog(
          contentPadding: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Center(
            child: Text(
              'Want to Logout?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Tick Icon Container for confirming logout
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: ProjectColors
                        .primaryGreen, // Border color for tick icon
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: Icon(Icons.check),
                  color: ProjectColors.primaryGreen,
                  onPressed: () {
                    Get.offNamed(
                      ProjectRouter.SA_LOGIN_SCREEN,
                    );
                  },
                ),
              ),
              SizedBox(width: 20), // Space between icons

              Container(
                decoration: BoxDecoration(
                  color: ProjectColors
                      .primaryGreen, // Background color for close icon
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: Icon(Icons.close),
                  color: Colors.white,
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.logout, // Logout icon
            color: ProjectColors.primaryGreen,
          ),
          SizedBox(width: 10), // Add space between icon and text
          Text(
            'Logout',
            style: TextStyle(
              color: ProjectColors.primaryGreen,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    ),
  );
}
