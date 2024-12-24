import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jk_event_management/model/position_model.dart';

import '../../controller/sa_login_controller.dart';
import '../../controller/sa_position_controller.dart';
import '../../controller/sa_staff_controller.dart';
import '../../utils/Project_colors.dart';
import '../../utils/functions.dart';
import '../../utils/project_constants.dart';

class SaPositionScreen extends StatefulWidget {
  const SaPositionScreen({super.key});

  @override
  State<SaPositionScreen> createState() => _SaPositionScreenState();
}

class _SaPositionScreenState extends State<SaPositionScreen> {
  SaStaffController saStaffController = Get.put(SaStaffController());
  final SaLoginController saLoginController = Get.put(SaLoginController());

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 75,
            width: 950,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(0),
                bottomRight: Radius.circular(0),
              ),
              color: const Color(0xFF17817D).withOpacity(0.1),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 45,
                      padding: const EdgeInsets.only(left: 10, bottom: 15),
                      decoration: BoxDecoration(
                        color: const Color(
                            0xFFD3E6E5), // Light greenish background
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: const Color(0xFF17817D)), // Border color
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller:
                                  saPositionController.searchNameController,
                              style: const TextStyle(color: Color(0xFF17817D)),
                              decoration: const InputDecoration(
                                hintText: "Search",
                                hintStyle: TextStyle(
                                    color:
                                        Color(0xFF17817D)), // Hint text color
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                print(value);
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.only(top: 10, right: 10),
                            child: const Icon(Icons.search,
                                color: Color(0xFF17817D)),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Notification icon
                  const Icon(Icons.notifications, color: Color(0xFF17817D)),
                  const SizedBox(width: 8),
                  const VerticalDivider(
                    color: Color(0xFF17817D),
                    thickness: 2,
                    indent: 22,
                    endIndent: 22,
                  ),
                  const SizedBox(width: 8),

                  // Profile
                  Row(
                    children: [
                      Obx(() {
                        return buildCircleAvatarFunTwo(
                            radius: 18,
                            text: saLoginController.saAdminName.value
                                .substring(0, 2),
                            backgroundColor: ProjectColors.primaryGreen,
                            color: Colors.white,
                            fontweight: FontWeight.bold);
                      }),
                      SizedBox(width: 8),
                      Obx(() {
                        return buildTextFun(
                          context,
                          title: "${saLoginController.saAdminName.value}",
                          fontsize: 18,
                          fontweight: FontWeight.bold,
                          color: Colors.black,
                        );
                      })
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
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
                        setState(() {
                          saPositionController.positionButtonName.value =
                              'Done';
                        });
                        saPositionController.toggleButton();
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Obx(() => saPositionController.isButtonClicked.value
                      ? buildPositionUiFun(
                          context, selectedPosition, saPositionController)
                      : buildPositionUIFunTwo(context, saPositionController,
                          setState, selectedPosition)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
