import 'dart:developer';

import 'package:dio/dio.dart';

import 'api_constant.dart';
import 'secure_storage.dart';

class DioHelper {
  final Dio _dio = Dio();

  DioHelper() {
    _dio.options.baseUrl = ApiConstants.baseUrl;
  }
  Future<Response> get(String endpoint) async {
    try {
      final token = await SecureStorage.getToken();
      final response = await _dio.get(
        endpoint,
        options: Options(headers: {'token': token}),
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        log(
          'API Error - Status: ${e.response!.statusCode}, Data: ${e.response!.data}',
        );
        return e.response!;
      } else {
        log('Network error occurred: $e');
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      log('Error occurred while fetching data: $e');
      throw Exception('Failed to load data: $e');
    }
  }

  Future<Response> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final token = await SecureStorage.getToken();
      final response = await _dio.post(
        endpoint,
        data: data,
        options: Options(headers: {'token': token}),
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        log(
          'API Error - Status: ${e.response!.statusCode}, Data: ${e.response!.data}',
        );
        return e.response!;
      } else {
        log('Network error occurred: $e');
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      log('Unexpected error occurred: $e');
      throw Exception('Failed to post data: $e');
    }
  }

  Future<Response> put(String endpoint, Map<String, dynamic> data) async {
    try {
      final token = await SecureStorage.getToken();
      final response = await _dio.put(
        endpoint,
        data: data,
        options: Options(headers: {'token': token}),
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        log(
          'API Error - Status: ${e.response!.statusCode}, Data: ${e.response!.data}',
        );
        return e.response!;
      } else {
        log('Network error occurred: $e');
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      log('Unexpected error occurred: $e');
      throw Exception('Failed to update data: $e');
    }
  }
}
