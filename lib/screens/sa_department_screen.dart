import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jk_event_management/model/department_model.dart';

import '../controller/sa_department_controller.dart';
import '../utils/Project_colors.dart';
import '../utils/functions.dart';
import '../utils/project_constants.dart';

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
                  saDepartmentController.toggleButton();
                },
              ),
            ),
            const SizedBox(height: 20),
            Obx(
              () => saDepartmentController.isButtonClicked.value
                  ? buildDepartmentUiFun(context, selectedDepartment)
                  : Expanded(
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
                                itemCount:
                                    saDepartmentController.deptList.length,
                                itemBuilder: (context, index) {
                                  final department =
                                      saDepartmentController.deptList[index];
                                  return Container(
                                    height: 56,
                                    width: double.infinity,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 5),
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
                                              color: ProjectColors
                                                  .blackColor575757,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Center(
                                            child: buildTextFun(
                                              context,
                                              title: DateFormat('dd-MM-yyyy')
                                                  .format(
                                                      department.deptCreatedAt),
                                              fontsize: 16,
                                              fontweight: FontWeight.w500,
                                              color: ProjectColors
                                                  .blackColor575757,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Center(
                                            child: buildTextFun(
                                              context,
                                              title: DateFormat('hh:mm a')
                                                  .format(
                                                      department.deptCreatedAt),
                                              fontsize: 16,
                                              fontweight: FontWeight.w500,
                                              color: ProjectColors
                                                  .blackColor575757,
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
                                                  icon: Icon(Icons.edit,
                                                      color: Colors.red),
                                                  onPressed: () {
                                                    saDepartmentController
                                                        .toggleButton();
                                                    selectedDepartment =
                                                        department;
                                                  },
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons.delete,
                                                      color: Colors.red),
                                                  onPressed: () {
                                                    saDepartmentController
                                                        .deleteDepartmentData(
                                                            context,
                                                            department.deptId);
                                                  },
                                                ),
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
                    ),
            ),
          ],
        ),
      ),
    );
  }

  buildDepartmentUiFun(
      BuildContext context, DepartmentModel? selectedDepartment) {
    if (selectedDepartment != null) {
      saDepartmentController.departmentNameController.text =
          selectedDepartment.deptName;
    } else {
      saDepartmentController.clearController(context);
    }
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
                  context,
                  selectedDepartment != null
                      ? ProjectConstants.update
                      : ProjectConstants.done,
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
}
