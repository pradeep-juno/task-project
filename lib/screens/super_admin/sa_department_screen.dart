import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jk_event_management/model/department_model.dart';

import '../../controller/sa_department_controller.dart';
import '../../utils/Project_colors.dart';
import '../../utils/functions.dart';
import '../../utils/project_constants.dart';

class SaDepartmentScreen extends StatefulWidget {
  const SaDepartmentScreen({super.key});

  @override
  State<SaDepartmentScreen> createState() => _SaDepartmentScreenState();
}

class _SaDepartmentScreenState extends State<SaDepartmentScreen> {
  final SaDepartmentController saDepartmentController =
      Get.put(SaDepartmentController());

  @override
  void initState() {
    super.initState();
    saDepartmentController.fetchDepartment();
  }

  DepartmentModel? selectedDepartment;

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
                ProjectConstants.addDepartment,
                color: saDepartmentController.isButtonClicked.value
                    ? ProjectColors.greyColorA6A6A6
                    : ProjectColors.accentPink,
                isSmallSize: true,
                onPressed: () {
                  setState(() {
                    saDepartmentController.departmentButtonName.value = "Done";
                  });
                  saDepartmentController.toggleButton();
                },
              ),
            ),
            SizedBox(height: 20),
            Obx(
              () => saDepartmentController.isButtonClicked.value
                  ? buildDepartmentUiFun(
                      context, selectedDepartment, saDepartmentController)
                  : buildDepartmentUiFunTwo(context, saDepartmentController,
                      setState, selectedDepartment),
            ),
          ],
        ),
      ),
    );
  }
}
