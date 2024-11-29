class Engine {
  String? id;
  String? user;
  String? name;
  String? subname;
  bool? isGenerator;
  bool? isCompressor;
  bool? isDefault;
  String? categoryId;
  String? categoryName;
  String? url;
  String? createdAt;
  String? updatedAt;

  Engine({
    this.id,
    this.user,
    this.name,
    this.subname,
    this.isGenerator,
    this.isCompressor,
    this.isDefault,
    this.categoryId,
    this.categoryName,
    this.url,
    this.createdAt,
    this.updatedAt,
  });

  factory Engine.fromJson(Map<String, dynamic> json) {
    return Engine(
      id: json['_id'],
      user: json['user'],
      name: json['name'],
      subname: json['subname'],
      isGenerator: json['is_generator'],
      isCompressor: json['is_compressor'],
      isDefault: json['is_default'],
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      url: json['url'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
class EnginesResponse {
  List<Engine> engines;
  int totalCount;

  EnginesResponse({
    required this.engines,
    required this.totalCount,
  });
factory EnginesResponse.fromJson(Map<String, dynamic> json) {
    // Now, we're accessing the first element of 'data', which is a Map containing 'engines' and 'totalCount'
    var enginesData = json['data'][0];  // Access the first item in the data list

    // Extract the engines list
    List<Engine> engines = (enginesData['engines'] as List)
        .map((i) => Engine.fromJson(i))
        .toList();

    // Extract the totalCount from the enginesData
    int totalCount = enginesData['totalCount'] ?? 0;

    return EnginesResponse(
      engines: engines,
      totalCount: totalCount,
    );
  }}

// class EnginesResponse {
//   List<Engine> engines;
//   int totalCount;

//   EnginesResponse({
//     required this.engines,
//     required this.totalCount,
//   });

//   factory EnginesResponse.fromJson(Map<String, dynamic> json) {
//     var list = json['data'] as List;
//     List<Engine> engines = list.map((i) => Engine.fromJson(i)).toList();

//     return EnginesResponse(
//       engines: engines,
//       totalCount: json['totalCount'] ?? 0,
//     );
//   }
// }
