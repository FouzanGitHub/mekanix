// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:signature/signature.dart';
// import 'package:image/image.dart' as img;
// import 'dart:ui' as ui;

// class SignatureController2 extends GetxController {
//   // Declare signature controller for managing the signature area
//   late SignatureController _controller;

//   // Reactive variable to hold the signature image
//   var signatureImage = Rxn<img.Image>();

//   SignatureController2() {
//     _controller = SignatureController();
//   }

//   // Getter for the controller
//   SignatureController get controller => _controller;

//   @override
//   void onInit() {
//     super.onInit();
//     // Initialize the signature controller here
//   }

//   // Clear the signature pad
//   void clear() {
//     _controller.clear();
//   }

//   // Save the signature as a PNG and update the signatureImage variable
//   Future<void> saveSignature() async {
//     try {
//       // Get the signature as a ui.Image object
//       final uiImage = await _controller.toImage();

//       // Convert the ui.Image to byte data
//       final byteData = await uiImage?.toByteData(format: ui.ImageByteFormat.png);

//       if (byteData == null) {
//         throw Exception("Failed to convert signature to byte data");
//       }

//       // Get the byte buffer
//       final buffer = byteData.buffer.asUint8List();

//       // Decode the image from the byte buffer
//       final image = img.decodeImage(Uint8List.fromList(buffer));

//       if (image != null) {
//         signatureImage.value = image; // Store the image in the reactive variable
//         print('Signature saved!');
//       } else {
//         print('Failed to decode image.');
//       }
//     } catch (e) {
//       print('Error saving signature: $e');
//     }
//   }
// }
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

  // Reactive variable to store the signature as Uint8List
  var savedSignature = Rxn<Uint8List>();
  
  var signaturePath = ''.obs;
  var signaturePathUrl = ''.obs;


  // Initialize SignatureController
  @override
  void onInit() {
    super.onInit();
    signatureController = SignatureController(penColor: Colors.black, penStrokeWidth: 3);
  }

  // Function to save the signature
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

      // Save the signature to the savedSignature reactive variable
      savedSignature.value = uint8List;
      print("Signature saved as PNG: ${uint8List.length} bytes");

      // Get the application's document directory to save the file
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/signature_${DateTime.now().millisecondsSinceEpoch}.png';
     
      // Write the byte data to a PNG file
      final file = File(filePath);
      await file.writeAsBytes(uint8List);
      signaturePath.value = filePath;
        ToastMessage.showToastMessage(
        message: ' Signature Has Been SuccessFully Saved',
        backgroundColor: Colors.green);
       uploadSignature();
      debugPrint("Signature saved to file: $filePath");

      // Optionally, save it as a file or send it to the server
    } else {
      ToastMessage.showToastMessage(
            message: 'Signature field is empty.',
            backgroundColor: Colors.red);
      print("Signature is empty");
    }
  }

  // Function to clear the signature
  void clearSignature() {
    signatureController.clear();
    savedSignature.value = null;  // Clear the saved signature as well
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
    isImageLoading.value = false; // Set loading state to false after uploading
  }
}











  // late SignatureController signatureController;

  // // Initialize SignatureController
  // @override
  // void onInit() {
  //   super.onInit();
  //   signatureController = SignatureController(penColor: Colors.black, penStrokeWidth: 5);
  // }

  // // Function to save the signature
  // Future<void> saveSignature() async {
  //   // Capture the signature as a ui.Image
  //   final ui.Image? signatureImage = await signatureController.toImage();

  //   if (signatureImage != null) {
  //     // Convert the ui.Image to Uint8List (for example, to save as PNG)
  //     final ByteData? byteData = await signatureImage.toByteData(format: ui.ImageByteFormat.png);
  //     final Uint8List uint8List = byteData!.buffer.asUint8List();
      
  //     // Here you can save the uint8List or process it further
  //     print("Signature saved: ${uint8List.length} bytes");

  //     // Optionally, save it as a file or send it to the server
  //   } else {
  //     print("Signature is empty");
  //   }
  // }

  // // Function to clear the signature
  // void clearSignature() {
  //   signatureController.clear();
  //   print("Signature cleared");
  // }
}
