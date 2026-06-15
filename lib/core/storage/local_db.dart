import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:suchigo_app/core/errors/app_error.dart';
import 'package:suchigo_app/core/errors/result.dart';
import 'package:suchigo_app/core/storage/local_db_tables.dart';
import 'package:suchigo_app/core/utils/app_logger.dart';

/// Core Database accessor.
///
/// Wraps `sqflite` to provide a safe, fully typed CRUD interface.
/// Prevents raw SQL leakage by returning `Result<T>` and converting exceptions
/// to `DbReadError` or `DbWriteError`.
class LocalDb {
  Database? _database;

  /// Underlying `sqflite` database factory. Injected for testing.
  final DatabaseFactory _dbFactory;

  LocalDb({DatabaseFactory? dbFactory})
      : _dbFactory = dbFactory ?? databaseFactory;

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  /// Opens the database, running migrations if necessary.
  Future<Result<void>> open() async {
    if (_database != null && _database!.isOpen) {
      return const Success(null);
    }

    try {
      final dbPath = await _dbFactory.getDatabasesPath();
      final path = join(dbPath, LocalDbTables.databaseName);

      _database = await _dbFactory.openDatabase(
        path,
        options: OpenDatabaseOptions(
          version: LocalDbTables.version,
          onCreate: _onCreate,
          onUpgrade: _onUpgrade,
          onConfigure: _onConfigure,
        ),
      );

      return const Success(null);
    } catch (e, st) {
      AppLogger.error('Failed to open database', error: e, stackTrace: st);
      return Failure(DbReadError(cause: 'Open failed: $e'));
    }
  }

  /// Closes the active database connection.
  Future<Result<void>> close() async {
    try {
      if (_database != null && _database!.isOpen) {
        await _database!.close();
        _database = null;
      }
      return const Success(null);
    } catch (e, st) {
      AppLogger.error('Failed to close database', error: e, stackTrace: st);
      return Failure(DbWriteError(cause: 'Close failed: $e'));
    }
  }

  /// Exposes the raw Database for DatabaseHealthService.
  /// Internal use only. Should not be used by repositories.
  Database? get internalDb => _database;

  // ---------------------------------------------------------------------------
  // Configuration & Migrations
  // ---------------------------------------------------------------------------

  Future<void> _onConfigure(Database db) async {
    // Enable foreign keys
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    AppLogger.info('Creating database v$version');
    for (final script in LocalDbTables.v1Scripts) {
      await db.execute(script);
    }
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    AppLogger.info('Upgrading database from v$oldVersion to v$newVersion');

    // Example migration pattern (fallthrough switch):
    // switch (oldVersion) {
    //   case 1:
    //     await db.execute('ALTER TABLE users ADD COLUMN age INTEGER;');
    //   case 2:
    //     await db.execute('CREATE TABLE ...');
    // }
  }

  // ---------------------------------------------------------------------------
  // Typed Operations
  // ---------------------------------------------------------------------------

  /// Inserts a row into [table]. Returns the inserted row ID.
  Future<Result<int>> insert(String table, Map<String, dynamic> values) async {
    return _safely(() async {
      return await _database!.insert(
        table,
        values,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  /// Queries [table] with optional [where] clause and [whereArgs].
  Future<Result<List<Map<String, dynamic>>>> query(
    String table, {
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
  }) async {
    return _safelyRead(table, () async {
      return await _database!.query(
        table,
        where: where,
        whereArgs: whereArgs,
        orderBy: orderBy,
        limit: limit,
      );
    });
  }

  /// Updates rows in [table] matching [where] clause. Returns rows affected.
  Future<Result<int>> update(
    String table,
    Map<String, dynamic> values, {
    required String where,
    required List<Object?> whereArgs,
  }) async {
    return _safely(() async {
      return await _database!.update(
        table,
        values,
        where: where,
        whereArgs: whereArgs,
      );
    });
  }

  /// Deletes rows from [table] matching [where] clause. Returns rows affected.
  Future<Result<int>> delete(
    String table, {
    required String where,
    required List<Object?> whereArgs,
  }) async {
    return _safely(() async {
      return await _database!.delete(
        table,
        where: where,
        whereArgs: whereArgs,
      );
    });
  }

  // ---------------------------------------------------------------------------
  // Transaction Support
  // ---------------------------------------------------------------------------

  /// Executes multiple operations atomically within a transaction.
  Future<Result<T>> transaction<T>(
    Future<T> Function(Transaction txn) action,
  ) async {
    if (_database == null) return Failure(DbWriteError(cause: 'DB not open'));

    try {
      final result = await _database!.transaction(action);
      return Success(result);
    } catch (e, st) {
      AppLogger.error('Transaction failed', error: e, stackTrace: st);
      return Failure(DbWriteError(cause: 'Transaction failed: $e'));
    }
  }

  // ---------------------------------------------------------------------------
  // Execution Guards
  // ---------------------------------------------------------------------------

  Future<Result<T>> _safely<T>(Future<T> Function() action) async {
    if (_database == null) return Failure(DbWriteError(cause: 'DB not open'));

    try {
      final result = await action();
      return Success(result);
    } catch (e, st) {
      AppLogger.error('DB Write Error', error: e, stackTrace: st);
      return Failure(DbWriteError(cause: e.toString()));
    }
  }

  Future<Result<T>> _safelyRead<T>(
      String table, Future<T> Function() action) async {
    if (_database == null) return Failure(DbReadError(cause: 'DB not open'));

    try {
      final result = await action();
      return Success(result);
    } catch (e, st) {
      AppLogger.error('DB Read Error on $table', error: e, stackTrace: st);
      return Failure(DbReadError(table: table, cause: e.toString()));
    }
  }
}
