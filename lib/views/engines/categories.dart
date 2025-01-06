import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/category_controller.dart';
import '../../services/category_service.dart';


class CategoriesView extends StatelessWidget {


  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    final CategoriesController controller = Get.put(CategoriesController(repository: CategoriesRepository()));
    return   Scaffold(
      appBar: AppBar(title: const Text('Select Category')),
      body: Obx(() {
        if (controller.categoriesResponse.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final categories = controller.categoriesResponse.value?.data ?? [];
        
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButton<String>(
                hint: const Text("Select Category"),
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
              const SizedBox(height: 20),
              Text('Selected Category Name: ${controller.selectedCategoryName.value}'),
              Text('Selected Category ID: ${controller.selectedCategoryId.value}'),
            ],
          ),
        );
      }),
    );
  }
}


