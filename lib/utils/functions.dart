import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Project_colors.dart';

buildImageFunction(BuildContext context, String image) {
  return Image.asset(image);
}

buildCircleAvatarFun(
  BuildContext context, {
  required double radius,
  required imagePath,
  String? text,
  BoxFit fit = BoxFit.cover,
  Color? color,
  double? fontsize,
  FontWeight? fontweight,
  MaterialColor? backgroundColor,
}) {
  return CircleAvatar(
      radius: radius,
      child: ClipOval(
        child: Image.asset(
          imagePath,
          fit: fit,
        ),
      ));
}

buildSizedBoxHeightFun(BuildContext context, {required double height}) {
  return SizedBox(
    height: height,
  );
}

buildSizedBoxWidthFun(BuildContext context, {required double width}) {
  return SizedBox(
    width: width,
  );
}

buildTextFormFieldFun(
  BuildContext context, {
  String? hint,
  TextEditingController? controller,
  Color? color,
  IconData? icon,
  required bool isPassword,
  TextInputType? keyboardType,
  List<TextInputFormatter>? inputFormatters,
  int maxLines = 1,
  bool? border,
  double? height,
  TextStyle? hintStyle,
}) {
  bool obscureText = isPassword;

  return StatefulBuilder(
    builder: (context, setState) {
      return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey),
            borderRadius: border == true
                ? BorderRadius.circular(2.0)
                : BorderRadius.circular(10.0)),
        //height: maxLines == 1 ? 50 : height,
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: hintStyle,
            border: InputBorder.none,
            prefixIcon: Icon(
              icon,
              color: color,
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                  )
                : null,
          ),
          maxLines: maxLines,
        ),
      );
    },
  );
}

buildContainerButtonFun(BuildContext context, String title,
    {Color? color,
    Color? borderColor, // Added borderColor for external color
    Function()? onPressed,
    bool isSmallSize = false,
    bool showIcon = true,
    bool isBordered = false}) {
  return InkWell(
      onTap: onPressed,
      child: Container(
          height: isSmallSize ? 40 : 44,
          width: isSmallSize ? 165 : 298,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: isBordered
                ? Colors.transparent
                : (color ?? Colors.pink), // Default color is pink
            border: isBordered
                ? Border.all(
                    color: borderColor ?? Colors.black,
                    width: 2) // Border color
                : null, // No border if isBordered is false
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showIcon) ...[
                  // Conditionally render the icon
                  Icon(Icons.add,
                      color: isBordered
                          ? (borderColor ?? Colors.black)
                          : Colors.white, // Icon color based on border
                      size: 16),
                  SizedBox(width: 8), // Space between icon and text
                ],
                buildTextFun(
                  context,
                  title: title,
                  fontsize: 12,
                  fontweight: FontWeight.w800,
                  color: isBordered
                      ? (borderColor ?? Colors.black)
                      : Colors.white, // Text color based on border
                ),
              ],
            ),
          )));
}

buildTextFun(BuildContext context,
    {required String title,
    required double fontsize,
    required FontWeight fontweight,
    required Color color}) {
  return Text(
    title,
    style: TextStyle(fontSize: fontsize, fontWeight: fontweight, color: color),
  );
}

Widget buildImageAssetsFun(
  BuildContext context, {
  required double width,
  required double height,
  required String imagePath,
  required bool circleAvatar,
}) {
  return circleAvatar
      ? CircleAvatar(
          radius: width / 2,
          backgroundImage: AssetImage(imagePath),
        )
      : Image.asset(
          imagePath,
          width: width,
          height: height,
        );
}

Widget buildSidebarItem(
  BuildContext context, {
  required IconData icon,
  required String title,
  required int index,
  required int selectedIndex,
  required VoidCallback onMenuItemTap,
}) {
  bool isSelected = selectedIndex == index;
  return Container(
    decoration: isSelected
        ? BoxDecoration(
            color: ProjectColors.primaryGreen,
            borderRadius: BorderRadius.circular(8),
          )
        : null, // No decoration if not selected
    child: ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Colors.white : ProjectColors.green51ADAA,
      ),
      title: buildTextFun(
        context,
        title: title,
        fontsize: 14,
        fontweight: FontWeight.bold,
        color:
            isSelected ? ProjectColors.whiteColor : ProjectColors.green51ADAA,
      ),
      onTap: onMenuItemTap,
    ),
  );
}

Widget buildTextFormFieldFunTwo(
  BuildContext context, {
  required String hint,
  TextEditingController? controller,
  bool isSmallSize = true,
  required double fontSize,
  bool dropdown = false, // Add the dropdown boolean parameter
  List<String>? dropdownItems, // Add the dropdown items parameter
  String? selectedValue, // Add selected value parameter
  Function(String?)? onChanged, // Add onChanged callback for dropdown
}) {
  if (dropdown) {
    return Container(
      height: isSmallSize ? 40 : 70,
      width: isSmallSize ? 243 : 505,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: ProjectColors.greyColorA6A6A6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: DropdownButton<String>(
          value: selectedValue,
          hint: Text(
            hint,
            style: TextStyle(
                fontSize: fontSize), // Set the font size for the dropdown hint
          ),
          onChanged: onChanged,
          isExpanded: true,
          underline: SizedBox(), // This removes the underline
          items: dropdownItems?.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                    fontSize:
                        fontSize), // Set the font size for each dropdown item
              ),
            );
          }).toList(),
        ),
      ),
    );
  } else {
    return Container(
      height: isSmallSize ? 40 : 70,
      width: isSmallSize ? 243 : 505,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: ProjectColors.greyColorA6A6A6),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none, // Removes the bottom border line
          hintStyle: TextStyle(fontSize: fontSize), // Set the font size here
          contentPadding:
              EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        ),
      ),
    );
  }
}

buildCircleAvatarFunTwo({
  required double radius,
  String? imagePath,
  String? text,
  BoxFit fit = BoxFit.cover,
  Color? color,
  double? fontsize,
  FontWeight? fontweight,
  Color? backgroundColor,
}) {
  if (imagePath != null)
    return CircleAvatar(
      radius: radius,
      child: ClipOval(
        child: Image.asset(
          imagePath!,
          fit: fit,
        ),
      ),
    );
  else if (text != null)
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      child: Text(
        text,
        style:
            TextStyle(color: color, fontSize: fontsize, fontWeight: fontweight),
      ),
    );
}
