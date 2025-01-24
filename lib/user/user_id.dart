class UserId {
  static final UserId _instance = UserId._internal();

  String? userId;

  factory UserId() {
    return _instance;
  }

  UserId._internal();
}
