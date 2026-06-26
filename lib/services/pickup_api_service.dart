// File: services/pickup_api_service.dart
//
// Talks directly to https://suchigoapis.pythonanywhere.com/api/pickups/
// using the shared ApiClient (Dio) with exact backend payload key requirements.

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:suchigo_app/services/api_client.dart';
import 'package:suchigo_app/services/secure_storage_service.dart';

class PickupSubmissionException implements Exception {
  final String message;
  final Map<String, dynamic>? fieldErrors;
  PickupSubmissionException(this.message, {this.fieldErrors});

  @override
  String toString() => message;
}

class PickupApiService {
  static const String _path = 'pickups/';

  /// Creates a pickup request on the backend.
  /// Returns the decoded JSON response map containing created model parameters.
  static Future<Map<String, dynamic>> createPickup({
    required String name,
    required String email,
    required String contactNumber,
    required String pickupAddress,
    required String scheduledDate,
    required String itemsDescription,
    String? landmark,
  }) async {
    final body = _toJson(
      name: name,
      email: email,
      contactNumber: contactNumber,
      pickupAddress: pickupAddress,
      scheduledDate: scheduledDate,
      itemsDescription: itemsDescription,
      landmark: landmark,
    );

    try {
      if (kDebugMode) {
        final tokenAtSendTime = await SecureStorageService.getToken();
        debugPrint('[PickupApiService] token present at send time: '
            '${tokenAtSendTime != null && tokenAtSendTime.isNotEmpty} '
            '(length=${tokenAtSendTime?.length ?? 0})');
        debugPrint('[PickupApiService] POST pickups/ body: $body');
      }

      final response = await ApiClient.instance.post(
        _path,
        data: body,
        // Prevents interceptors from logging users out globally due to isolated 400/401 custom handling
        options: Options(extra: {'skipAuthRedirect': true}),
      );

      if (kDebugMode) {
        debugPrint('[PickupApiService] SUCCESS ${response.statusCode}: ${response.data}');
      }

      final data = response.data;
      if (data is Map<String, dynamic>) return data;
      return {'raw': data};
    } on DioException catch (e) {
      if (kDebugMode) {
        debugPrint('[PickupApiService] FAILED status=${e.response?.statusCode}');
        debugPrint('[PickupApiService] FAILED body=${e.response?.data}');
        debugPrint('[PickupApiService] FAILED request headers=${e.requestOptions.headers}');
      }
      throw _toFriendlyException(e);
    }
  }

  /// Fetches the list of pickups for the authenticated user's dashboard (GET /api/pickups/).
  static Future<List<Map<String, dynamic>>> fetchPickups() async {
    try {
      final response = await ApiClient.instance.get(_path);
      final data = response.data;

      if (data is List) {
        return data.cast<Map<String, dynamic>>();
      }
      if (data is Map && data['results'] is List) {
        return (data['results'] as List).cast<Map<String, dynamic>>();
      }
      return [];
    } on DioException catch (e) {
      throw _toFriendlyException(e);
    }
  }

  // ── Production JSON Field-Name Payload Mapping ─────────────────────
  static Map<String, dynamic> _toJson({
    required String name,
    required String email,
    required String contactNumber,
    required String pickupAddress,
    required String scheduledDate,
    required String itemsDescription,
    String? landmark,
  }) {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'contact_number': contactNumber,
      'pickup_address': pickupAddress,
      'scheduled_date': scheduledDate,
      'items_description': itemsDescription,
      if (landmark != null && landmark.isNotEmpty) 'landmark': landmark,
    };
  }

  static PickupSubmissionException _toFriendlyException(DioException e) {
    final status = e.response?.statusCode;
    final data = e.response?.data;

    // Django REST Framework Form Field Validation Parser
    if (status == 400 && data is Map<String, dynamic>) {
      final firstField = data.keys.isNotEmpty ? data.keys.first : null;
      final firstError = firstField != null && data[firstField] is List
          ? (data[firstField] as List).join(' ')
          : 'Please check the highlighted fields.';
      return PickupSubmissionException(
        '$firstField: $firstError',
        fieldErrors: data,
      );
    }

    if (status == 401) {
      if (data is Map && data.isNotEmpty) {
        final detail = data['detail'] ?? data.values.first;
        return PickupSubmissionException(
          'Server rejected the request: $detail',
          fieldErrors: data is Map<String, dynamic> ? data : null,
        );
      }
      return PickupSubmissionException(
        'Authentication rejected (401). Please check if you are logged in properly '
        'or if the headers are passing a valid Authorization Bearer token.',
      );
    }

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return PickupSubmissionException(
        'The request timed out. Check your connection and try again.',
      );
    }

    if (e.type == DioExceptionType.connectionError) {
      return PickupSubmissionException(
        'Could not reach the server. Check your internet connection.',
      );
    }

    return PickupSubmissionException(
      'Something went wrong (status ${status ?? 'unknown'}). Please try again.',
    );
  }
}