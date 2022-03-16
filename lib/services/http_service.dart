import 'dart:developer';

import 'package:coincap/models/app_config.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

class HTTPService {
  final Dio _dio = Dio();

  AppConfig? _appConfig;
  String? _baseUrl;

  HTTPService() {
    _appConfig = GetIt.instance.get<AppConfig>();
    _baseUrl = _appConfig!.COIN_API_BASE_URL;

    log('_baseUrl: 🔗 $_baseUrl');
  }

  Future<Response?> get(String _path) async {
    try {
      String _url = "$_baseUrl$_path";
      Response _response = await _dio.get(_url);
      return _response;
    } catch (e) {
      log('🔥 HTTPService error: $e');
    }
  }
}
