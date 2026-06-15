import 'package:suchigo_app/core/errors/app_error.dart';
import 'package:suchigo_app/core/errors/result.dart';
import 'package:suchigo_app/core/storage/local_db.dart';
import 'package:suchigo_app/core/storage/local_db_tables.dart';
import 'package:suchigo_app/features/profile/data/models/profile_model.dart';

class ProfileLocalDataSource {
  final LocalDb _localDb;

  ProfileLocalDataSource({required LocalDb localDb}) : _localDb = localDb;

  Future<Result<ProfileModel>> getCachedProfile() async {
    final result = await _localDb.query(LocalDbTables.users, limit: 1);
    
    if (result is Success<List<Map<String, dynamic>>>) {
      if (result.data.isNotEmpty) {
        return Success(ProfileModel.fromLocalDbMap(result.data.first));
      }
      return Failure(DbReadError(cause: 'No cached profile found'));
    }
    
    return Failure((result as Failure).error);
  }

  Future<Result<void>> cacheProfile(ProfileModel profile) async {
    // Clear old profile first (assuming single user device for now)
    await _localDb.delete(LocalDbTables.users, where: '1=1', whereArgs: []);
    
    final result = await _localDb.insert(LocalDbTables.users, profile.toLocalDbMap());
    
    if (result is Success<int>) {
      return const Success(null);
    }
    
    return Failure((result as Failure).error);
  }
}
