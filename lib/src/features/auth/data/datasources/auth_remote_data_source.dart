import 'package:injectable/injectable.dart';
import 'package:napoli_app_v1/src/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String name, String email, String password);
  Future<UserModel> updateProfile(UserModel user);
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Mock login logic
    if (password == '123456') {
      return UserModel(
        id: 'u1',
        name: 'Usuario Demo',
        email: email,
        phone: '+52 55 1234 5678',
        address: 'Calle Falsa 123',
      );
    } else {
      throw Exception('Credenciales inválidas');
    }
  }

  @override
  Future<UserModel> register(String name, String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
    );
  }

  @override
  Future<UserModel> updateProfile(UserModel user) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return user;
  }
}
