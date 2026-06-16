import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:suchigo_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:suchigo_app/features/bills/data/datasources/bills_remote_datasource.dart';
import 'package:suchigo_app/features/bills/data/repositories/bills_repository.dart';

part 'bills_providers.g.dart';

@Riverpod(keepAlive: true)
BillsRemoteDataSource billsRemoteDataSource(Ref ref) {
  return BillsRemoteDataSource(ref.watch(apiClientProvider));
}

@Riverpod(keepAlive: true)
BillsRepository billsRepository(Ref ref) {
  return BillsRepository(ref.watch(billsRemoteDataSourceProvider));
}
