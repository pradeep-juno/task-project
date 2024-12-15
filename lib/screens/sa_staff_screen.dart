import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jk_event_management/controller/sa_staff_controller.dart';

import '../utils/Project_colors.dart';
import '../utils/functions.dart';
import '../utils/project_constants.dart';

class SaStaffScreen extends StatefulWidget {
  const SaStaffScreen({super.key});

  @override
  State<SaStaffScreen> createState() => _SaStaffScreenState();
}

class _SaStaffScreenState extends State<SaStaffScreen> {
  final SaStaffController staffController = Get.put(SaStaffController());
  RxString activeTab = 'Employee'.obs; // Track the active tab

  @override
  void initState() {
    super.initState();
    staffController.fetchDepartments();
    staffController.fetchPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Button to toggle container visibility
            Obx(
              () => buildContainerButtonFun(
                context,
                ProjectConstants.addEmployee,
                isSmallSize: true,
                color: staffController.isButtonClicked.value
                    ? ProjectColors.greyColorA6A6A6
                    : ProjectColors.accentPink,
                onPressed: () {
                  staffController.toggleButton();
                },
              ),
            ),
            const SizedBox(height: 20),

            // Container with Employee and Personal Details
            Obx(
              () => staffController.isButtonClicked.value
                  ? Container(
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
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Column(
                          children: [
                            // Tab Navigation
                            Obx(
                              () => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () => activeTab.value = 'Employee',
                                    child: Text(
                                      "Employee",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: activeTab.value == 'Employee'
                                            ? ProjectColors.accentPink
                                            : ProjectColors.blackColor575757,
                                        decoration:
                                            activeTab.value == 'Employee'
                                                ? TextDecoration.underline
                                                : null,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () =>
                                        activeTab.value = 'Personal Details',
                                    child: Text(
                                      "Personal Details",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: activeTab.value ==
                                                'Personal Details'
                                            ? ProjectColors.accentPink
                                            : ProjectColors.blackColor575757,
                                        decoration: activeTab.value ==
                                                'Personal Details'
                                            ? TextDecoration.underline
                                            : null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            buildSizedBoxHeightFun(context, height: 20),

                            // Tab Content
                            Expanded(
                              child: Obx(
                                () => activeTab.value == 'Employee'
                                    ? buildEmployeeContent()
                                    : buildPersonalDetailsContent(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(), // Empty SizedBox when button is not clicked
            ),
          ],
        ),
      ),
    );
  }

  // Employee Content
  Widget buildEmployeeContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextFun(context,
                      title: ProjectConstants.name,
                      fontsize: 12,
                      fontweight: FontWeight.w500,
                      color: ProjectColors.blackColor575757),
                  buildTextFormFieldFunTwo(
                    context,
                    hint: ProjectConstants.enterTheName,
                    fontSize: 10,
                    controller: staffController.staffNameController,
                  ),
                ],
              ),
            ),
            SizedBox(width: 16), // Spacing between fields
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextFun(context,
                      title: ProjectConstants.dateOfJoin,
                      fontsize: 12,
                      fontweight: FontWeight.w500,
                      color: ProjectColors.blackColor575757),
                  buildTextFormFieldFunTwo(
                    context,
                    hint: ProjectConstants.joiningDate,
                    fontSize: 10,
                    controller: staffController.staffJoiningDateController,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16), // Spacing between rows
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextFun(context,
                      title: ProjectConstants.mobileNumber,
                      fontsize: 12,
                      fontweight: FontWeight.w500,
                      color: ProjectColors.blackColor575757),
                  buildTextFormFieldFunTwo(
                    context,
                    hint: ProjectConstants.enterMobileNumber,
                    fontSize: 10,
                    controller: staffController.staffMobileNumberController,
                  )
                ],
              ),
            ),
            SizedBox(width: 16), // Spacing between fields
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextFun(context,
                      title: ProjectConstants.password,
                      fontsize: 12,
                      fontweight: FontWeight.w500,
                      color: ProjectColors.blackColor575757),
                  buildTextFormFieldFunTwo(context,
                      hint: ProjectConstants.enterPassword,
                      fontSize: 10,
                      controller: staffController.staffPasswordController),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16), // Spacing between rows
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
                  buildTextFormFieldFunTwo(
                    context,
                    hint: ProjectConstants.selectTheDepartment,
                    fontSize: 10,
                    dropdown: true,
                    selectedValue:
                        staffController.selectedDepartment.value.isNotEmpty
                            ? staffController.selectedDepartment.value
                            : null, // Reactive selection
                    dropdownItems:
                        staffController.departmentList, // Populate dropdown
                    onChanged: (value) {
                      staffController.selectedDepartment.value = value ?? '';
                    },
                  )
                ],
              ),
            ),
            SizedBox(width: 16), // Spacing between fields
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextFun(context,
                      title: ProjectConstants.position,
                      fontsize: 12,
                      fontweight: FontWeight.w500,
                      color: ProjectColors.blackColor575757),
                  buildTextFormFieldFunTwo(
                    context,
                    hint: ProjectConstants
                        .selectThePosition, // Default hint shown initially
                    fontSize: 10,
                    dropdown: true,
                    selectedValue:
                        staffController.selectedPosition.value.isNotEmpty
                            ? staffController.selectedPosition.value
                            : null, // Default to null if no value is selected
                    dropdownItems: staffController.positionList,
                    onChanged: (value) {
                      // Ensure the default hint is not selectable
                      if (value != ProjectConstants.selectThePosition) {
                        staffController.selectedPosition.value = value ?? '';
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ),
        buildSizedBoxHeightFun(context, height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildContainerButtonFun(
              context,
              ProjectConstants.clear,
              isBordered: true,
              borderColor: ProjectColors.blackColor575757,
              onPressed: () {},
              isSmallSize: true,
              showIcon: false, // No icon for "Clear" button
            ),
            buildContainerButtonFun(
              context,
              ProjectConstants.next,

              color: ProjectColors.accentPink,
              onPressed: () {
                activeTab.value = 'Personal Details';
              },
              isSmallSize: true,
              showIcon: false, // No icon for "Clear" button
            ),
            // Spacing between buttons
          ],
        ),
      ],
    );
  }

  // Personal Details Content
  Widget buildPersonalDetailsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextFun(context,
                      title: ProjectConstants.dateOfBirth,
                      fontsize: 12,
                      fontweight: FontWeight.w500,
                      color: ProjectColors.blackColor575757),
                  buildTextFormFieldFunTwo(
                    context,
                    hint: ProjectConstants.enterDOB,
                    fontSize: 10,
                    controller: staffController.staffDateOfBirthController,
                  ),
                ],
              ),
            ),
            SizedBox(width: 16), // Spacing between fields
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextFun(context,
                      title: ProjectConstants.mobileNumber2,
                      fontsize: 12,
                      fontweight: FontWeight.w500,
                      color: ProjectColors.blackColor575757),
                  buildTextFormFieldFunTwo(
                    context,
                    hint: ProjectConstants.enterMobileNumber,
                    fontSize: 10,
                    controller: staffController.staffMobileNumber2Controller,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16), // Spacing between rows
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextFun(context,
                      title: ProjectConstants.enterAddress,
                      fontsize: 12,
                      fontweight: FontWeight.w500,
                      color: ProjectColors.blackColor575757),
                  buildTextFormFieldFunTwo(
                    context,
                    isSmallSize: false,
                    hint: ProjectConstants.enterAddress,
                    fontSize: 10,
                    controller: staffController.staffAddressController,
                  ),
                ],
              ),
            ),
          ],
        ),
        buildSizedBoxHeightFun(context, height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildContainerButtonFun(
              context,
              "Clear",
              isBordered: true,
              borderColor: ProjectColors.blackColor575757,
              onPressed: () {},
              isSmallSize: true,
              showIcon: false, // No icon for "Clear" button
            ),
            buildContainerButtonFun(
              context,
              ProjectConstants.done,

              color: ProjectColors.accentPink,
              onPressed: () => {
                staffController.saveEmployeeDetails(context),
              },
              isSmallSize: true,
              showIcon: false, // No icon for "Clear" button
            ),
            // Spacing between buttons
          ],
        ),
      ],
    );
  }

  // Helper TextField Builder
}
