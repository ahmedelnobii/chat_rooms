import 'package:chat_rooms/core/consts/app_icons.dart';

enum FieldType { email, password, name }

String icon(FieldType type) {
  switch (type) {
    case FieldType.email:
      return AppIcons.email;
    case FieldType.password:
      return AppIcons.password;
    case FieldType.name:
      return AppIcons.user;
  }
}
