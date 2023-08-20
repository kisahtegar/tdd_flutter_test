import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_flutter_test/core/utils/typedef.dart';
import 'package:tdd_flutter_test/src/authentication/data/models/user_model.dart';
import 'package:tdd_flutter_test/src/authentication/domain/entities/user.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tModel = UserModel.empty();
  final tJson = fixture('user.json');
  final tMap = jsonDecode(tJson) as DataMap;

  test('should be a subclass of [User] entity', () {
    // Assert
    expect(tModel, isA<User>());
  });

  group('fromMap', () {
    test('should return a [UserModel] with the right data', () {
      // act
      final result = UserModel.fromMap(tMap);
      expect(result, equals(tModel));
    });
  });

  group('fromJson', () {
    test('should return a [UserModel] with the right data', () {
      // act
      final result = UserModel.fromJson(tJson);
      expect(result, equals(tModel));
    });
  });

  group('toMap', () {
    test('should return a [Map] with the right data', () {
      // act
      final result = tModel.toMap();

      // Assert
      expect(result, equals(tMap));
    });
  });

  group('toJson', () {
    test('should return a [JSON] string with the right data', () {
      // act
      final result = tModel.tojson();
      final tJson = jsonEncode({
        "id": "1",
        "createdAt": "_empty.createdAt",
        "avatar": "_empty.avatar",
        "name": "_empty.name"
      });
      // Assert
      expect(result, tJson);
    });
  });

  group('copyWith', () {
    test('should return a [UserModel] with different data', () {
      // act
      final result = tModel.copyWith(name: 'Paul');

      // Assert
      expect(result.name, equals('Paul'));
      // expect(result, not(tModel));
    });
  });
}
