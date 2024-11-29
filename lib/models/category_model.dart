

class Category {
  String? id;
  String? name;
  String? value;
  String? createdAt;
  String? updatedAt;
  int? v;

  Category({
    this.id,
    this.name,
    this.value,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  // Factory method to create a Category from JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      value: json['value'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      v: json['__v'] as int?,
    );
  }

  // Method to convert Category object to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'value': value,
      'created_at': createdAt,
      'updated_at': updatedAt,
      '__v': v,
    };
  }
}

class CategoriesResponse {
  String? message;
  List<Category>? data;
  dynamic error;
  String? status;

  CategoriesResponse({
    this.message,
    this.data,
    this.error,
    this.status,
  });

  // Factory method to create CategoriesResponse from JSON
  factory CategoriesResponse.fromJson(Map<String, dynamic> json) {
    return CategoriesResponse(
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => Category.fromJson(item as Map<String, dynamic>))
          .toList(),
      error: json['error'],
      status: json['status'] as String?,
    );
  }

  // Method to convert CategoriesResponse object to JSON
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data?.map((e) => e.toJson()).toList(),
      'error': error,
      'status': status,
    };
  }
}
