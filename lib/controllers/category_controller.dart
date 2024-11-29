import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/category_data_model.dart';
import '../models/category_model.dart';
import '../services/category_service.dart';


class CategoriesController extends GetxController {
  var categoriesResponse = Rx<CategoriesResponse?>(null);

  var isLoading = false.obs;
  var isLoadingCategory = false.obs;
  var errorMessage = ''.obs;
 var categories = <Category>[].obs;
  final CategoriesRepository repository;
  var selectedCategory = ''.obs;
 final searchController = TextEditingController();
  CategoriesController({required this.repository});

  // Fetch categories from API
  Future<void> fetchCategories() async {
    isLoadingCategory.value = true;
    errorMessage.value = '';

    try {
      categoriesResponse.value = await repository.fetchAllCategories();
       print('Fetched Categories: ${categoriesResponse.value?.data}');
    } catch (e) {
      errorMessage.value = 'Failed to load categories: $e';
    } finally {
      isLoadingCategory.value = false;
    }
  }

  
  // Variables to store selected category data
  var selectedCategoryName = ''.obs;
  var selectedCategoryId = ''.obs;
void onInit(){
  super.onInit();
  fetchCategories();
    selectedCategory.value = 'Engine';
    fetchEngines(selectedCategory.value, '');
  // print('assadadasddasd${categoriesResponse.value}');
}




  var enginesResponse = Rx<EnginesResponse?>(null);

  var searchTerm = ''.obs;


  // Fetch engines based on category and search term
  Future<void> fetchEngines(String category, String search) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      enginesResponse.value = await repository.fetchCategoryData(category, search);
      print('Engines fetched: ${enginesResponse.value?.engines?.length}');
      print('Engines fetched: ${enginesResponse.value?.engines[0].categoryId}');
    } catch (e) {
      errorMessage.value = 'Failed to load engines: $e';
      print('Engines fetched: $e');
    } finally {
      isLoading.value = false;
    }
  }

  
}
