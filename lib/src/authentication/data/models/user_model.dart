import 'dart:convert';

import '../../../../core/utils/typedef.dart';
import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.createdAt,
    required super.name,
    required super.avatar,
  });

  const UserModel.empty()
      : this(
          id: '1',
          createdAt: '_empty.createdAt',
          name: '_empty.name',
          avatar: '_empty.avatar',
        );

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(jsonDecode(source) as DataMap);

  UserModel copyWith({
    String? id,
    String? createdAt,
    String? avatar,
    String? name,
  }) {
    return UserModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      avatar: avatar ?? this.avatar,
      name: name ?? this.name,
    );
  }

  UserModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          createdAt: map['createdAt'] as String,
          avatar: map['avatar'] as String,
          name: map['name'] as String,
        );

  DataMap toMap() => {
        'id': id,
        'createdAt': createdAt,
        'avatar': avatar,
        'name': name,
      };

  String tojson() => jsonEncode(toMap());
}
