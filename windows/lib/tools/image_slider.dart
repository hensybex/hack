import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hack/tools/palette.dart';
import 'package:provider/provider.dart';

class ImageSliderWidget extends StatefulWidget {
  final List<String> photoUrls;

  ImageSliderWidget({required this.photoUrls});

  @override
  _ImageSliderWidgetState createState() => _ImageSliderWidgetState();
}

class _ImageSliderWidgetState extends State<ImageSliderWidget> {
  int currentIndex = 0;

  Widget _displayImage(String path) {
    if (path.startsWith('assets/')) {
      return Image.asset(
        path,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    } else {
      String extension = path.split('.').last.toLowerCase();
      if (extension == 'svg') {
        return SvgPicture.file(
          File(path),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        );
      } else {
        return Image.file(
          File(path),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          currentIndex = (currentIndex + 1) % widget.photoUrls.length;
        });
      },
      onDoubleTap: () {
        setState(() {
          currentIndex = (currentIndex - 1 + widget.photoUrls.length) %
              widget.photoUrls.length;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 390,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            _displayImage(widget.photoUrls[currentIndex]),
            Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.photoUrls.length, (index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 1),
                    width: 14,
                    height: 7,
                    decoration: BoxDecoration(
                      shape: index == currentIndex
                          ? BoxShape.rectangle
                          : BoxShape.circle,
                      borderRadius: index == currentIndex
                          ? BorderRadius.circular(7)
                          : null,
                      color: index == currentIndex
                          ? context.watch<Palette>().blueGradient2
                          : Color(0xFFFFFFFF),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
