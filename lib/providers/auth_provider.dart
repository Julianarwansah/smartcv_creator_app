import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _currentUser;
  UserModel? _userModel;
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  AuthProvider() {
    _init();
  }

  void _init() {
    _authService.authStateChanges.listen((user) async {
      _currentUser = user;
      if (user != null) {
        await _loadUserData(user.uid);
      } else {
        _userModel = null;
      }
      notifyListeners();
    });
  }

  Future<void> _loadUserData(String uid) async {
    try {
      _userModel = await _authService.getUserData(uid);

      // If user document doesn't exist, create it
      if (_userModel == null && _currentUser != null) {
        // Extract name from email if displayName is not available
        String userName =
            _currentUser!.displayName ??
            _currentUser!.email?.split('@').first ??
            'User';

        final newUserModel = UserModel(
          uid: uid,
          name: userName,
          email: _currentUser!.email ?? '',
          phone: _currentUser!.phoneNumber,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        debugPrint('DEBUG: Creating user document with name: $userName');
        await _authService.createUserDocument(newUserModel);
        _userModel = newUserModel;
      }

      // Update user document if name is empty
      if (_userModel != null &&
          (_userModel!.name.isEmpty || _userModel!.name == '')) {
        String userName =
            _currentUser!.displayName ??
            _currentUser!.email?.split('@').first ??
            'User';

        final updatedUserModel = _userModel!.copyWith(name: userName);
        debugPrint('DEBUG: Updating user document with name: $userName');
        await _authService.updateUserData(updatedUserModel);
        _userModel = updatedUserModel;
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading user data: $e');
    }
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    String? phone,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.signUpWithEmail(
        email: email,
        password: password,
        name: name,
        phone: phone,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signIn({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.signInWithEmail(email: email, password: password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _currentUser = null;
    _userModel = null;
    notifyListeners();
  }

  Future<bool> resetPassword(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.resetPassword(email);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
