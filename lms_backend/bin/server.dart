import 'dart:io';

import 'package:lms_backend/app.dart';
import 'package:lms_backend/core/config/app_config.dart';
import 'package:lms_backend/core/logging/logger.dart';
import 'package:lms_backend/infrastructure/database/connection/database.dart';
import 'package:logging/logging.dart';
import 'package:shelf/shelf_io.dart' as io;

Future<void> main() async {
  final config = AppConfig.load();

  initLogging(config.appEnv);

  final logger = Logger('Server');

  logger.info('Starting LMS backend');
  logger.info('Environment: ${config.appEnv}');

  final db = await connectDatabase(config.databaseUrl);

  logger.info('Database connected');

  final server = await io.serve(
    buildApp(db),
    InternetAddress.anyIPv4,
    config.port,
  );

  logger.info('Server listening on port ${server.port}');

  ProcessSignal.sigint.watch().listen((_) async {
    logger.info('Shutting down server');

    await server.close();
    await db.close();

    logger.info('Server shut down successfully');

    exit(0);
  });
}