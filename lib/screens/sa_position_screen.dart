import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jk_event_management/model/position_model.dart';

import '../controller/sa_position_controller.dart';
import '../utils/Project_colors.dart';
import '../utils/functions.dart';
import '../utils/project_constants.dart';

class SaPositionScreen extends StatefulWidget {
  const SaPositionScreen({super.key});

  @override
  State<SaPositionScreen> createState() => _SaPositionScreenState();
}

class _SaPositionScreenState extends State<SaPositionScreen> {
  final SaPositionController saPositionController =
      Get.put(SaPositionController());

  @override
  void initState() {
    super.initState();
    saPositionController.fetchPosition();
  }

  PositionModel? selectedPosition;

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
                ProjectConstants.addPosition,
                color: saPositionController.isButtonClicked.value
                    ? ProjectColors.greyColorA6A6A6
                    : ProjectColors.accentPink,
                isSmallSize: true,
                onPressed: () {
                  saPositionController.toggleButton();
                },
              ),
            ),
            const SizedBox(height: 20),
            Obx(
              () => saPositionController.isButtonClicked.value
                  ? buildPositionUiFun(context, selectedPosition)
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
                                itemCount:
                                    saPositionController.positionList.length,
                                itemBuilder: (context, index) {
                                  final position =
                                      saPositionController.positionList[index];
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
                                              title: position.positionName,
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
                                                  .format(position
                                                      .positionCreatedAt),
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
                                                  .format(position
                                                      .positionCreatedAt),
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                  icon: Icon(Icons.edit,
                                                      color: Colors.red),
                                                  onPressed: () {
                                                    saPositionController
                                                        .toggleButton();
                                                    selectedPosition = position;
                                                  },
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons.delete,
                                                      color: Colors.red),
                                                  onPressed: () {
                                                    saPositionController
                                                        .deletePositionData(
                                                            context,
                                                            position
                                                                .positionId);
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

  buildPositionUiFun(BuildContext context, PositionModel? selectedPosition) {
    if (selectedPosition != null) {
      saPositionController.positionNameController.text =
          selectedPosition.positionName;
    } else {
      saPositionController.clearController(context);
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
                  context,
                  selectedPosition != null
                      ? ProjectConstants.update
                      : ProjectConstants.done,
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
}
