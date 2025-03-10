class AuthController {
  final String _correctEmail = "test@example.com";
  final String _correctPassword = "password123";

  bool login(String email, String password) {
    return email == _correctEmail && password == _correctPassword;
  }
}
