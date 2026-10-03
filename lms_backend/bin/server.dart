import 'dart:io';

import 'package:lms_backend/app.dart';
import 'package:lms_backend/core/config/app_config.dart';
import 'package:lms_backend/infrastructure/database/connection/database.dart';
import 'package:shelf/shelf_io.dart' as io;

void main() async {
  final config = AppConfig.load();
  final db = await connectDatabase(config.databaseUrl);
  print("Database connected");
  // handler function that responds to request
  // start server on port
  final server =
      await io.serve(buildApp(db), InternetAddress.anyIPv4, config.port);
  print('Server listening on port ${server.port}');

  ProcessSignal.sigint.watch().listen((_) async {
    await server.close();
    await db.close();
    exit(0);
  });
}
