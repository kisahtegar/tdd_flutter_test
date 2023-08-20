import 'package:dartz/dartz.dart';

import '../errors/failure.dart';

// Generic type definition for Result either failur or success.
typedef ResultFuture<T> = Future<Either<Failure, T>>;

typedef ResultVoid = ResultFuture<void>;

typedef DataMap = Map<String, dynamic>;
