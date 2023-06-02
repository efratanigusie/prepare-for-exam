import '../dataProviders/auth.dart';
import '../models/loginModel.dart';
import '../models/user.dart';

class AuthRepository {
  final AuthDataProvider authDataProvider;
  AuthRepository({required this.authDataProvider});

  Future<int> register(User user) async {
    return await authDataProvider.register(user);
  }

  Future<List<User>> getAllUsers() async {
    return await authDataProvider.getAllUsers();
  }

  Future<Map<String, dynamic>> login(LoginModel loginModel) async {
    return await authDataProvider.login(loginModel);
  }
}
