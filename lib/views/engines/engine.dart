import 'dart:io';
import 'dart:ui';

import 'package:app/controllers/category_controller.dart';
import 'package:app/controllers/engines_controller.dart';
import 'package:app/controllers/universal_controller.dart';
import 'package:app/helpers/appcolors.dart';
import 'package:app/helpers/custom_button.dart';
import 'package:app/helpers/custom_text.dart';
import 'package:app/helpers/reusable_container.dart';
import 'package:app/helpers/reusable_textfield.dart';
import 'package:app/helpers/tabbar.dart';
import 'package:app/helpers/toast.dart';
import 'package:app/helpers/validator.dart';

import 'package:app/views/task/widgets/heading_and_textfield.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../services/category_service.dart';

import 'category_dialog.dart';

class EnginesScreen extends StatelessWidget {
  final SideMenuController sideMenu;

  EnginesScreen({super.key, required this.sideMenu});

  final EnginesController controller = Get.put(EnginesController());
  final CategoriesController categoryController =
      Get.put(CategoriesController(repository: CategoriesRepository()));
  final UniversalController universalController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            sideMenu.changePage(0);
            Get.delete<EnginesController>();
            universalController.fetchUserAnalyticsData();
          },
          child: Obx(() {
            categoryController.fetchEngines(
                categoryController.selectedCategory.value, '');
            final categories =
                categoryController.categoriesResponse.value?.data ?? [];
            // Wait for categories to be loaded
            if (categoryController.isLoadingCategory.value) {
              return Center(
                  heightFactor: 3,
                  child: SpinKitCircle(
                    color: AppColors.primaryColor,
                    size: 60.0,
                  ));
            }

            // If categories are empty after loading, show an appropriate message
            if (categories.isEmpty) {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/view-task.png'),
                  const CustomTextWidget(
                    text: 'No Category Available',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ));
            }

            return DefaultTabController(
              length: categories.length,
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: context.height * 0.02,
                    horizontal: context.width * 0.05),
                decoration: const BoxDecoration(color: Colors.transparent),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          context.isLandscape ? context.width * 0.05 : 0.02),
                  child: Column(
                    children: [
                      ReUsableTextField(
                        controller: categoryController.searchController,
                        hintText: 'Search',
                        suffixIcon: const Icon(Icons.search_sharp),
                        onChanged: (value) {
                          categoryController.fetchEngines(
                              categoryController.selectedCategory.value, value);
                        },
                      ),
                      CustomButton(
                        usePrimaryColor: true,
                        isLoading: false,
                        buttonText: '+ Add Equipment',
                        fontSize: 14,
                        onTap: () {
                          controller.isQrCodeGenerated.value = false;
                          controller.engineImageUrl.value = '';
                          controller.engineName.clear();
                          controller.engineSubtitle.clear();
                          categoryController.selectedCategoryId.value = '';
                          categoryController.selectedCategoryName.value = '';
                          _openAddEngineDialog(
                              context: context,
                              controller: controller,
                              controller2: categoryController);
                        },
                      ),
                      CustomDynamicTabBar(
                        onTap: (index) {
                          // Set the selected category when a tab is selected
                          categoryController.selectedCategory.value =
                              categories[index].name!;
                          // Fetch the engines for the selected category
                          categoryController.fetchEngines(
                              categoryController.selectedCategory.value, '');
                        },
                        categories: categories,
                      ),
                      Expanded(
                        child: Obx(() {
                          final categoryData = categoryController
                                  .enginesResponse.value?.engines ??
                              [];
                          // Wait for engines data to be loaded
                          if (categoryController.isLoading.value) {
                            return Center(
                                heightFactor: 3,
                                child: SpinKitCircle(
                                  color: AppColors.primaryColor,
                                  size: 60.0,
                                ));
                          }

                          if (categoryData.isEmpty) {
                            return Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/images/view-task.png'),
                                const CustomTextWidget(
                                  text: 'No Data Found',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ));
                          }

                          // Display TabBarView with content corresponding to selected category
                          return TabBarView(
                            physics: const NeverScrollableScrollPhysics(),
                            children: categories.map((category) {
                              return RefreshIndicator(
                                onRefresh: () => 
                                categoryController.fetchEngines(categoryController.selectedCategory.value,''),
                                color: AppColors.primaryColor,
                                backgroundColor: AppColors.secondaryColor,
                                triggerMode: RefreshIndicatorTriggerMode.onEdge,
                                child: ListView.builder(
                                  itemCount: categoryData.length,
                                  itemBuilder: (context, index) {
                                    var engine = categoryData[index];
                                    return ReUsableContainer(
                                      child: ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        onTap: () {},
                                        leading: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black),
                                              shape: BoxShape.circle),
                                          child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            backgroundImage:
                                                NetworkImage(engine.url ?? ''),
                                          ),
                                        ),
                                        title: CustomTextWidget(
                                            text: engine.name ??
                                                'No Name Specified',
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w500),
                                        subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CustomTextWidget(
                                                  text: engine.subname ??
                                                      'No SubTitle Specified',
                                                  textColor:
                                                      AppColors.lightTextColor,
                                                  fontSize: 12.0),
                                              CustomTextWidget(
                                                  text:
                                                      'Type: ${engine.categoryName}',
                                                  fontSize: 10.0,
                                                  textColor: AppColors
                                                      .lightTextColor2),
                                            
                                            ]),
                                        trailing: engine.isDefault ?? true
                                            ? null
                                            : Wrap(
                                                spacing: 12.0,
                                                children: [
                                                  InkWell(
                                                      onTap: () {
                                                        _showEditPopup(
                                                            context: context,
                                                            controller:
                                                                controller,
                                                            controller2:
                                                                categoryController,
                                                            model: engine);
                                                      },
                                                      child: Icon(Icons.edit,
                                                          color: AppColors
                                                              .secondaryColor)),
                                                  InkWell(
                                                      onTap: () {
                                                        _showDeletePopup(
                                                            context: context,
                                                            controller:
                                                                controller,
                                                            model: engine);
                                                      },
                                                      child: const Icon(
                                                          Icons.delete,
                                                          color: Colors.red))
                                                ],
                                              ),
                                      ),
                                    );
                                  
                                  },
                                ),
                              );
                            }).toList(),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}


void _openAddEngineDialog({
  required BuildContext context,
  required EnginesController controller,
  required CategoriesController controller2,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (context, animation, secondaryAnimation) => Container(),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
          child: FadeTransition(
              opacity: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
              child: PopScope(
                  canPop: false,
                  onPopInvoked: (didPop) {
                    if (!didPop) {
                      controller.isQrCodeGenerated.value = false;
                      controller.engineImageUrl.value = '';
                      controller.engineName.clear();
                      controller.engineSubtitle.clear();
                      controller2.selectedCategoryId.value = '';
                      controller2.selectedCategoryName.value = '';
                      Get.back();
                    }
                  },
                  child: AlertDialog(
                      scrollable: true,
                      backgroundColor: Colors.transparent,
                      contentPadding: const EdgeInsets.all(5),
                      content: Container(
                          width: context.width,
                          height: context.height * 0.7,
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: context.height * 0.02),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color.fromRGBO(255, 220, 105, 0.4),
                                Color.fromRGBO(86, 127, 255, 0.4),
                              ],
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 5.0,
                                  spreadRadius: 5.0),
                              BoxShadow(
                                  color: Colors.white,
                                  offset: Offset(0.0, 0.0),
                                  blurRadius: 0.0,
                                  spreadRadius: 0.0)
                            ],
                          ),
                          child: PageView(
                              controller: controller.pageController,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                SingleChildScrollView(
                                    child: DialogFirstView(
                                        controller: controller,
                                        controller2: controller2,
                                        categoryName:  controller2.selectedCategory.value
                                        )),
                                SingleChildScrollView(
                                    child: DialogSecondView(
                                        controller: controller)),
                              ]))))));
    },
  );
}

class DialogFirstView extends StatelessWidget {
  final EnginesController controller;
  final CategoriesController controller2;
  final dynamic categoryName;
  const DialogFirstView({
    super.key,
    required this.controller,
    required  this.controller2,
    required  this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      InkWell(
        onTap: () => controller.pickImage(),
        child: Obx(
          () => CircleAvatar(
            radius: 45,
            backgroundColor: Colors.white,
            backgroundImage: controller.engineImageUrl.value == ''
                ? const AssetImage('assets/images/placeholder.png')
                    as ImageProvider
                : FileImage(File(controller.engineImageUrl.value)),
          ),
        ),
      ),
      const SizedBox(height: 12.0),
      Form(
          key: controller.engineFormKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            HeadingAndTextfield(
                title: 'Enter Equipment Name & Model',
                fontSize: 12.0,
                controller: controller.engineName,
                validator: (val) => AppValidator.validateEmptyText(
                    fieldName: 'Equipment Name & Model', value: val)),
            HeadingAndTextfield(
                title: 'Enter Subtitle',
                fontSize: 12.0,
                controller: controller.engineSubtitle,
                validator: (val) => AppValidator.validateEmptyText(
                    fieldName: 'Equipment Subtitle', value: val)),
            const CustomTextWidget(
                text: 'Select Type',
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
                maxLines: 2),
            CategoryDialog(),
           
          ])),
      Obx(
        () => CustomButton(
            isLoading: controller.isLoading.value,
            usePrimaryColor: controller.isQrCodeGenerated.value == true,
            buttonText: 'Save & Generate QR code',
            fontSize: 12.0,
            onTap: () {
              FormState? formState =
                  controller.engineFormKey.currentState as FormState?;
              if (formState != null && formState.validate()) {
                controller.addEngine();
                 
              }
          
             
            }),
      ),
      const Divider(color: Colors.black54),
      const Center(
          child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CustomTextWidget(
                  text: 'Generate QR Code by filling the above fields.',
                  maxLines: 2,
                  fontSize: 12.0,
                  textAlign: TextAlign.center,
                  ),
                  ),
                  ),
    ]);
  }
}

class DialogSecondView extends StatelessWidget {
  final EnginesController controller;

  const DialogSecondView({
    super.key,
    required this.controller,
  });
 Future<void> _downloadQrCode() async {
    // Request storage permission
    // PermissionStatus permissionStatus = await Permission.storage.request();

   
      try {
        // Create a QrPainter instance
        final qrPainter = QrPainter(
          data: controller.engineName.text.trim(),
          version: QrVersions.auto,
          errorCorrectionLevel: QrErrorCorrectLevel.L,
          gapless: false,
         
        );

        // Capture the QR code as an image
        final recorder = PictureRecorder();
        final canvas = Canvas(recorder, Rect.fromPoints(Offset(0, 0), Offset(200, 200)));
        qrPainter.paint(canvas, Size(200, 200));

        final picture = recorder.endRecording();
        final img = await picture.toImage(200, 200);

        // Convert the image to bytes
        final byteData = await img.toByteData(format: ImageByteFormat.png);
        final buffer = byteData!.buffer.asUint8List();

        // Get the directory to store the image
        final directory = await getExternalStorageDirectory();
        final filePath = '${directory!.path}/qr_code.png';
        final file = File(filePath);

        // Save the bytes to a file
        await file.writeAsBytes(buffer);

        // Save to gallery
        final result = await ImageGallerySaver.saveFile(filePath);
        if (result['isSuccess'] == true) {
          ToastMessage.showToastMessage(
            message: 'QR Code successfully saved in gallery',
            backgroundColor: Colors.green);
         Get.back();
        } else {
          ToastMessage.showToastMessage(
            message: 'Failed to Download QR code',
            backgroundColor: Colors.red);
 
        }
      } catch (e) {
         ToastMessage.showToastMessage(
            message: 'Failed to download QR code Image: $e',
            backgroundColor: Colors.red);
     
        print('${e}');
      }
    
  }
  // Function to print the QR code
  // Future<void> _printQrCode() async {
  //   final qrData = controller.engineName.text.trim();

  //   if (qrData.isEmpty) {
  //     Get.snackbar('Error', 'QR Code data is empty');
  //     return;
  //   }

  //   // Create a PDF document
  //   final pdf = pw.Document();

  //   // Add the QR code as an image to the PDF
  //   final qrPainter = QrPainter(
  //     data: qrData,
  //     version: QrVersions.auto,
  //     errorCorrectionLevel: QrErrorCorrectLevel.L,
  //     gapless: false,
   
  //   );

  //   final recorder = PictureRecorder();
  //   final canvas = Canvas(recorder, Rect.fromPoints(Offset(0, 0), Offset(200, 200)));
  //   qrPainter.paint(canvas, Size(200, 200));

  //   final picture = recorder.endRecording();
  //   final img = await picture.toImage(200, 200);

  //   // Convert the image to bytes
  //   final byteData = await img.toByteData(format: ImageByteFormat.png);
  //   final buffer = byteData!.buffer.asUint8List();

  //   // Add the QR code image to the PDF
  //   pdf.addPage(
  //     pw.Page(
  //       build: (pw.Context context) {
  //         return pw.Center(
  //           child: pw.Image(
  //             pw.MemoryImage(buffer),
  //             fit: pw.BoxFit.contain,
  //             width: 200.0,
  //             height: 200.0,
  //           ),
  //         );
  //       },
  //     ),
  //   );

  //   // Print the PDF
  //   await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  // }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomTextWidget(
              text: controller.engineName.text,
              maxLines: 2,
              fontSize: 14.0,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.black54)),
          child: QrImageView(
            data: controller.engineName.text.trim(),
            version: QrVersions.auto,
            size: 200.0,
          ),
        ),
       
        const Divider(color: Colors.black54),
         CustomButton(
          isLoading: false,
          usePrimaryColor: controller.isQrCodeGenerated.value == true,
          buttonText: 'Download QR Code',
          fontSize: 12.0,
          onTap: _downloadQrCode,
        ),
        //  CustomButton(
        //   isLoading: false,
        //   usePrimaryColor: controller.isQrCodeGenerated.value == true,
        //   buttonText: 'Print QR Code',
        //   fontSize: 12.0,
        //   onTap: _printQrCode,
        // ),
        
        CustomButton(
          isLoading: false,
          usePrimaryColor: controller.isQrCodeGenerated.value == false,
          textColor: Colors.white,
          buttonText: 'Close',
          fontSize: 12.0,

          onTap: () {
            controller.isQrCodeGenerated.value = false;
            controller.engineImageUrl.value = '';
            controller.engineName.clear();
            controller.engineSubtitle.clear();
            Get.back();
          },
        ),
      ],
    );
  }
}



void _showEditPopup(
    {required BuildContext context,
    required EnginesController controller,
    required CategoriesController controller2,
    required model}) {
  controller.engineName.text = model.name ?? '';
  controller.engineSubtitle.text = model.subname ?? '';
  controller2.selectedCategoryId.value = model.categoryId ?? '';
  controller2.selectedCategoryName.value = model.categoryName ?? '';
  final CategoriesController categoryController =
      Get.put(CategoriesController(repository: CategoriesRepository()));

  // controller.engineType.value = model.isGenerator! ? 'Generator' : 'Compressor';
  // RxString engineImageUrl = ''.obs;
  controller.updatedEngineImageUrl.value = model.url ?? '';
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (context, animation, secondaryAnimation) => Container(),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
          child: FadeTransition(
              opacity: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
              child: PopScope(
                canPop: false,
                onPopInvoked: (didPop) {
                  if (!didPop) {
                    controller.isQrCodeGenerated.value = false;
                    controller.engineImageUrl.value = '';
                    controller.engineName.clear();
                    controller.engineSubtitle.clear();
                    controller.engineType.value = 'Generator';
                    controller2.selectedCategoryId.value = '';
                    controller2.selectedCategoryName.value = '';
                    Get.back();
                  }
                },
                child: AlertDialog(
                    insetPadding: const EdgeInsets.all(20),
                    scrollable: true,
                    backgroundColor: Colors.transparent,
                    content: Container(
                      width: context.width * 0.9,
                      height: context.height * 0.7,
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: context.height * 0.02),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color.fromRGBO(255, 220, 105, 0.4),
                            Color.fromRGBO(86, 127, 255, 0.4),
                          ],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 5.0,
                              spreadRadius: 5.0),
                          BoxShadow(
                              color: Colors.white,
                              offset: Offset(0.0, 0.0),
                              blurRadius: 0.0,
                              spreadRadius: 0.0)
                        ],
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                   
                               InkWell(
                                // onTap: () => controller.updateImage(model),
                                onTap: () {
                                  controller.updateImage(model);
                                                         
                                },
                                child:  Obx(()=>
                                 CircleAvatar(
                                      radius: 45,
                                      backgroundColor: Colors.white,
                                      backgroundImage: controller.updatedEngineImageUrl.value ==''
                                      ? const AssetImage(
                                      'assets/images/placeholder.png')as ImageProvider
                                      : NetworkImage(controller.updatedEngineImageUrl.value),
                                    ),
                                ),
                                
                              ),
                            
                            const SizedBox(height: 12.0),
                            Form(
                              key: controller.engineFormKey,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // CustomTextWidget(
                                    //     text: 'ID: ${model.id}',
                                    //     fontSize: 11.0),
                                    HeadingAndTextfield(
                                        title: 'Enter Equipment Name & Model',
                                        fontSize: 12.0,
                                        controller: controller.engineName,
                                        validator: (val) =>
                                            AppValidator.validateEmptyText(
                                                fieldName:
                                                    'Equipment Name & Model',
                                                value: val)),
                                    HeadingAndTextfield(
                                        title: 'Enter Subtitle',
                                        fontSize: 12.0,
                                        controller: controller.engineSubtitle,
                                        validator: (val) =>
                                            AppValidator.validateEmptyText(
                                                fieldName: 'Equipment Subtitle',
                                                value: val)),
                                    const CustomTextWidget(
                                        text: 'Select Equipment Type',
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w600,
                                        maxLines: 2),
                                    CategoryDialog()
                                  ]),
                            ),
                            Obx(
                              () => CustomButton(
                                  isLoading: controller.isLoading.value,
                                  usePrimaryColor:
                                      controller.isQrCodeGenerated.value ==
                                          true,
                                  buttonText: 'Update',
                                  fontSize: 12.0,
                                  onTap: () {
                                    FormState? formState = controller
                                        .engineFormKey
                                        .currentState as FormState?;
                                    if (formState != null &&
                                        formState.validate()) {
                                      controller.updateEngine(
                                          id: model.id ?? '');
                                    }
                                    controller2.fetchEngines(
                                        model.categoryName, '');
                                  }),
                            ),
                          ]),
                    )),
              )));
    },
  );
}

void _showDeletePopup(
    {required BuildContext context,
    required EnginesController controller,
    required model}) {
  final CategoriesController categoryController =
      Get.put(CategoriesController(repository: CategoriesRepository()));
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (context, animation, secondaryAnimation) => Container(),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
          child: FadeTransition(
              opacity: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
              child: AlertDialog(
                  scrollable: true,
                  backgroundColor: Colors.transparent,
                  content: Container(
                    width: context.width,
                    // height: context.height * 0.3,
                    padding: EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: context.height * 0.02),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color.fromRGBO(255, 220, 105, 0.4),
                          Color.fromRGBO(86, 127, 255, 0.4),
                        ],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5.0,
                            spreadRadius: 5.0),
                        BoxShadow(
                            color: Colors.white,
                            offset: Offset(0.0, 0.0),
                            blurRadius: 0.0,
                            spreadRadius: 0.0)
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CustomTextWidget(
                            text:
                                'Are you sure to delete the Engine? This action cannot be undone.',
                            fontSize: 14.0,
                            maxLines: 3,
                            textAlign: TextAlign.center,
                            fontWeight: FontWeight.w400),
                        const SizedBox(height: 12.0),
                        Obx(
                          () => InkWell(
                              onTap: () {
                                controller.deleteEngine(engineModel: model);
                                categoryController.fetchEngines(
                                    model.categoryName, '');
                              },
                              child: ReUsableContainer(
                                verticalPadding: context.height * 0.01,
                                height: 50,
                                color: Colors.red,
                                child: Center(
                                    child: controller.isLoading.value
                                        ? const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: SpinKitRing(
                                              lineWidth: 2.0,
                                              color: Colors.white,
                                            ),
                                          )
                                        : const CustomTextWidget(
                                            text: 'Delete',
                                            fontSize: 12,
                                            textColor: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            textAlign: TextAlign.center,
                                          )),
                              )),
                        ),
                        CustomButton(
                          isLoading: false,
                          usePrimaryColor: false,
                          buttonText: 'Cancel',
                          fontSize: 12.0,
                          onTap: () {
                            Get.back();
                          },
                        )
                      ],
                    ),
                  ))));
    },
  );
}
