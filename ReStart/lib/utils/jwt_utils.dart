import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

abstract class JWTUtils {
  static String generateAccessToken({required String username, required String secretKey}) {
    final jwt = JWT({
      'username': username,
    });

    return jwt.sign(
      SecretKey(secretKey),
      expiresIn: const Duration(days: 1),
    );
  }

  static bool verifyAccessToken({required String accessToken, required String secretKey}) {
    try {
      JWT.verify(accessToken, SecretKey(secretKey));
      return true;
    } catch (_) {
      return false;
    }
  }

  static String getUserIdFromToken({required String accessToken}) {
    final jwt = JWT.decode(accessToken);
    // ignore: avoid_dynamic_calls
    return jwt.payload['email'] as String;
  }
}
