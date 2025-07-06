import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';

BaseOptions options = BaseOptions(
  baseUrl: "https://securehealth-backend-1-production.up.railway.app",
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

