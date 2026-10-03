import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

Handler buildApp(Connection db) {
  final router = Router();
  router.get("/health", (Request req) => Response.ok("Ok"));

  return const Pipeline().addMiddleware(logRequests()).addHandler(router.call);
}
