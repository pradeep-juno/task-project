import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jk_event_management/model/position_model.dart';

import '../../controller/sa_position_controller.dart';
import '../../utils/Project_colors.dart';
import '../../utils/functions.dart';
import '../../utils/project_constants.dart';

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
                  setState(() {
                    saPositionController.positionButtonName.value = 'Done';
                  });
                  saPositionController.toggleButton();
                },
              ),
            ),
            const SizedBox(height: 20),
            Obx(() => saPositionController.isButtonClicked.value
                ? buildPositionUiFun(
                    context, selectedPosition, saPositionController)
                : buildPositionUIFunTwo(
                    context, saPositionController, setState, selectedPosition)),
          ],
        ),
      ),
    );
  }
}
