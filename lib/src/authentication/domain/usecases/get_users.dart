import 'package:tdd_flutter_test/core/usecase/usecase.dart';
import 'package:tdd_flutter_test/core/utils/typedef.dart';
import 'package:tdd_flutter_test/src/authentication/domain/entities/user.dart';

import '../repositories/authentication_repository.dart';

class GetUsers extends UsecaseWithoutParams<List<User>> {
  const GetUsers(this._repository);

  final AuthenticationRepository _repository;

  @override
  ResultFuture<List<User>> call() async => _repository.getUsers();
}
