import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:suchigo_app/services/api_client.dart';

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
  static Future<Map<String, dynamic>> createPickup({
    required String fullName,
    required String email,
    required String contactNumber,
    required String street,
    required String city,
    required String zipCode,
    required String state,
    required String district,
    required String localBody,
    required String wardName,
    required String pickupDate,
    required String pickupTimeSlot,
    required String itemsDescription,
    required String wasteType,
    String? landmark,
  }) async {
    final body = <String, dynamic>{
      'full_name': fullName,
      'email': email,
      'contact_number': contactNumber,
      'street': street,
      'city': city,
      'zip_code': zipCode,
      'state': state,
      'district': district,
      'localbody': localBody,
      'ward_name': wardName,
      'pickup_date': pickupDate,
      'pickup_time_slot': pickupTimeSlot,
      'items_description': itemsDescription,
      'waste_type': wasteType,
      if (landmark != null && landmark.isNotEmpty) 'landmark': landmark,
    };

    try {
      print('[PickupApiService] POST pickups/ body: $body');

      final response = await ApiClient.instance.post(
        _path,
        data: body,
        options: Options(
          extra: {
            'skipAuthRedirect': true,
          },
        ),
      );

      print('[PickupApiService] SUCCESS ${response.statusCode}: ${response.data}');

      final data = response.data;
      if (data is Map<String, dynamic>) return data;
      return {'raw': data};
    } on DioException catch (e) {
      print('[PickupApiService] FAILED status=${e.response?.statusCode}');
      print('[PickupApiService] FAILED body=${e.response?.data}');
      throw _toFriendlyException(e);
    }
  }

  /// Fetches the list of pickups for the dashboard (GET /api/pickups/).
  static Future<List<Map<String, dynamic>>> fetchPickups() async {
    try {
      final response = await ApiClient.instance.get(
        _path,
        options: Options(extra: {'skipAuthRedirect': true}),
      );
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

  static PickupSubmissionException _toFriendlyException(DioException e) {
    final status = e.response?.statusCode;
    final data = e.response?.data;

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
          'Server rejected the request: $detail. This endpoint may now require login — please check with the backend.',
          fieldErrors: data is Map<String, dynamic> ? data : null,
        );
      }
      return PickupSubmissionException(
        'Server rejected the request (401). This endpoint may now require '
        'authentication — please check the backend configuration.',
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
