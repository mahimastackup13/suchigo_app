import 'package:suchigo_app/core/errors/result.dart';
import 'package:suchigo_app/features/home/data/datasources/home_remote_datasource.dart';
import 'package:suchigo_app/features/home/data/models/home_model.dart';

class HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;

  HomeRepository(this._remoteDataSource);

  Future<Result<HomeModel>> getHomeData() async {
    return _remoteDataSource.fetchHome();
  }
}
