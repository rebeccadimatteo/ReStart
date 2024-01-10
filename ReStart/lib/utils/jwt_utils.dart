import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

abstract class JWTUtils {
  static String generateAccessToken({
    required String username,
    required String secretKey,
    required String userType, // Aggiungi il tipo di utente come parametro
  }) {
    final jwt = JWT({
      'username': username,
      'userType': userType, // Aggiungi il tipo di utente al payload
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
