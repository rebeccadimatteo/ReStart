/// Classe astratta [JWTConstants] che fornisce le chiavi segrete per i token JWT.
///
/// Contiene le chiavi segrete statiche utilizzate per firmare e verificare i token JWT.
abstract class JWTConstants {
  /// Chiave segreta per i token JWT degli utenti.
  ///
  /// Utilizzata per firmare e verificare i token JWT per gli utenti normali ('Utente').
  static const String accessTokenSecretKeyForUtente =
      'QBBS0P1H2NLLOTVRWIHR6WXI55G2ZYHH';

  /// Chiave segreta per i token JWT dei Centri di Assistenza.
  ///
  /// Utilizzata per firmare e verificare i token JWT per gli utenti del tipo 'CA' (Collaboratore aziendale).
  static const String accessTokenSecretKeyForCA =
      'QBBS0P1H2NLLOTVRWIHR6WXI55G2ZYHC';

  /// Chiave segreta per i token JWT degli Amministratori del Sistema.
  ///
  /// Utilizzata per firmare e verificare i token JWT per gli utenti del tipo 'ADS' (Amministratore del Sistema).
  static const String accessTokenSecretKeyForADS =
      'QBBS0P1H2NLLOTVRWIHR6WXI55G2ZYHA';

  /// Chiave segreta per i token di refresh.
  ///
  /// Utilizzata per firmare e verificare i token di refresh JWT, utilizzati per rinnovare i token di accesso.
  static const String refreshTokenSecretKey =
      'KF4DMA5VAYCGM60T7N0A46BLOEHXSNX7';
}
