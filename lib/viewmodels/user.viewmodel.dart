import 'package:flutter/cupertino.dart';
import '../models/user.model.dart';
import '../services/user.service.dart';

class UserViewModel extends ChangeNotifier {
  final UserService _userService = UserService();

  List<User> _users = [];
  bool _cargando = false;
  String? _error;

  List<User> get users => _users;
  bool get cargando => _cargando;
  String? get error => _error;

  Future<void> fetchUsers() async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      _users = await _userService.fetchUsers();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<void> fetchUser(int id) async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      await _userService.fetchUser(id);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<bool> createUser(User user) async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      final newUser = await _userService.createUser(user);
      _users.add(newUser);
      _error = null;
      _cargando = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _cargando = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateUser(int id, User user) async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      final updatedUser = await _userService.updateUser(id, user);
      final index = _users.indexWhere((u) => u.id == id);
      if (index != -1) {
        _users[index] = updatedUser;
      }
      _error = null;
      _cargando = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _cargando = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteUser(int id) async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      await _userService.deleteUser(id);
      _users.removeWhere((u) => u.id == id);
      _error = null;
      _cargando = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _cargando = false;
      notifyListeners();
      return false;
    }
  }
}
