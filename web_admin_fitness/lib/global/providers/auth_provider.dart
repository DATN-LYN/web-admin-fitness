import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../locator.dart';
import '../models/hive/user.dart';
import '../models/hive/user_credentials.dart';
import '../services/hive_service.dart';
import '../utils/constants.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider() {
    _credentials = _hiveService.getUserCredentials();
  }

  final _hiveService = locator.get<HiveService>();
  late UserCredentials _credentials;

  bool get isAuth => _credentials.accessToken != null;

  User? get user => _hiveService.getUserCredentials().user;

  Future login({
    required String token,
    //required String refreshToken,
    required User user,
  }) async {
    await _hiveService.saveUserCredentials(
      _credentials.copyWith(
        accessToken: token,
        //refreshToken: refreshToken,
        user: user,
      ),
    );
    _credentials = _hiveService.getUserCredentials();
    notifyListeners();
  }

  Future logout() async {
    await _hiveService.saveUserCredentials(UserCredentials());
    _credentials = _hiveService.getUserCredentials();
    Hive.box(Constants.hiveGraphqlBox).clear();
    notifyListeners();
  }
}
