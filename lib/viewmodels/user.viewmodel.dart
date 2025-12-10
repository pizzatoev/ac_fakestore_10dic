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
      // Si quieres mostrar un solo usuario, puedes agregar una propiedad para eso
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }
}

