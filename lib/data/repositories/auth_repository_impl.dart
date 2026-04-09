import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<User> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network
    if (email == 'test@example.com' && password == 'password') {
      return const User(
        id: '1',
        name: 'Vaidehi Sharma',
        email: 'test@example.com',
        token: 'mock_token',
      );
    }
    throw Exception('Invalid credentials');
  }

  @override
  Future<User> signup(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return User(
      id: '2',
      name: name,
      email: email,
      token: 'mock_token_new',
    );
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
