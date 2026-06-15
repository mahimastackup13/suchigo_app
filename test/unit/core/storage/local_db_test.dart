import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:suchigo_app/core/errors/app_error.dart';
import 'package:suchigo_app/core/errors/result.dart';
import 'package:suchigo_app/core/storage/local_db.dart';
import 'package:suchigo_app/core/storage/local_db_tables.dart';

void main() {
  late LocalDb db;

  setUpAll(() {
    // Initialize FFI for local unit testing (runs on desktop/Linux without emulator)
    sqfliteFfiInit();
  });

  setUp(() async {
    // Delete physical database file to ensure a fresh state per test
    final dbPath = await databaseFactoryFfi.getDatabasesPath();
    await databaseFactoryFfi.deleteDatabase('$dbPath/suchigo.db');

    db = LocalDb(dbFactory: databaseFactoryFfi);
    
    // We mock the path generation by just using an in-memory path constant.
    // However, LocalDb uses _dbFactory.getDatabasesPath(). 
    // FFI factory handles getDatabasesPath by returning a temp dir.
    // To ensure a truly fresh DB, we can just let it create a new file 
    // or we can test CRUD after opening.
    await db.open();
    
    // For pure in-memory without file artifacts in tests, we'll actually
    // inject a custom factory if needed, but databaseFactoryFfi works fine.
    // Let's clear the tables just to be sure.
    await db.internalDb?.delete(LocalDbTables.users);
  });

  tearDown(() async {
    await db.close();
  });

  group('LocalDb - CRUD', () {
    test('insert and query return Success with data', () async {
      final userValues = {
        'firebase_uid': 'uid123',
        'name': 'Test User',
        'email': 'test@example.com',
        'phone': '+1234567890',
        'ward_id': 1,
        'created_at': DateTime.now().millisecondsSinceEpoch,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      };

      // Insert
      final insertResult = await db.insert(LocalDbTables.users, userValues);
      expect(insertResult.isSuccess, isTrue);
      final id = (insertResult as Success<int>).data;
      expect(id, isPositive);

      // Query
      final queryResult = await db.query(
        LocalDbTables.users,
        where: 'id = ?',
        whereArgs: [id],
      );

      expect(queryResult.isSuccess, isTrue);
      final rows = (queryResult as Success<List<Map<String, dynamic>>>).data;
      expect(rows, hasLength(1));
      expect(rows.first['name'], 'Test User');
    });

    test('update alters existing data', () async {
      // Insert first
      final userValues = {
        'firebase_uid': 'uid456',
        'name': 'Old Name',
        'email': 'update@example.com',
        'phone': '+1234567890',
        'ward_id': 1,
        'created_at': 0,
        'updated_at': 0,
      };
      await db.insert(LocalDbTables.users, userValues);

      // Update
      final updateResult = await db.update(
        LocalDbTables.users,
        {'name': 'New Name'},
        where: 'firebase_uid = ?',
        whereArgs: ['uid456'],
      );

      expect(updateResult.isSuccess, isTrue);
      expect((updateResult as Success<int>).data, 1); // 1 row updated

      // Verify
      final queryResult = await db.query(
        LocalDbTables.users,
        where: 'firebase_uid = ?',
        whereArgs: ['uid456'],
      );
      final rows = (queryResult as Success).data as List<Map<String, dynamic>>;
      expect(rows.first['name'], 'New Name');
    });

    test('delete removes data', () async {
      final userValues = {
        'firebase_uid': 'uid789',
        'name': 'To Delete',
        'email': 'delete@example.com',
        'phone': '+1234567890',
        'ward_id': 1,
        'created_at': 0,
        'updated_at': 0,
      };
      await db.insert(LocalDbTables.users, userValues);

      // Delete
      final deleteResult = await db.delete(
        LocalDbTables.users,
        where: 'firebase_uid = ?',
        whereArgs: ['uid789'],
      );

      expect(deleteResult.isSuccess, isTrue);
      expect((deleteResult as Success<int>).data, 1);

      // Verify empty
      final queryResult = await db.query(LocalDbTables.users);
      final rows = (queryResult as Success).data as List;
      expect(rows, isEmpty);
    });
  });

  group('LocalDb - Foreign Key Constraints', () {
    test('inserting booking without user fails and returns DbWriteError', () async {
      // Trying to insert a booking that references a non-existent user_id
      final bookingValues = {
        'booking_id': 'b_123',
        'user_id': 9999, // Doesn't exist
        'booking_status': 'pending',
        'waste_category': 'general',
        'pickup_date': 0,
        'created_at': 0,
        'updated_at': 0,
      };

      final insertResult = await db.insert(LocalDbTables.bookings, bookingValues);

      expect(insertResult.isFailure, isTrue);
      final error = (insertResult as Failure).error;
      expect(error, isA<DbWriteError>());
      expect(error.debugMessage, contains('FOREIGN KEY constraint failed'));
    });
  });

  group('LocalDb - Lifecycle Errors', () {
    test('querying closed db returns DbReadError', () async {
      await db.close();

      final result = await db.query(LocalDbTables.users);
      
      expect(result.isFailure, isTrue);
      expect((result as Failure).error, isA<DbReadError>());
      expect((result as Failure).error.debugMessage, contains('not open'));
    });
  });
}
