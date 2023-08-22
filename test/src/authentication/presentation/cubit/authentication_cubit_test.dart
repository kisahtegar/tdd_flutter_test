import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_flutter_test/core/errors/failure.dart';

import 'package:tdd_flutter_test/src/authentication/domain/usecases/create_user.dart';
import 'package:tdd_flutter_test/src/authentication/domain/usecases/get_users.dart';
import 'package:tdd_flutter_test/src/authentication/presentation/cubit/authentication_cubit.dart';

class MockGetUsers extends Mock implements GetUsers {}

class MockCreateUser extends Mock implements CreateUser {}

void main() {
  late GetUsers getUsers;
  late CreateUser createUser;
  late AuthenticationCubit cubit;

  const tCreateUserParams = CreateUserParams.empty();
  const tAPIFailure = APIFailure(message: 'message', statusCode: 400);

  setUp(() {
    getUsers = MockGetUsers();
    createUser = MockCreateUser();
    cubit = AuthenticationCubit(createUser: createUser, getUsers: getUsers);
    registerFallbackValue(tCreateUserParams);
  });

  // After we test we want to clear cubit.
  tearDown(() => cubit.close());

  test('initial state should be [AuthenticationInitial]', () async {
    expect(cubit.state, const AuthenticationInitial());
  });

  group('createUser', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [CreatingUser, UserCreated] when successful',
      // Arrange
      build: () {
        when(
          () => createUser(any()),
        ).thenAnswer((_) async => const Right(null));

        return cubit;
      },

      // Act
      act: (cubit) => cubit.createUser(
        createdAt: tCreateUserParams.createdAt,
        name: tCreateUserParams.name,
        avatar: tCreateUserParams.avatar,
      ),

      // Assert
      expect: () => [
        const CreatingUser(),
        const UserCreated(),
      ],
      verify: (_) {
        verify(() => createUser(tCreateUserParams)).called(1);
        verifyNoMoreInteractions(createUser);
      },
    );

    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [CreatingUser, AuthenticationError] when unsuccessful',
      // Arrange
      build: () {
        when(
          () => createUser(any()),
        ).thenAnswer((_) async => const Left(tAPIFailure));

        return cubit;
      },

      // Act
      act: (cubit) => cubit.createUser(
        createdAt: tCreateUserParams.createdAt,
        name: tCreateUserParams.name,
        avatar: tCreateUserParams.avatar,
      ),

      // Assert
      expect: () => [
        const CreatingUser(),
        AuthenticationError(tAPIFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => createUser(tCreateUserParams)).called(1);
        verifyNoMoreInteractions(createUser);
      },
    );
  });

  group('getUsers', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [GettingUser, UsersLoaded] when successful',
      // Arrange
      build: () {
        when(
          () => getUsers(),
        ).thenAnswer((_) async => const Right([]));

        return cubit;
      },

      // Act
      act: (cubit) => cubit.getUsers(),

      // Assert
      expect: () => const [
        GettingUsers(),
        UsersLoaded([]),
      ],
      verify: (_) {
        verify(() => getUsers()).called(1);
        verifyNoMoreInteractions(createUser);
      },
    );

    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [GettingUser, AuthenticationError] when unsuccessful',
      // Arrange
      build: () {
        when(
          () => getUsers(),
        ).thenAnswer((_) async => const Left(tAPIFailure));

        return cubit;
      },

      // Act
      act: (cubit) => cubit.getUsers(),

      // Assert
      expect: () => [
        const GettingUsers(),
        AuthenticationError(tAPIFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => getUsers()).called(1);
        verifyNoMoreInteractions(createUser);
      },
    );
  });
}
