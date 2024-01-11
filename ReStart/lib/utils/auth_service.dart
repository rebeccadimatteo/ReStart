import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'jwt_constants.dart';
import 'jwt_utils.dart';

class AuthService {
  static Future<bool> checkUserUtente() async {
    var token = await SessionManager().get("token");
    if (token != null) {
      return JWTUtils.verifyAccessToken(
          accessToken: await token,
          secretKey: JWTConstants.accessTokenSecretKeyForUtente);
    }
    return false;
  }

  static Future<bool> checkUserCA() async {
    var token = await SessionManager().get("token");
    if (token != null) {
      return JWTUtils.verifyAccessToken(
          accessToken: await token,
          secretKey: JWTConstants.accessTokenSecretKeyForCA);
    }
    return false;
  }

  static Future<bool> checkUserADS() async {
    var token = await SessionManager().get("token");
    if (token != null) {
      return JWTUtils.verifyAccessToken(
          accessToken: await token,
          secretKey: JWTConstants.accessTokenSecretKeyForADS);
    }
    return false;
  }
}