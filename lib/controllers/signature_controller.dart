import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';
import '../../helpers/toast.dart';
import '../services/upload_image.dart';

class SignatureController2 extends GetxController {
  late SignatureController signatureController;
  var savedSignature = Rxn<Uint8List>();
  var signaturePath = ''.obs;
  var signaturePathUrl = ''.obs;


  @override
  void onInit() {
    super.onInit();
    signatureController = SignatureController(penColor: Colors.black, penStrokeWidth: 3);
  }

  Future<void> saveSignature() async {
    // Capture the signature as a ui.Image
    final ui.Image? signatureImage = await signatureController.toImage();

    if (signatureImage != null) {
      // Convert the ui.Image to Uint8List (for example, to save as PNG)
      // final ByteData? byteData = await signatureImage.toByteData(format: ui.ImageByteFormat.png);
      // final Uint8List uint8List = byteData!.buffer.asUint8List();

      // // Save the signature as Uint8List to the reactive variable
      // savedSignature.value = uint8List;
      // print("Signature saved: ${uint8List.length} bytes");
      //  ToastMessage.showToastMessage(
      //   message: ' Signature Has Been SuccessFully Saved',
      //   backgroundColor: Colors.green);
      final ByteData? byteData = await signatureImage.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List uint8List = byteData!.buffer.asUint8List();

      savedSignature.value = uint8List;
      debugPrint("Signature saved as PNG: ${uint8List.length} bytes");

      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/signature_${DateTime.now().millisecondsSinceEpoch}.png';
     
      final file = File(filePath);
      await file.writeAsBytes(uint8List);
      signaturePath.value = filePath;
        ToastMessage.showToastMessage(
        message: ' Signature Has Been SuccessFully Saved',
        backgroundColor: Colors.green);
       uploadSignature();
      debugPrint("Signature saved to file: $filePath");

    } else {
      ToastMessage.showToastMessage(
            message: 'Signature field is empty.',
            backgroundColor: Colors.red);
      debugPrint("Signature is empty");
    }
  }

  void clearSignature() {
    signatureController.clear();
    savedSignature.value = null;  
    print("Signature cleared");
  }
 final ImagePickRepository _imagePickRepository = ImagePickRepository();
  var isImageLoading = false.obs;
  Future<void> uploadSignature() async {
  try {
    isImageLoading.value = true; 
  List<String> licenseFrontList = [signaturePath.value];

  List<String> uploadedUrlsFront = await _imagePickRepository.uploadImages(licenseFrontList);
  signaturePathUrl.value = uploadedUrlsFront.isNotEmpty ? uploadedUrlsFront[0] : '';
  } catch (e) {
    debugPrint("Error uploading image: $e");
  } finally {
    isImageLoading.value = false; 
  }
}
}
