import 'package:app/helpers/appcolors.dart';
import 'package:app/helpers/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';
import '../../../controllers/signature_controller.dart';

class SignatureWidget extends StatelessWidget {
  const SignatureWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final SignatureController2 controller = Get.put(SignatureController2());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Signature(
            height: 300,
            width: double.maxFinite,
            controller: controller.signatureController,
            backgroundColor: AppColors.lightPrimaryColor,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomButton(
                width: 165,
                onTap: () {
                  controller.clearSignature();
                },
                buttonText: 'Clear Signature',
                isLoading: false),
            const SizedBox(width: 10),
            CustomButton(
              width: 165,
              onTap: () async {
                await controller.saveSignature();
                controller.uploadSignature();
                debugPrint('!!!!QQQ${controller.signaturePathUrl.value}');
              },
              buttonText: 'Save Signature',
              isLoading: false,
              usePrimaryColor: true,
            ),
          ],
        ),
      ],
    );
  }
}
