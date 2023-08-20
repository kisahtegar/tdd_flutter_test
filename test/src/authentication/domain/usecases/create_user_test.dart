// What does the class depend on?
// Answer: AuthenticationRepository
// How can we create a fake version of the dependency?
// Answer: Use Mocktail
// how do we control what our dependencies dod
// Answer: Using the Mocktail's APIs

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_flutter_test/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:tdd_flutter_test/src/authentication/domain/usecases/create_user.dart';

import 'authentication_repository.mock.dart';

void main() {
  late AuthenticationRepository repository;
  late CreateUser usecase;
  const params = CreateUserParams.empty();

  // Create new instance of usecase and repository
  setUpAll(() {
    repository = MockAuthRepository();
    usecase = CreateUser(repository);
  });

  test(
    'should call the [AuthenticationRepository.createUser]',
    () async {
      // Arrange
      // STUB
      when(
        () => repository.createUser(
          createdAt: any(named: 'createdAt'),
          name: any(named: 'name'),
          avatar: any(named: 'avatar'),
        ),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = usecase(params);

      // Assert
      expect(result, equals(const Right<dynamic, void>(null)));
      verify(
        () => repository.createUser(
          createdAt: params.createdAt,
          name: params.name,
          avatar: params.avatar,
        ),
      ).called(1); // called only 1 time
      verifyNoMoreInteractions(repository);
    },
  );
}
