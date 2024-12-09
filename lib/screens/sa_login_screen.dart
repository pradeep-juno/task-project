import 'package:flutter/material.dart';
import 'package:task_proj/utils/Project_colors.dart';
import 'package:task_proj/utils/project_constants.dart';

import '../utils/functions.dart';

class SaLoginScreen extends StatefulWidget {
  const SaLoginScreen({super.key});

  @override
  State<SaLoginScreen> createState() => _SaLoginScreenState();
}

class _SaLoginScreenState extends State<SaLoginScreen> {
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
                          icon: Icons.person,
                          color: ProjectColors.accentPink,
                          border: false,
                          hint: ProjectConstants.enterMobileNumber,
                          hintStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: ProjectColors.greyColorC9C9C9,
                          ),
                        )
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
