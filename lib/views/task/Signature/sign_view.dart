// import 'dart:typed_data';
// import 'package:app/views/task/sign_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import 'package:signature/signature.dart';

// class SignatureScreen extends StatelessWidget {
//   final SignatureController2 signatureController = Get.put(SignatureController2());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Signature Pad'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             // Display the saved signature image if available
//             Obx(() {
//               if (signatureController.signatureImage.value != null) {
//                 return Image.memory(
//                     Uint8List.fromList(signatureController.signatureImage.value!.getBytes()));
//               }
//               return Signature(
//                 controller: signatureController.controller, // Use the controller from the signatureController
//                 height: 300.0,
//                 width: 300.0,
//                 backgroundColor: Colors.white,
//               );
//             }),
//             SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     signatureController.clear();
//                   },
//                   child: Text('Clear'),
//                 ),
//                 SizedBox(width: 20),
//                 ElevatedButton(
//                   onPressed: () async {
//                     await signatureController.saveSignature();
//                   },
//                   child: Text('Save'),
//                 ),
              
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:app/helpers/appcolors.dart';
import 'package:app/helpers/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';

import '../../../controllers/signature_controller.dart';


class SignatureWidget extends StatelessWidget {
  // Get the controller instance using GetX


  const SignatureWidget({super.key});

  @override
  Widget build(BuildContext context) {
     final SignatureController2 controller = Get.put(SignatureController2());
    return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Signature Widget
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Signature(
                height: 300,
                width: double.maxFinite,
                controller: controller.signatureController,
                backgroundColor:AppColors.lightPrimaryColor,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
               
                width: 165,
                onTap: (){ controller.clearSignature();},
                buttonText: 'Clear Signature',  isLoading: false),
               
                const SizedBox(width: 10),
                   CustomButton(
                  width: 165,
                onTap: () async {  await controller.saveSignature();
                controller.uploadSignature();
                 debugPrint('!!!!QQQ${controller.signaturePathUrl.value}');},
                buttonText: 'Save Signature',  isLoading: false,
                usePrimaryColor: true,
                ),

               
              ],

            ),
         
            //   SizedBox(height: 20),
            // // Display the saved signature image below the drawing area
            // Obx(() {
            //   if (controller.savedSignature.value != null) {
            //     return Image.memory(
            //       controller.savedSignature.value!,
            //       height: 200,  // Adjust the height as needed
            //       width: double.infinity,
            //       fit: BoxFit.contain,
            //     );
            //   } else {
            //     return Text("No signature saved.");
            //   }
            // }),
          ],
        );
  }

}
