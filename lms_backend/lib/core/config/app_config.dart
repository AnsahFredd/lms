import 'package:dotenv/dotenv.dart' as load_env;

class AppConfig {
  final String databaseUrl;
  final int port;

  AppConfig._(this.databaseUrl, this.port);

  factory AppConfig.load() {
    final env = load_env.DotEnv(includePlatformEnvironment: true)..load();
    final databaseUrl = env["DATABASE_URI"];
    if (databaseUrl == null || databaseUrl.isEmpty) {
      throw Exception("DATABASE URL is missing form env");
    }

    return AppConfig._(databaseUrl, int.parse(env["PORT"] ?? "8000"));
  }
}
