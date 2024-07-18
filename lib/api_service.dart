import 'package:dio/dio.dart';

import 'model/model.dart';

class ApiService{
Future<SerModel> getBranches()async{
  final dio = Dio();
  final response = await dio.get('https://gateway.texnomart.uz/api/web/v1/region/stores-list');
  return SerModel.fromJson(response.data);
}
}