import 'package:suchigo_app/core/constants/api_constants.dart';
import 'package:suchigo_app/core/errors/app_error.dart';
import 'package:suchigo_app/core/errors/result.dart';
import 'package:suchigo_app/core/network/api_client.dart';
import 'package:suchigo_app/features/bills/data/models/bill_model.dart';

class BillsRemoteDataSource {
  final ApiClient _apiClient;

  BillsRemoteDataSource(this._apiClient);

  Future<Result<List<BillModel>>> fetchBills() async {
    final result = await _apiClient.getList(
      ApiConstants.authUri(ApiConstants.billsPath),
      requiresAuth: true,
      retry: true,
    );

    return result.map((list) {
      try {
        return list.map(BillModel.fromJson).toList();
      } catch (e) {
        throw ParseError(rawBody: 'Failed to parse Bills: $e');
      }
    });
  }

  Future<Result<BillModel>> createBill(CreateBillRequest request) async {
    final result = await _apiClient.post(
      ApiConstants.authUri(ApiConstants.billsPath),
      body: request.toJson(),
      requiresAuth: true,
    );

    return result.map((data) {
      try {
        return BillModel.fromJson(data);
      } catch (e) {
        throw ParseError(rawBody: 'Failed to parse created Bill: $e');
      }
    });
  }
}
