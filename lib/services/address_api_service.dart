// File: services/address_api_service.dart
//
// Talks directly to https://suchigoapis.pythonanywhere.com/api/addresses/
// using the shared ApiClient (Dio), matching the exact backend payload keys:
//   street, city, state, district, zip_code, ward, local_body,
//   number_of_bags, is_default
//
// This endpoint requires NO authentication — every request is marked
// `noAuth: true` so ApiClient never attaches an Authorization header here.
// `skipAuthRedirect: true` is kept as a safety net: if the backend ever
// does return a 401 for some other reason, the caller (AddressScreen)
// gets to show an inline error instead of being force-navigated to /login.

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:suchigo_app/services/api_client.dart';

class AddressSubmissionException implements Exception {
  final String message;
  final Map<String, dynamic>? fieldErrors;
  AddressSubmissionException(this.message, {this.fieldErrors});

  @override
  String toString() => message;
}

class AddressApiService {
  static const String _path = 'addresses/';

  /// Creates an address on the backend.
  /// Returns the decoded JSON response map (includes the backend-assigned `id`).
  static Future<Map<String, dynamic>> createAddress({
    required String street,
    required String city,
    required String state,
    required String district,
    required String zipCode,
    required String ward,
    required String localBody,
    required int numberOfBags,
    bool isDefault = true,
  }) async {
    final body = <String, dynamic>{
      'street': street,
      'city': city,
      'state': state,
      'district': district,
      'zip_code': zipCode,
      'ward': ward,
      'local_body': localBody,
      'number_of_bags': numberOfBags,
      'is_default': isDefault,
    };

    try {
      if (kDebugMode) {
        debugPrint('[AddressApiService] POST addresses/ body: $body');
      }

      final response = await ApiClient.instance.post(
        _path,
        data: body,
        options: Options(
          extra: {
            // addresses/ is a public endpoint — never attach a token.
            'noAuth': true,
            // Safety net: if the backend still returns a 401 for some
            // other reason, let this screen show an inline error instead
            // of being force-navigated to /login.
            'skipAuthRedirect': true,
          },
        ),
      );

      if (kDebugMode) {
        debugPrint('[AddressApiService] SUCCESS ${response.statusCode}: ${response.data}');
      }

      final data = response.data;
      if (data is Map<String, dynamic>) return data;
      return {'raw': data};
    } on DioException catch (e) {
      if (kDebugMode) {
        debugPrint('[AddressApiService] FAILED status=${e.response?.statusCode}');
        debugPrint('[AddressApiService] FAILED body=${e.response?.data}');
      }
      throw _toFriendlyException(e);
    }
  }

  /// Fetches saved addresses (GET /api/addresses/).
  static Future<List<Map<String, dynamic>>> fetchAddresses() async {
    try {
      final response = await ApiClient.instance.get(
        _path,
        options: Options(extra: {'noAuth': true, 'skipAuthRedirect': true}),
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

  static AddressSubmissionException _toFriendlyException(DioException e) {
    final status = e.response?.statusCode;
    final data = e.response?.data;

    if (status == 400 && data is Map<String, dynamic>) {
      final firstField = data.keys.isNotEmpty ? data.keys.first : null;
      final firstError = firstField != null && data[firstField] is List
          ? (data[firstField] as List).join(' ')
          : 'Please check the highlighted fields.';
      return AddressSubmissionException(
        '$firstField: $firstError',
        fieldErrors: data,
      );
    }

    if (status == 401) {
      // With noAuth:true this should not normally happen. If it does, the
      // backend itself is requiring auth on a path we expected to be public.
      return AddressSubmissionException(
        'Server rejected the request (401). This endpoint may now require '
        'authentication — please check the backend configuration.',
      );
    }

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return AddressSubmissionException(
        'The request timed out. Check your connection and try again.',
      );
    }

    if (e.type == DioExceptionType.connectionError) {
      return AddressSubmissionException(
        'Could not reach the server. Check your internet connection.',
      );
    }

    return AddressSubmissionException(
      'Something went wrong (status ${status ?? 'unknown'}). Please try again.',
    );
  }
}
