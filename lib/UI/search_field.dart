import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

Widget searchField(TextEditingController textController) {
  return Sizer(builder: (context, orientation, deviceType) {
    return SizedBox(
      width: 90.w,
      child: TextField(
        controller: textController,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(5),
          hintText: 'SEARCH IMAGE',
          hintStyle: TextStyle(color: Colors.grey[400]),
          border: const OutlineInputBorder(),
        ),
        textAlign: TextAlign.center,
      ),
    );
  });
}
