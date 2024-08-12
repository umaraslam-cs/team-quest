import 'package:flutter/cupertino.dart';
import 'package:team_quest/model/user_model.dart';
import 'package:team_quest/services/auth_services.dart';

class AuthViewModel with ChangeNotifier, AuthService {
  bool _loginLoading = false;
  bool get loginLoading => _loginLoading;

  String _selectedLanguage = "";
  String get selectedLanguage => _selectedLanguage;

  setLoginLoading(bool value) {
    _loginLoading = value;
    notifyListeners();
  }

  setUserLanguage(String language) {
    _selectedLanguage = language;
    notifyListeners();
  }

  //creating getter method to store value of input email
  String _email = '';
  String get email => _email;

  setEmail(String email) {
    _email = email;
  }

  //creating getter method to store value of input password
  String _password = '';
  String get password => _password;

  setPassword(String password) {
    _password = password;
  }

  String _confirmPassword = '';
  String get confirmPassword => _confirmPassword;

  setConfirmPassword(String confirmPassword) {
    _confirmPassword = confirmPassword;
  }

  Future<UserModel> signIn(
      {required String email, required String password}) async {
    try {
      setLoginLoading(true);
      final response =
          await signInWithEmailPassword(email: email, password: password);
      setLoginLoading(false);

      return response;
    } catch (e) {
      setLoginLoading(false);
      throw Exception(e);
    }
  }

  Future<bool> signUp(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      bool result = false;
      setLoginLoading(true);
      final response = await registerWithEmailPassword(
          email: email, password: password, context: context);
      setLoginLoading(false);
      if (response) {
        result = true;
      }
      return result;
    } catch (e) {
      setLoginLoading(false);
      throw Exception(e);
    }
  }

  Future<bool> setLanguage(
      {required String language, required String uid}) async {
    bool result = false;
    setLoginLoading(true);
    result = await setLanguageService(language: language, uid: uid);
    setLoginLoading(false);
    return result;
  }
}
