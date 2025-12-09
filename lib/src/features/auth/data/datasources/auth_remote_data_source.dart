import 'package:injectable/injectable.dart';
import 'package:napoli_app_v1/src/features/auth/data/models/user_model.dart';
import 'package:napoli_app_v1/src/features/settings/domain/entities/address_model.dart';
import 'package:napoli_app_v1/src/features/settings/domain/entities/payment_method.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String name, String email, String password);
  Future<UserModel> updateProfile(UserModel user);
}

@LazySingleton(as: AuthRemoteDataSource, env: ['dev'])
class MockAuthDataSource implements AuthRemoteDataSource {
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
        savedAddresses: [
          AddressModel(
            id: '1',
            label: 'Casa',
            address: 'Calle Principal 123, Col. Centro',
            city: 'Ciudad de México',
            details: 'Casa blanca con portón negro',
            isDefault: true,
          ),
          AddressModel(
            id: '2',
            label: 'Trabajo',
            address: 'Av. Reforma 456, Piso 8',
            city: 'Ciudad de México',
            details: 'Oficina 804, Torre B',
            isDefault: false,
          ),
        ],
        savedCards: [
          PaymentMethodModel(
            id: '1',
            type: PaymentType.card,
            cardNumber: '**** **** **** 1234',
            cardHolder: 'JUAN PEREZ',
            expiryDate: '12/28',
            cardBrand: 'Visa',
            isDefault: true,
          ),
          PaymentMethodModel(
            id: '2',
            type: PaymentType.card,
            cardNumber: '**** **** **** 5678',
            cardHolder: 'JUAN PEREZ',
            expiryDate: '03/27',
            cardBrand: 'Mastercard',
            isDefault: false,
          ),
        ],
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

@LazySingleton(as: AuthRemoteDataSource, env: ['prod'])
class RealAuthDataSource implements AuthRemoteDataSource {
  @override
  Future<UserModel> login(String email, String password) {
    // TODO: implement login with real API
    throw UnimplementedError();
  }

  @override
  Future<UserModel> register(String name, String email, String password) {
    // TODO: implement register with real API
    throw UnimplementedError();
  }

  @override
  Future<UserModel> updateProfile(UserModel user) {
    // TODO: implement updateProfile with real API
    throw UnimplementedError();
  }
}
