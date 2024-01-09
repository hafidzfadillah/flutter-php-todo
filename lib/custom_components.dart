import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

const primaryColor = Color(0xFF62E1FB);
const primaryColorDark = Color(0xFF1AB2F5);
const accentColor = Color(0xFF74E2A7);
const blackColor = Color(0xFF444444);

const imgPlaceholder = 'assets/images/placeholder.png';

Future showModalSheet(context, height, child) async {
  final rsp = await showModalBottomSheet(
    enableDrag: true,
    isScrollControlled: true,
    showDragHandle: true,
    context: context,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(2.h), topRight: Radius.circular(2.h))),
    builder: (context) {
      return SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
              height: height, padding: EdgeInsets.all(2.h), child: child),
        ),
      );
    },
  );

  return rsp;
}

showConfirmationDialog(BuildContext context, String title, String msg) async {
  final result = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: MyText(
          title,
          weight: FontWeight.w600,
          size: 18,
        ),
        content: MyText(
          msg,
          maxLines: 4,
        ),
        actions: <Widget>[
          TextButton(
            child: MyText(
              'Cancel',
              color: Colors.grey,
            ),
            onPressed: () {
              // Close the dialog
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: accentColor, elevation: 0),
            child: MyText(
              'Yes',
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ],
      );
    },
  );

  return result != null && result;
}

class MyText extends StatelessWidget {
  const MyText(
    this.data, {
    super.key,
    this.size,
    this.weight,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.isItalic,
  });
  final String data;
  final double? size;
  final FontWeight? weight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? isItalic;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: GoogleFonts.poppins(
          fontSize: size ?? 14,
          fontWeight: weight ?? FontWeight.normal,
          color: color ?? blackColor,
          fontStyle: isItalic ?? false ? FontStyle.italic : FontStyle.normal),
      textAlign: textAlign,
      maxLines: maxLines ?? 1,
      overflow: overflow,
    );
  }
}

class FillButton extends StatelessWidget {
  const FillButton(
      {super.key,
      this.width,
      required this.onClick,
      required this.label,
      this.background});
  final double? width;
  final Function() onClick;
  final String label;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: ElevatedButton(
          onPressed: onClick,
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(2.h),
              backgroundColor: background ?? primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.h))),
          child: MyText(
            label,
            weight: FontWeight.w600,
            color: Colors.white,
            maxLines: 2,
          )),
    );
  }
}

class Topbar extends StatelessWidget {
  const Topbar(
      {super.key,
      required this.title,
      this.action,
      this.leading,
      this.footer,
      this.titleSize});
  final String title;
  final double? titleSize;
  final Widget? action;
  final Widget? leading;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          leading != null ? 1.h : 2.h,
          action != null || leading != null ? 6.h : 7.h,
          2.h,
          action != null || leading != null ? 1.h : 2.h),
      width: double.infinity,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: leading != null
                ? MainAxisAlignment.start
                : MainAxisAlignment.spaceBetween,
            children: [
              leading ?? Container(),
              SizedBox(
                width: leading != null ? 1.h : 0,
              ),
              Expanded(
                child: MyText(
                  title,
                  size: titleSize ?? 24,
                  color: blackColor,
                  weight: FontWeight.w600,
                ),
              ),
              action ?? Container()
            ],
          ),
          footer != null
              ? Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: footer,
                )
              : Container()
        ],
      ),
    );
  }
}

class MyCard extends StatelessWidget {
  const MyCard({super.key, required this.child, this.padding});
  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.h)),
        shadowColor: accentColor.withOpacity(0.15),
        elevation: 2.h,
        child: Padding(padding: padding ?? EdgeInsets.all(2.h), child: child));
  }
}
