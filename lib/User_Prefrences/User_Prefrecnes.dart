
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/user_model.dart';

class UserPreferences {
  Future<bool> saveUser(UserModel responseModel) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('token', responseModel.token ?? '');
    sp.setString('userId', responseModel.user?.id ?? '');
    sp.setString('username', responseModel.user?.username ?? '');
    sp.setString('email', responseModel.user?.email ?? '');
    sp.setString('role', responseModel.user?.role ?? '');
    sp.setBool('isLogin', true);
    return true;
  }

  Future<UserModel> getUser() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? token = sp.getString('token');
    String? userId = sp.getString('userId');
    String? username = sp.getString('username');
    String? email = sp.getString('email');
    String? role = sp.getString('role');

    return UserModel(
      token: token,
      user: User(
        id: userId,
        username: username,
        email: email,
        role: role,
      ),
    );
  }

  Future<bool> removeUser() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.clear();
  }
}
