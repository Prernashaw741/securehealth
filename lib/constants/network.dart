import 'package:dio/dio.dart';

BaseOptions options = BaseOptions(
  baseUrl: "http://10.0.2.2:8000"
);

var dio = Dio(
  options
);