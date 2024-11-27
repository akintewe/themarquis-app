import 'package:flutter/material.dart';
import 'package:marquis_v2/widgets/ui_widgets.dart';

class LockedGameWidget extends StatelessWidget {
  const LockedGameWidget({
    super.key,
    required this.title,
    required this.subTitle,
    required this.image
  });

  final String title, subTitle, image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              image,
              fit: BoxFit.fitWidth,
              width: 78,
            ),
          ),
          horizontalSpace(16.0),
           Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                subTitle,
                style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xff868686)
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
