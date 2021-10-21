import 'package:flutter/services.dart';
import 'package:opencv/core/core.dart';
import 'package:opencv/opencv.dart';
import 'dart:io';
import 'package:flutter/material.dart';

class FilterUtils {
  static Future<Image?> applyLines(File file) async {
    try {
      var bytes = await file.readAsBytes();
      var result = await ImgProc.scharr(bytes, ImgProc.cvSCHARR, 0, 1);

      return Image.memory(result);
    } on PlatformException {
      print('Failed to get platform version.');
      return null;
    }
  }

  static Future<Image?> applyThreshold(File file) async {
    try {
      var bytes = await file.readAsBytes();
      var result =
          await ImgProc.threshold(bytes, 90, 255, ImgProc.threshBinary);

      return Image.memory(result);
    } on PlatformException {
      print('Failed to get platform version.');
      return null;
    }
  }

  static Future<Image?> applyFilter2D(File file) async {
    try {
      var bytes = await file.readAsBytes();
      var result = await ImgProc.filter2D(bytes, -1, [2, 2]);

      return Image.memory(result);
    } on PlatformException {
      print('Failed to get platform version.');
      return null;
    }
  }

  static Future<Image?> applyTwilight(File file) async {
    try {
      var bytes = await file.readAsBytes();
      var result =
          await ImgProc.applyColorMap(bytes, ImgProc.colorMapTwilightShifted);
      return Image.memory(result);
    } on PlatformException {
      print('Failed to get platform version.');
      return null;
    }
  }

  static Future<Image?> applyHot(File file) async {
    try {
      var bytes = await file.readAsBytes();
      var result = await ImgProc.applyColorMap(bytes, ImgProc.colorMapHot);
      return Image.memory(result);
    } on PlatformException {
      print('Failed to get platform version.');
      return null;
    }
  }

  static Future<Image?> applyOcean(File file) async {
    try {
      var bytes = await file.readAsBytes();
      var result = await ImgProc.applyColorMap(bytes, ImgProc.colorMapOcean);
      return Image.memory(result);
    } on PlatformException {
      print('Failed to get platform version.');
      return null;
    }
  }
}

class FilterData {
  String name;
  Image? thumbnail;
  Function(File) filter;

  FilterData({required this.name, required this.filter, this.thumbnail});
}
