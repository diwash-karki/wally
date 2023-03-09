import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

int? currentSelected;
Widget categoryHolder(BuildContext context, Function updateStateCallback) {
  return SizedBox(
      height: 16.5.h,
      width: 93.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              categoryCard('assets/category/landscape.jpg', 0,
                  () => updateStateCallback(0)),
              categoryCard('assets/category/sunset.jpg', 1,
                  () => updateStateCallback(1)),
              categoryCard(
                  'assets/category/car.jpg', 2, () => updateStateCallback(2)),
              categoryCard('assets/category/anime.jpeg', 3,
                  () => updateStateCallback(3)),
              categoryCard('assets/category/flower.jpeg', 4,
                  () => updateStateCallback(4)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              categoryCard('assets/category/marvel.png', 5,
                  () => updateStateCallback(5)),
              categoryCard('assets/category/technology.jpeg', 6,
                  () => updateStateCallback(6)),
              categoryCard('assets/category/building.jpeg', 7,
                  () => updateStateCallback(7)),
              categoryCard('assets/category/animal.jpeg', 8,
                  () => updateStateCallback(8)),
              categoryCard(
                  'assets/category/dark.jpeg', 9, () => updateStateCallback(9)),
            ],
          )
        ],
      ));
}

Widget categoryCard(String url, int index, Function updateStateCallback) {
  return GestureDetector(
    onTap: () {
      if (currentSelected == index) {
        currentSelected = null;
      } else {
        currentSelected = index;
      }
      updateStateCallback();
    },
    child: Container(
      height: 7.5.h,
      width: 7.5.h,
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: (currentSelected == index)
            ? const Color.fromARGB(223, 0, 0, 0)
            : Colors.black.withOpacity(0.2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Image(
          image: AssetImage(url),
          fit: BoxFit.fill,
        ),
      ),
    ),
  );
}
