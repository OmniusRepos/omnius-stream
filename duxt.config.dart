/// Duxt configuration
class DuxtConfig {
  static const app = (
    name: 'omnius_stream',
    description: 'A Duxt application',
  );

  /// Rendering mode: 'spa', 'ssr', 'static'
  static const String mode = 'spa';

  /// API base URL
  static const String apiBase = '/api';

  /// Development server port
  static const int port = 3000;

  /// Database configuration
  static const database = (
    driver: String.fromEnvironment('DB_DRIVER', defaultValue: 'sqlite'),
    host: String.fromEnvironment('DB_HOST', defaultValue: 'localhost'),
    port: int.fromEnvironment('DB_PORT', defaultValue: 5432),
    database: String.fromEnvironment('DB_NAME', defaultValue: 'omnius_stream'),
    username: String.fromEnvironment('DB_USER', defaultValue: ''),
    password: String.fromEnvironment('DB_PASS', defaultValue: ''),
    path: String.fromEnvironment('DB_PATH', defaultValue: 'data/omnius_stream.db'),
    ssl: bool.fromEnvironment('DB_SSL', defaultValue: false),
  );
}
