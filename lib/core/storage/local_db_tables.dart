/// Defines the schema, versions, and DDL scripts for the local SQLite database.
///
/// This serves as the single source of truth for the database structure.
/// All `CREATE TABLE` and `CREATE INDEX` statements are defined here to
/// avoid polluting the execution logic in `local_db.dart`.
abstract final class LocalDbTables {
  /// Current schema version. Increment this when making schema changes.
  static const int version = 1;

  /// Database file name.
  static const String databaseName = 'suchigo.db';

  // ---------------------------------------------------------------------------
  // Table Names
  // ---------------------------------------------------------------------------
  static const String users = 'users';
  static const String bookings = 'bookings';
  static const String trackingCache = 'tracking_cache';
  static const String bills = 'bills';
  static const String syncQueue = 'sync_queue';

  // ---------------------------------------------------------------------------
  // Initial Creation DDL (v1)
  // ---------------------------------------------------------------------------

  /// Returns all `CREATE TABLE` and `CREATE INDEX` scripts for v1.
  static List<String> get v1Scripts => [
        _createUsersTable,
        _createUsersIndexes,
        _createBookingsTable,
        _createBookingsIndexes,
        _createTrackingCacheTable,
        _createTrackingCacheIndexes,
        _createBillsTable,
        _createBillsIndexes,
        _createSyncQueueTable,
        _createSyncQueueIndexes,
      ];

  // ---------------------------------------------------------------------------
  // USERS Table
  // ---------------------------------------------------------------------------
  static const String _createUsersTable = '''
    CREATE TABLE $users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      firebase_uid TEXT UNIQUE NOT NULL,
      name TEXT NOT NULL,
      email TEXT UNIQUE NOT NULL,
      phone TEXT NOT NULL,
      ward_id INTEGER NOT NULL,
      created_at INTEGER NOT NULL,
      updated_at INTEGER NOT NULL
    )
  ''';

  static const String _createUsersIndexes = '''
    CREATE INDEX idx_users_lookup ON $users (firebase_uid, email);
  ''';

  // ---------------------------------------------------------------------------
  // BOOKINGS Table
  // ---------------------------------------------------------------------------
  static const String _createBookingsTable = '''
    CREATE TABLE $bookings (
      booking_id TEXT PRIMARY KEY,
      user_id INTEGER NOT NULL,
      booking_status TEXT NOT NULL,
      waste_category TEXT NOT NULL,
      pickup_date INTEGER NOT NULL,
      created_at INTEGER NOT NULL,
      updated_at INTEGER NOT NULL,
      FOREIGN KEY (user_id) REFERENCES $users (id) ON DELETE CASCADE
    )
  ''';

  static const String _createBookingsIndexes = '''
    CREATE INDEX idx_bookings_user_status ON $bookings (user_id, booking_status);
  ''';

  // ---------------------------------------------------------------------------
  // TRACKING CACHE Table
  // ---------------------------------------------------------------------------
  static const String _createTrackingCacheTable = '''
    CREATE TABLE $trackingCache (
      booking_id TEXT PRIMARY KEY,
      latitude REAL NOT NULL,
      longitude REAL NOT NULL,
      collector_status TEXT NOT NULL,
      updated_at INTEGER NOT NULL,
      FOREIGN KEY (booking_id) REFERENCES $bookings (booking_id) ON DELETE CASCADE
    )
  ''';

  static const String _createTrackingCacheIndexes = '''
    CREATE INDEX idx_tracking_cache_booking ON $trackingCache (booking_id);
  ''';

  // ---------------------------------------------------------------------------
  // BILLS Table
  // ---------------------------------------------------------------------------
  static const String _createBillsTable = '''
    CREATE TABLE $bills (
      bill_id TEXT PRIMARY KEY,
      booking_id TEXT NOT NULL,
      amount REAL NOT NULL,
      status TEXT NOT NULL,
      issued_at INTEGER NOT NULL,
      FOREIGN KEY (booking_id) REFERENCES $bookings (booking_id) ON DELETE CASCADE
    )
  ''';

  static const String _createBillsIndexes = '''
    CREATE INDEX idx_bills_booking ON $bills (booking_id);
  ''';

  // ---------------------------------------------------------------------------
  // SYNC QUEUE Table
  // ---------------------------------------------------------------------------
  static const String _createSyncQueueTable = '''
    CREATE TABLE $syncQueue (
      queue_id TEXT PRIMARY KEY,
      entity_type TEXT NOT NULL,
      operation TEXT NOT NULL,
      payload_json TEXT NOT NULL,
      retry_count INTEGER NOT NULL DEFAULT 0,
      created_at INTEGER NOT NULL
    )
  ''';

  static const String _createSyncQueueIndexes = '''
    CREATE INDEX idx_sync_queue_lookup ON $syncQueue (entity_type, retry_count);
  ''';
}
