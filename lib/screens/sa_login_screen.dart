import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jk_event_management/utils/Project_colors.dart';
import 'package:jk_event_management/utils/project_constants.dart';

import '../controller/sa_login_controller.dart';
import '../utils/functions.dart';

class SaLoginScreen extends StatefulWidget {
  const SaLoginScreen({super.key});

  @override
  State<SaLoginScreen> createState() => _SaLoginScreenState();
}

class _SaLoginScreenState extends State<SaLoginScreen> {
  final SaLoginController saLoginController = Get.put(SaLoginController());

  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          Container(
            height: 814,
            width: 640,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(ProjectConstants.loginImage))),
          ),
          Container(
            height: 814,
            width: 640,
            color: ProjectColors.accentLytPink,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: buildCircleAvatarFun(
                    context,
                    radius: 50,
                    imagePath: ProjectConstants.jkImage,
                  ),
                ),
                buildSizedBoxHeightFun(context, height: 24),
                Container(
                  height: 424,
                  width: 373,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: ProjectColors.accentPink.withOpacity(0.2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTextFun(context,
                            title: ProjectConstants.userId,
                            fontsize: 14,
                            fontweight: FontWeight.w500,
                            color: ProjectColors.blackColor191919),
                        buildSizedBoxHeightFun(context, height: 10),
                        buildTextFormFieldFun(
                          context,
                          isPassword: false,
                          controller: saLoginController.mobileController,
                          icon: Icons.person,
                          color: ProjectColors.accentPink,
                          border: false,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10)
                          ],
                          hint: ProjectConstants.enterMobileNumber,
                          hintStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: ProjectColors.greyColorC9C9C9,
                          ),
                        ),
                        buildSizedBoxHeightFun(context, height: 10),
                        buildTextFun(context,
                            title: ProjectConstants.password,
                            fontsize: 14,
                            fontweight: FontWeight.w500,
                            color: ProjectColors.blackColor191919),
                        buildSizedBoxHeightFun(context, height: 5),
                        buildTextFormFieldFun(
                          context,
                          isPassword: true,
                          inputFormatters: [
                            FilteringTextInputFormatter.singleLineFormatter,
                            LengthLimitingTextInputFormatter(8)
                          ],
                          controller: saLoginController.passwordController,
                          icon: Icons.lock,
                          color: ProjectColors.accentPink,
                          border: false,
                          hint: ProjectConstants.enterPassword,
                          hintStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: ProjectColors.greyColorC9C9C9,
                          ),
                        ),
                        buildSizedBoxHeightFun(context, height: 60),
                        buildContainerButtonFun(context, ProjectConstants.login,
                            color: ProjectColors.accentPink,
                            showIcon: false,
                            onPressed: () => saLoginController.submit(context))
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
