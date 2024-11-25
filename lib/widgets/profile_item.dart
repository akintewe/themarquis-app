import 'package:flutter/material.dart';


class ProfileItem extends StatelessWidget {
  const ProfileItem({
    super.key,
    this.textColor,
    required this.icon,
    required this.title,
    required this.onTap
  });

  final Widget icon;
  final Color? textColor;
  final String title;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
          elevation: 8.0,
          color: const Color(0xff212329),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: icon,
                ),
                Text(
                    title,
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor ?? Colors.white
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }
}
