import 'package:awesome_icons/awesome_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jk_event_management/controller/sa_login_controller.dart';
import 'package:jk_event_management/screens/sa_department_screen.dart';
import 'package:jk_event_management/screens/sa_position_screen.dart';
import 'package:jk_event_management/screens/sa_staff_screen.dart';
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
  int selectedIndex = 2;
  String initials = "--";

  @override
  void initState() {
    super.initState();
    _loadCustomerData();
    saLoginController.saAdminName.listen((name) {
      setState(() {
        initials = name.isNotEmpty ? name.substring(0, 2).toUpperCase() : "--";
      });
    });
  }

  Future<void> _loadCustomerData() async {
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

  String formattedDate = DateFormat("dd MMMM yyyy").format(DateTime.now());

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
                  )
                ],
              ),
            ),
          ),
          buildSizedBoxWidthFun(context, width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 75,
                  width: MediaQuery.of(context).size.width * 0.76,
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
                        // Search bar
                        Expanded(
                          child: Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: const Color(
                                  0xFFD3E6E5), // Light greenish background
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color:
                                      const Color(0xFF17817D)), // Border color
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    style: const TextStyle(
                                        color: Color(0xFF17817D)),
                                    decoration: const InputDecoration(
                                      hintText: "Search",
                                      hintStyle: TextStyle(
                                          color: Color(
                                              0xFF17817D)), // Hint text color
                                      border: InputBorder.none,
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a search term'; // Example validation
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  child: const Icon(Icons.search,
                                      color: Color(0xFF17817D)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Date display
                        Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: ProjectColors.primaryGreen.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  color: Color(0xFF17817D)),
                              const SizedBox(width: 8),
                              Text(
                                formattedDate, // Dynamic date
                                style: const TextStyle(
                                  color: Color(0xFF17817D),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Notification icon
                        const Icon(Icons.notifications,
                            color: Color(0xFF17817D)),
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
                            buildCircleAvatarFunTwo(
                                radius: 18,
                                text: initials,
                                backgroundColor: ProjectColors.primaryGreen,
                                color: Colors.white,
                                fontweight: FontWeight.bold),
                            const SizedBox(width: 8),
                            buildTextFun(
                              context,
                              title: "${saLoginController.saAdminName.value}",
                              fontsize: 18,
                              fontweight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(child: screens[selectedIndex]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
