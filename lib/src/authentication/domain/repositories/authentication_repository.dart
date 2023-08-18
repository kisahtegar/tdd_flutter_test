import '../../../../core/utils/typedef.dart';
import '../entities/user.dart';

abstract class AuthenticationRepository {
  const AuthenticationRepository();

  // Used to create a new user.
  ResultVoid createUser({
    required String createdAt,
    required String name,
    required String avatar,
  });

  // Used to get list of user.
  ResultFuture<List<User>> getUsers();
}
