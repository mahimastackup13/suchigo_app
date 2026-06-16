import 'package:suchigo_app/core/errors/result.dart';
import 'package:suchigo_app/features/bills/data/datasources/bills_remote_datasource.dart';
import 'package:suchigo_app/features/bills/data/models/bill_model.dart';

class BillsRepository {
  final BillsRemoteDataSource _remoteDataSource;

  BillsRepository(this._remoteDataSource);

  Future<Result<List<BillModel>>> getBills() {
    return _remoteDataSource.fetchBills();
  }

  Future<Result<BillModel>> createBill(CreateBillRequest request) {
    return _remoteDataSource.createBill(request);
  }
}
