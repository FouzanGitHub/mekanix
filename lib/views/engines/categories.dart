import 'package:app/helpers/appcolors.dart';
import 'package:app/helpers/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../../controllers/category_controller.dart';
import '../../helpers/reusable_textfield.dart';
import '../../helpers/tabbar.dart';
import '../../services/category_service.dart';


class CategoriesView extends StatelessWidget {
  final CategoriesController controller = Get.put(CategoriesController(repository: CategoriesRepository()));

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar: AppBar(title: Text('Select Category')),
      body: Obx(() {
        if (controller.categoriesResponse.value == null) {
          return Center(child: CircularProgressIndicator());
        }

        final categories = controller.categoriesResponse.value?.data ?? [];
        
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButton<String>(
                hint: Text("Select Category"),
                value: controller.selectedCategoryName.value.isEmpty ? null : controller.selectedCategoryName.value,
                isExpanded: true,
                items: categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category.name,
                    child: Text('${category.name} - ${category.id}'),
                  );
                }).toList(),
                onChanged: (newValue) {
                  // Find the category based on the selected name
                  final selectedCategory = categories.firstWhere((category) => category.name == newValue);
                  
                  // Save the selected name and id to different variables
                  controller.selectedCategoryName.value = selectedCategory.name ?? '';
                  controller.selectedCategoryId.value = selectedCategory.id ?? '';
                  
                  // Optionally, you can also save the selected category data in the controller
                  controller.selectedCategoryName.value = controller.selectedCategoryName.value;
                  controller.selectedCategoryId.value = controller.selectedCategoryId.value;
                },
              ),
              SizedBox(height: 20),
              Text('Selected Category Name: ${controller.selectedCategoryName.value}'),
              Text('Selected Category ID: ${controller.selectedCategoryId.value}'),
            ],
          ),
        );
      }),
    );
  }
}




//TAb bar Working Fine    
//     Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.only(top: 16.0),
//         child: Obx(() {
//           final categories = controller.categoriesResponse.value?.data ?? [];
//           // Wait for categories to be loaded
//           if (controller.isLoadingCategory.value ) {
//             return Center(
//                     heightFactor: 3,
//                     child: SpinKitCircle(
//                       color: AppColors.primaryColor,
//                       size: 60.0,
//                     )
//                     );
//           }

//           // If categories are empty after loading, show an appropriate message
//           if (categories.isEmpty) {
//             return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
                
//                 Image.asset('assets/images/view-task.png'),
//                 const CustomTextWidget(text: 'No Category Available',
//                 fontSize: 18,
//                 fontWeight: FontWeight.w500,
//                 ),
//               ],
//             ));
//           }

//           return DefaultTabController(
//             length: categories.length,
//             child: Container(
//               padding: EdgeInsets.symmetric(vertical: context.height * 0.02, horizontal: context.width * 0.05),
//               decoration: const BoxDecoration(color: Colors.transparent),
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: context.isLandscape ? context.width * 0.05 : 0.02),
//                 child: Column(
//                   children: [
//                      ReUsableTextField(
//                           controller: controller.searchController,
//                           hintText: 'Search Engine',
//                           suffixIcon: const Icon(Icons.search_sharp),
//                           onChanged: (value) {
//                             controller.fetchEngines(controller.selectedCategory.value, value);
//                           },
//                         ),
//                     CustomDynamicTabBar(
//                       onTap: (index) {
//                         // Set the selected category when a tab is selected
//                         controller.selectedCategory.value = categories[index].name!;
//                         // Fetch the engines for the selected category
//                         controller.fetchEngines(controller.selectedCategory.value, '');
//                       },
//                       categories: categories,
//                     ),
//                       //  CustomButton(
//                       //     usePrimaryColor: true,
//                       //     isLoading: false,
//                       //     buttonText: '+ Add Engine',
//                       //     fontSize: 14,
//                       //     onTap: () => _openAddEngineDialog(
//                       //       context: context,
//                       //       controller: controller,
//                       //     ),
//                       //   ),
//                     Expanded(
//                       child: Obx(() {
//                         final categoryData = controller.enginesResponse.value?.engines ?? [];
//                         // Wait for engines data to be loaded
//                         if (controller.isLoading.value) {
//                          return Center(
//                     heightFactor: 3,
//                     child: SpinKitCircle(
//                       color: AppColors.primaryColor,
//                       size: 60.0,
//                     )
//                     );
//                         }

//                         if (categoryData.isEmpty) {
//                           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
                
//                 Image.asset('assets/images/view-task.png'),
//                 const CustomTextWidget(text: 'No Data Found',
//                 fontSize: 18,
//                 fontWeight: FontWeight.w500,
//                 ),
//               ],
//             ));
//                         }

//                         // Display TabBarView with content corresponding to selected category
//                         return TabBarView(
//                           physics: const NeverScrollableScrollPhysics(),
//                           children: categories.map((category) {
//                             return ListView.builder(
//                               itemCount: categoryData.length,
//                               itemBuilder: (context, index) {
//                                 var engine = categoryData[index];
//                                 return 
//                                 ListTile(
//                                   title: Text(engine.name ?? 'Unknown Engine'),
//                                   subtitle: Text(engine.categoryName ?? 'Unknown Category'),
//                                   // leading: Image.network(engine.url ?? ''),  // Optional, add image here if needed
//                                 );
//                               },
//                             );
//                           }).toList(),
//                         );
//                       }),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }



//Tab Bar
//     Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.only(top: 16.0),
//         child: Obx(() {
//           final categories = controller.categoriesResponse.value?.data ?? [];
//           // Wait for categories to be loaded
//           if (controller.isLoading.value) {
//             return Center(child: CircularProgressIndicator());
//           }

//           // If categories are empty after loading, show an appropriate message
//           if (categories.isEmpty) {
//             return Center(child: Text('No categories available'));
//           }

//           return DefaultTabController(
//             length: categories.length,
//             child: Container(
//               padding: EdgeInsets.symmetric(
//                   vertical: context.height * 0.02,
//                   horizontal: context.width * 0.05),
//               decoration: const BoxDecoration(color: Colors.transparent),
//               child: Padding(
//                 padding: EdgeInsets.symmetric(
//                     horizontal: context.isLandscape ? context.width * 0.05 : 0.02),
//                 child: Column(
//                   children: [
//                     ElevatedButton(onPressed: (){
//                       print('qqqqqqqqq${controller.enginesResponse.value?.engines[0].name}');
//                       print('QAAR ${controller.selectedCategory.value}');
//                       controller.fetchEngines(controller.selectedCategory.value, '');}, child: Text('sds')
//                       ),
//                      CustomDynamicTabBar(
//                       onTap: (index) {
//                         controller.selectedCategory.value = categories[index].name!;
//                       },
//                       categories: categories,
//                     ),
//    Expanded(
//                       child: Obx(() {
                        
//                       final categoryData = controller.enginesResponse.value?.engines ?? [];
//                         // Wait for engines data to be loaded
//                         if (controller.isLoading.value) {
//                           return Center(child: CircularProgressIndicator());
//                         }

//                         if (categoryData.isEmpty ?? true) {
//                           return Center(child: Text('No engines available'));
//                         }

//                         return TabBarView(
//                           physics: const NeverScrollableScrollPhysics(),
//                           children: categories.map((category) {
//                             // Display engines for each category in the TabBarView
//                             // var engines = controller.enginesResponse.value?.engines ?? [];
//                             return ListView.builder(
//                               itemCount: categoryData.length,
//                               itemBuilder: (context, index) {
//                                 var engine = categoryData[index];
//                                 return ListTile(
//                                   title: Text(engine.name ?? 'Unknown Engine'),
//                                   subtitle: Text(engine.categoryName ?? 'Unknown Category'),
//                                   // leading: Image.network(engine.url ?? ''),
//                                 );
//                               },
//                             );
//                           }).toList(),
//                         );
//                       }),
//                     ),
//                     // Expanded(
//                     //   child: TabBarView(
//                     //     physics: const NeverScrollableScrollPhysics(),
//                     //     children: categories.map((category) {
//                     //       return Center(child: Text('Details for ${category.name}'));
//                     //     }).toList(),
//                     //   ),
//                     // ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }



//FOR DROPDOWN DONE CORRECT
//     Scaffold(
//       appBar: AppBar(title: Text('Select Category')),
//       body: Obx(() {
//         if (controller.categoriesResponse.value == null) {
//           return Center(child: CircularProgressIndicator());
//         }

//         final categories = controller.categoriesResponse.value?.data ?? [];
        
//         return Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               DropdownButton<String>(
//                 hint: Text("Select Category"),
//                 value: controller.selectedCategoryName.value.isEmpty ? null : controller.selectedCategoryName.value,
//                 isExpanded: true,
//                 items: categories.map((category) {
//                   return DropdownMenuItem<String>(
//                     value: category.name,
//                     child: Text('${category.name} - ${category.id}'),
//                   );
//                 }).toList(),
//                 onChanged: (newValue) {
//                   // Find the category based on the selected name
//                   final selectedCategory = categories.firstWhere((category) => category.name == newValue);
                  
//                   // Save the selected name and id to different variables
//                   controller.selectedCategoryName.value = selectedCategory.name ?? '';
//                   controller.selectedCategoryId.value = selectedCategory.id ?? '';
                  
//                   // Optionally, you can also save the selected category data in the controller
//                   controller.selectedCategoryName.value = controller.selectedCategoryName.value;
//                   controller.selectedCategoryId.value = controller.selectedCategoryId.value;
//                 },
//               ),
//               SizedBox(height: 20),
//               Text('Selected Category Name: ${controller.selectedCategoryName.value}'),
//               Text('Selected Category ID: ${controller.selectedCategoryId.value}'),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }







//     Scaffold(
//       appBar: AppBar(title: Text('Categories')),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return Center(child: CircularProgressIndicator());
//         }

//         if (controller.errorMessage.value.isNotEmpty) {
//           return Center(child: Text(controller.errorMessage.value));
//         }

//         final categories = controller.categoriesResponse.value?.data;
//         if (categories == null || categories.isEmpty) {
//           return Center(child: Text('No categories found.'));
//         }

//         return ListView.builder(
//           itemCount: categories.length,
//           itemBuilder: (context, index) {
//             final category = categories[index];
//             return ListTile(
//               title: Text(category.name ?? 'No name'),
//               subtitle: Text(category.value ?? 'No value'),
//               trailing: Text(category.createdAt ?? 'No date'),
//             );
//           },
//         );
//       }),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           controller.fetchCategories();
//         },
//         child: Icon(Icons.refresh),
//       ),
//     );
//   }
// }
