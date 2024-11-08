import 'package:chatify/models/user.dart';

class Me {
  String userId;
  String username;
  String fullname;
  String token;

  Me({required this.userId, required this.username, required this.fullname, required this.token});
  User exportToUser() {
    return User(id: userId, fullname: fullname, username: username);
  }
}
