import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';

BaseOptions options = BaseOptions(
  baseUrl: "https://securehealth.openscholar.in",
  // baseUrl: "http://localhost:8001",
  validateStatus: (status) {
    return true;
  },
  // Enable sending cookies for web platform
  extra: {
    'withCredentials': true,
  },
);
final cookieJar = CookieJar();
var dio = Dio(
  options
);

