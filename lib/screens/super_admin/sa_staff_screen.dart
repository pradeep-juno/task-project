import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jk_event_management/controller/sa_staff_controller.dart';
import 'package:jk_event_management/utils/functions.dart';
import 'package:jk_event_management/utils/project_constants.dart';

import '../../utils/Project_colors.dart';

class SaStaffScreen extends StatefulWidget {
  const SaStaffScreen({super.key});

  @override
  State<SaStaffScreen> createState() => _SaStaffScreenState();
}

class _SaStaffScreenState extends State<SaStaffScreen> {
  SaStaffController saStaffController = Get.put(SaStaffController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    saStaffController.fetchDepartments();
    saStaffController.fetchPositions();
    saStaffController.fetchStaff();
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
            Obx(
              () => buildContainerButtonFun(
                context,
                ProjectConstants.addEmployee,
                isSmallSize: true,
                showIcon: true,
                color: saStaffController.isButtonClicked.value
                    ? ProjectColors.greyColorA6A6A6
                    : ProjectColors.accentPink,
                onPressed: () {
                  print('add employee button pressed');
                  saStaffController.buttonName.value = ProjectConstants.done;
                  saStaffController.toggleButton();
                },
              ),
            ),
            buildSizedBoxHeightFun(context, height: 20),
            Obx(() => saStaffController.isButtonClicked.value
                ? buildStaffDetailsUiFun(context, saStaffController)
                : buildStaffDetailsUiFunTwo(context,
                    isSmallSize: true,
                    width: double.infinity,
                    employee: ProjectConstants.employee,
                    credentials: ProjectConstants.loginCredentials,
                    department: ProjectConstants.department,
                    manage: ProjectConstants.manage,
                    staffController: saStaffController))
          ],
        ),
      ),
    );
  }
}
