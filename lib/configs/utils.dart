import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:image_cropper/image_cropper.dart';
import 'package:team_quest/configs/color/color.dart';
import 'package:team_quest/configs/extensions.dart';

class Utils {
  // we will use this function to shift focus from one text field to another text field
  // we are using to avoid duplications of code
  static void fieldFocusChange(
      BuildContext context, FocusNode current, FocusNode nextFocus) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Future showPicker(
      {required BuildContext context, required Function onGetImage}) {
    return showModalBottomSheet(
      backgroundColor: Colors.white.withOpacity(0),
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0),
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                              imgFromCamera(context)
                                  .then((value) => onGetImage(value));
                            },
                            child: Container(
                              height: 48,
                              // width: 0,
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text("Take photo",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400)),
                              ),
                            ),
                          ),
                          const Divider(
                            color: Colors.grey,
                            height: 1,
                            thickness: 1,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                              imgFromGallery(context)
                                  .then((value) => onGetImage(value));
                            },
                            child: Container(
                              height: 48,
                              // width: 60,
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text("Gallery Photo",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      print("cancel");
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 50,
                      // width: 60,
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text("Cancel",
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 20,
                                fontWeight: FontWeight.w400)),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<dynamic> imgFromCamera(BuildContext context) async {
    File? newImage;
    XFile? image;
    final picker = ImagePicker();

    // Permission is granted, proceed to pick image
    image = (await picker.pickImage(source: ImageSource.camera))!;
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Image cropper',
          toolbarColor: AppColors.blackColor,
          toolbarWidgetColor: AppColors.whiteColor,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
          hideBottomControls: true,
        ),
        IOSUiSettings(
          title: 'Image cropper',
          rotateButtonsHidden: true,
        ),
      ],
    );

    final bytes = await croppedFile!.readAsBytes();
    final kb = bytes.length / 1024;
    final mb = kb / 1024;

    if (kDebugMode) {
      print('original image size:$mb');
    }

    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = '${dir.absolute.path}/temp.jpg';

    // converting original image to compress it
    final result = await FlutterImageCompress.compressAndGetFile(
      croppedFile.path,
      targetPath,
      minHeight: 1080, //you can play with this to reduce siz
      minWidth: 1080,
      quality: 50, // keep this high to get the original quality of image
    );

    final data = await result!.readAsBytes();
    final newKb = data.length / 1024;
    final newMb = newKb / 1024;

    if (kDebugMode) {
      print('compress image size:$newMb');
    }

    newImage = File(result.path);
    return newImage;
  }

  Future<dynamic> imgFromGallery(BuildContext context) async {
    File? newImage;
    XFile? image;
    final picker = ImagePicker();

    // Permission is granted, proceed to pick image
    image = (await picker.pickImage(source: ImageSource.gallery))!;
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Image cropper',
          toolbarColor: AppColors.blackColor,
          toolbarWidgetColor: AppColors.whiteColor,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
          hideBottomControls: true,
        ),
        IOSUiSettings(
          title: 'Image cropper',
          rotateButtonsHidden: true,
        ),
      ],
    );

    final bytes = await croppedFile!.readAsBytes();
    final kb = bytes.length / 1024;
    final mb = kb / 1024;

    if (kDebugMode) {
      print('original image size:$mb');
    }

    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = '${dir.absolute.path}/temp.jpg';

    // Compress the image
    final result = await FlutterImageCompress.compressAndGetFile(
      croppedFile.path,
      targetPath,
      minHeight: 1080,
      minWidth: 1080,
      quality: 50,
    );

    final data = await result!.readAsBytes();
    final newKb = data.length / 1024;
    final newMb = newKb / 1024;

    if (kDebugMode) {
      print('compress image size:$newMb');
    }

    newImage = File(result.path);
    return newImage;
  }

  static void showLoadingIndicator(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      useRootNavigator: false,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.symmetric(
              horizontal: context.mediaQueryWidth / 2 - 35),
          child: const Dialog(
            insetPadding: EdgeInsets.zero,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: SizedBox(
              height: 70,
              width: 80,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator.adaptive(
                    backgroundColor: AppColors.whiteColor,
                    strokeWidth: 1.4,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
