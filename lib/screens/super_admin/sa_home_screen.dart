import 'package:awesome_icons/awesome_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jk_event_management/controller/sa_login_controller.dart';
import 'package:jk_event_management/controller/sa_staff_controller.dart';
import 'package:jk_event_management/screens/super_admin/sa_department_screen.dart';
import 'package:jk_event_management/screens/super_admin/sa_position_screen.dart';
import 'package:jk_event_management/screens/super_admin/sa_staff_screen.dart';
import 'package:jk_event_management/utils/Project_colors.dart';
import 'package:jk_event_management/utils/functions.dart';
import 'package:jk_event_management/utils/project_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaHomeScreen extends StatefulWidget {
  const SaHomeScreen({super.key});

  @override
  State<SaHomeScreen> createState() => _SaHomeScreenState();
}

class _SaHomeScreenState extends State<SaHomeScreen> {
  final SaLoginController saLoginController = Get.put(SaLoginController());
  final SaStaffController saStaffController = Get.put(SaStaffController());

  int selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    loadCustomerData();
    saLoginController.saAdminName.listen((name) {});
  }

  Future<void> loadCustomerData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String id = '';

    setState(() {
      id = prefs.getString('id') ?? 'Not Available';
    });

    print("Admin id :$id");
    saLoginController.listensaAdminDataUpdates(context, id);
  }

  final List<Widget> screens = [
    SaDepartmentScreen(), //[0]
    SaPositionScreen(), //[1]
    SaStaffScreen(), //[2]
  ];

  void onMenuItemTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: 300,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              color: ProjectColors.greenLightD3E6E5.withOpacity(0.4),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 80,
                    width: 100,
                    child: buildImageAssetsFun(
                      context,
                      width: 72,
                      height: 72,
                      imagePath: ProjectConstants.jkImage,
                      circleAvatar: false,
                    ),
                  ),
                  buildSizedBoxHeightFun(context, height: 72),
                  buildSidebarItem(
                    context,
                    icon: FontAwesomeIcons.building,
                    title: ProjectConstants.departments,
                    index: 0,
                    selectedIndex: selectedIndex,
                    onMenuItemTap: () => onMenuItemTap(0),
                  ),
                  buildSizedBoxHeightFun(context, height: 20),
                  buildSidebarItem(
                    context,
                    icon: FontAwesomeIcons.building,
                    title: ProjectConstants.positions,
                    index: 1,
                    selectedIndex: selectedIndex,
                    onMenuItemTap: () => onMenuItemTap(1),
                  ),
                  buildSizedBoxHeightFun(context, height: 20),
                  buildSidebarItem(
                    context,
                    icon: FontAwesomeIcons.personBooth,
                    title: ProjectConstants.staff,
                    index: 2,
                    selectedIndex: selectedIndex,
                    onMenuItemTap: () => onMenuItemTap(2),
                  ),
                  buildSizedBoxHeightFun(context, height: 40),
                  buildLogoutButton(context)
                ],
              ),
            ),
          ),
          buildSizedBoxWidthFun(context, width: 4),
          Expanded(child: screens[selectedIndex]),
        ],
      ),
    );
  }
}
