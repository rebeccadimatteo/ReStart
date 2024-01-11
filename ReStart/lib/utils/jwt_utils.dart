import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

abstract class JWTUtils {
  static String generateAccessToken({
    required String userId,
    required String username,
    required String secretKey,
    required String userType,
  }) {
    final jwt = JWT({
      'userId': userId,  // Aggiungi l'ID dell'utente al payload
      'username': username,
      'userType': userType,
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

  static int getIdFromToken({required String accessToken}) {
    final jwt = JWT.decode(accessToken);
    // ignore: avoid_dynamic_calls
    return int.parse(jwt.payload['userId'].toString());
  }

  static String getUserFromToken({required String accessToken}) {
    final jwt = JWT.decode(accessToken);
    // ignore: avoid_dynamic_calls
    return jwt.payload['username'] as String;
  }

  static String getUserTypeFromToken({required String accessToken}) {
    final jwt = JWT.decode(accessToken);
    // Controlla se il campo 'userType' esiste nel payload del token
    if (jwt.payload.containsKey('userType')) {
      return jwt.payload['userType'] as String;
    } else {
      // Se il campo 'userType' non è presente, restituisci un valore predefinito o gestisci l'errore in base alle tue esigenze.
      return 'utente'; // Valore predefinito o gestione dell'errore
    }
  }
}
