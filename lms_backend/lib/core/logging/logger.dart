import 'package:logging/logging.dart';

void initLogging(String environment) {
  hierarchicalLoggingEnabled = true;

  Logger.root.level = _getLogLevel(environment);

  Logger.root.onRecord.listen((record) {
    print(
      '[${record.level.name}] '
      '${record.loggerName}: ${record.message}',
    );
  });
}

Level _getLogLevel(String environment) {
  switch (environment.toLowerCase()) {
    case 'production':
      return Level.INFO;

    case 'staging':
      return Level.INFO;

    case 'development':
      return Level.ALL;

    default:
      return Level.ALL;
  }
}