import 'dart:convert';

import 'package:app/services/api_endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../helpers/storage_helper.dart';

class ImagePickRepository {
 
  // Function to upload vehicle images
  Future<List<String>> uploadImages(List<String> imagePaths) async {
    try {
      var uri =   Uri.parse('${ApiEndPoints.baseUrl}${ApiEndPoints.addCustomTaskFilesUrl}');
      var request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer ${storage.read('token')}';
      // Add the images to the multipart request
      
      for (var imagePath in imagePaths) {
        var extension = imagePath.split('.').last.toLowerCase();
         MediaType mediaType;
      switch (extension) {
        case 'jpeg':
        case 'jpg':
          mediaType = MediaType('image', 'jpeg');
          break;
        case 'png':
          mediaType = MediaType('image', 'png');
          break;
        case 'gif':
          mediaType = MediaType('image', 'gif');
          break;
        default:
          mediaType = MediaType('image', 'jpeg'); 
      } 
        var file = await http.MultipartFile.fromPath(
          'files', 
          imagePath,
       
          contentType: mediaType, 
        );
        request.files.add(file);
      }

      // Send the request
      var response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final Map<String, dynamic> responseJson = jsonDecode(responseBody);

        if (responseJson['status'] == 'success') {
          // Return the list of image URLs from the response
          return List<String>.from(responseJson['data']);
        } else {
          throw Exception('Failed to upload images: ${responseJson['message']}');
        }
      } else {
        throw Exception('Failed to upload images. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      rethrow; // Rethrow the exception so it can be handled by the controller
    }
  }}

