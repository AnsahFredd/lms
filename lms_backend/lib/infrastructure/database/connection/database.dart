import 'package:postgres/postgres.dart';

Future<Connection> connectDatabase(String databaseUrl) async {
  final uri = Uri.parse(databaseUrl);
  final parts = uri.userInfo.split(':');
  final username = Uri.decodeComponent(parts[0]);
  final password = Uri.decodeComponent(parts[1]);
  return Connection.open(
    Endpoint(
        host: uri.host,
        port: uri.hasPort ? uri.port : 5432,
        database: uri.pathSegments.first,
        username: username,
        password: password),
        settings: ConnectionSettings(sslMode: SslMode.require),
  );
}
