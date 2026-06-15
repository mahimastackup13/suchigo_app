import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:suchigo_app/core/storage/database_health_service.dart';
import 'package:suchigo_app/core/storage/local_db.dart';
import 'package:suchigo_app/core/storage/local_db_tables.dart';

void main() {
  late LocalDb db;
  late DatabaseHealthService healthService;

  setUpAll(() {
    sqfliteFfiInit();
  });

  setUp(() async {
    final dbPath = await databaseFactoryFfi.getDatabasesPath();
    await databaseFactoryFfi.deleteDatabase('$dbPath/suchigo.db');

    db = LocalDb(dbFactory: databaseFactoryFfi);
    healthService = DatabaseHealthService(db: db);
  });

  tearDown(() async {
    await db.close();
  });

  group('DatabaseHealthService', () {
    test('returns failed if database is not open', () async {
      final report = await healthService.verifyHealth();
      expect(report.status, DatabaseHealthStatus.failed);
      expect(report.message, contains('not open'));
    });

    test('returns healthy for a fully initialized database', () async {
      await db.open(); // This runs migrations and creates all tables/indexes

      final report = await healthService.verifyHealth();
      expect(report.status, DatabaseHealthStatus.healthy);
      expect(report.missingTables, isEmpty);
      expect(report.missingIndexes, isEmpty);
    });

    test('returns failed if tables are missing', () async {
      await db.open();
      
      // Sabotage the DB by dropping a table
      await db.internalDb!.execute('DROP TABLE ${LocalDbTables.syncQueue}');

      final report = await healthService.verifyHealth();
      expect(report.status, DatabaseHealthStatus.failed);
      expect(report.missingTables, contains(LocalDbTables.syncQueue));
    });

    test('returns degraded if indexes are missing', () async {
      await db.open();
      
      // Sabotage the DB by dropping an index
      await db.internalDb!.execute('DROP INDEX idx_users_lookup');

      final report = await healthService.verifyHealth();
      expect(report.status, DatabaseHealthStatus.degraded);
      expect(report.missingIndexes, contains('idx_users_lookup'));
    });

    test('returns degraded if schema version is wrong', () async {
      await db.open();
      
      // Sabotage the DB by changing version manually
      await db.internalDb!.setVersion(999);

      final report = await healthService.verifyHealth();
      expect(report.status, DatabaseHealthStatus.degraded);
      expect(report.message, contains('Schema version mismatch'));
    });
  });
}
