import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tdd_flutter_test/core/errors/exceptions.dart';
import 'package:tdd_flutter_test/core/errors/failure.dart';
import 'package:tdd_flutter_test/src/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:tdd_flutter_test/src/authentication/data/repositories/authentication_repository_implementation.dart';
import 'package:tdd_flutter_test/src/authentication/domain/entities/user.dart';

// Dependency mock
class MockAuthRemoteDataSource extends Mock
    implements AuthenticationRemoteDataSource {}

void main() {
  late AuthenticationRemoteDataSource remoteDataSource;
  late AuthenticationRepositoryImplementation repoImpl;

  setUp(() {
    remoteDataSource = MockAuthRemoteDataSource();
    repoImpl = AuthenticationRepositoryImplementation(remoteDataSource);
  });

  const tExecption = APIException(
    message: 'Unknown Error Occured',
    statusCode: 500,
  );

  group('createdUser', () {
    const createdAt = 'whatever.createdAt';
    const name = 'whatever.name';
    const avatar = 'whatever.avatar';

    test(
      'should call the [RemoteDataSouce.createUser] and complete '
      'successfully when the call to the remote source is successful',
      () async {
        // arrange
        when(
          () => remoteDataSource.createUser(
            createdAt: any(named: 'createdAt'),
            name: any(named: 'name'),
            avatar: any(named: 'avatar'),
          ),
        ).thenAnswer((_) async => Future.value());

        // act
        final result = await repoImpl.createUser(
          createdAt: createdAt,
          name: name,
          avatar: avatar,
        );

        // assert
        expect(result, equals(const Right(null)));
        verify(
          () => remoteDataSource.createUser(
            createdAt: createdAt,
            name: name,
            avatar: avatar,
          ),
        ).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'should return a [APIFailure] when the call to the remote '
      'source is unsuccessful',
      () async {
        // Arrange
        when(
          () => remoteDataSource.createUser(
            createdAt: any(named: 'createdAt'),
            name: any(named: 'name'),
            avatar: any(named: 'avatar'),
          ),
        ).thenThrow(tExecption);

        // act
        final result = await repoImpl.createUser(
          createdAt: createdAt,
          name: name,
          avatar: avatar,
        );

        expect(
          result,
          equals(
            Left(
              APIFailure(
                message: tExecption.message,
                statusCode: tExecption.statusCode,
              ),
            ),
          ),
        );

        verify(
          () => remoteDataSource.createUser(
            createdAt: createdAt,
            name: name,
            avatar: avatar,
          ),
        ).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });

  group('getUsers', () {
    test(
      'should call the [RemoteDataSource.getUsers] and return [List<User>] '
      'when call to remote source is successful',
      () async {
        // Arrange
        when(
          () => remoteDataSource.getUsers(),
        ).thenAnswer((_) async => []);

        // Act
        final result = await repoImpl.getUsers();

        // Assert
        expect(result, isA<Right<dynamic, List<User>>>());
        verify(() => remoteDataSource.getUsers()).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'should return a [APIFailure] when the call to the remote '
      'source is unsuccessful',
      () async {
        // Arrange
        when(
          () => remoteDataSource.getUsers(),
        ).thenThrow(tExecption);

        // Act
        final result = await repoImpl.getUsers();

        // Assert
        expect(result, equals(Left(APIFailure.fromException(tExecption))));
        verify(() => remoteDataSource.getUsers()).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });
}
