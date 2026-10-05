import 'package:dotenv/dotenv.dart' as load_env;

class AppConfig {
  final String databaseUrl;
  final int port;
  final String appEnv;

  AppConfig._(this.databaseUrl, this.port, this.appEnv);

  factory AppConfig.load() {
    final env = load_env.DotEnv(includePlatformEnvironment: true)..load();

    final databaseUrl = env["DATABASE_URI"];

    if (databaseUrl == null || databaseUrl.isEmpty) {
      throw Exception("DATABASE URL is missing form env");
    }

    final appEnv = env['APP_ENV'];

    if (appEnv == null || appEnv.isEmpty) {
      throw Exception("APP ENV is missing from env");
    }

    final portValue = env['PORT'] ?? '8000';
    final port = int.tryParse(portValue);

    if (port == null) {
      throw Exception("PORT must be a valid number");
    }

    return AppConfig._(databaseUrl, port, appEnv);
  }
}
