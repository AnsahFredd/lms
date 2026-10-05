import 'package:fpdart/fpdart.dart';
import 'package:lms_backend/core/errors/failure.dart';

abstract class AppUsecase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

class NoParams {
  const NoParams();
}