import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
