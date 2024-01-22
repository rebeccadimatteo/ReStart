import '../../../model/dao/autenticazione/autenticazione_DAO.dart';
import '../../../model/dao/autenticazione/autenticazione_DAO_impl.dart';
import '../../../model/dao/autenticazione/utente/utente_DAO.dart';
import '../../../model/dao/autenticazione/utente/utente_DAO_impl.dart';
import '../../../model/entity/ads_DTO.dart';
import '../../../model/entity/ca_DTO.dart';
import '../../../model/entity/utente_DTO.dart';
import '../../../utils/jwt_constants.dart';
import '../../../utils/jwt_utils.dart';
import 'autenticazione_service.dart';

/// Implementazione del service di autenticazione.
///
/// Fornisce l'implementazione concreta dei metodi definiti nell'interfaccia
/// `AutenticazioneService`. Utilizza DAO per l'accesso ai dati relativi agli utenti.
class AutenticazioneServiceImpl implements AutenticazioneService {
  /// DAO per l'autenticazione.
  final AutenticazioneDAO _autenticazioneDAO;

  /// DAO per la gestione degli utenti.
  final UtenteDAO _utenteDAO;

  /// Costruttore che inizializza i DAO necessari.
  AutenticazioneServiceImpl()
      : _autenticazioneDAO = AutenticazioneDAOImpl(),
        _utenteDAO = UtenteDAOImpl();

  /// Effettua il login di un utente.
  ///
  /// Confronta la password fornita con quella memorizzata e restituisce il DTO
  /// dell'utente in caso di corrispondenza.
  @override
  Future<dynamic> login(String user, String psw) async {
    dynamic utente = await _autenticazioneDAO.findByUsername(user);
    if (utente == null) {
      return null;
    } else {
      if (utente is AdsDTO) {
        AdsDTO utenteAds = utente;
        if (utenteAds.password == psw) {
          return utenteAds;
        }
      }
      if (utente is UtenteDTO) {
        UtenteDTO utenteU = utente;
        if (utenteU.password == psw) {
          return utenteU;
        }
      } else {
        CaDTO utenteCa = utente;
        if (utenteCa.password == psw) {
          return utenteCa;
        }
      }
    }
  }

  /// Visualizza i dettagli di un utente specificato dal suo username.
  ///
  /// Utilizza `UtenteDAO` per recuperare i dettagli dell'utente.
  @override
  Future<UtenteDTO?> visualizzaUtente(String username) {
    final UtenteDAO utenteDAO = UtenteDAOImpl();
    return utenteDAO.findByUsername(username);
  }

  /// Fornisce un elenco di tutti gli utenti.
  ///
  /// Utilizza `UtenteDAO` per recuperare la lista completa degli utenti.
  @override
  Future<List<UtenteDTO>> listaUtenti() {
    return _utenteDAO.findAll();
  }

  /// Elimina un utente specificato dal suo username.
  ///
  /// Utilizza `UtenteDAO` per rimuovere l'utente specificato.
  @override
  Future<bool> deleteUtente(String username) {
    final UtenteDAO utenteDAO = UtenteDAOImpl();
    return utenteDAO.removeByUsername(username);
  }

  /// Modifica i dettagli di un utente.
  ///
  /// Utilizza `UtenteDAO` per aggiornare i dettagli dell'utente.
  @override
  Future<bool> modifyUtente(UtenteDTO u) {
    return _utenteDAO.update(u);
  }

  /// Verifica se un utente è autorizzato in base al token JWT fornito.
  ///
  /// Utilizza `JWTUtils` per verificare il token.
  @override
  Future<bool> checkUserUtente(var token) async {
    if (token != null) {
      return JWTUtils.verifyAccessToken(
          accessToken: await token,
          secretKey: JWTConstants.accessTokenSecretKeyForUtente);
    }
    return false;
  }

  /// Verifica se un utente con il ruolo di CA è autorizzato in base al token JWT fornito.
  ///
  /// Utilizza `JWTUtils` per verificare il token.
  @override
  Future<bool> checkUserCA(var token) async {
    if (token != null) {
      return JWTUtils.verifyAccessToken(
          accessToken: await token,
          secretKey: JWTConstants.accessTokenSecretKeyForCA);
    }
    return false;
  }

  /// Verifica se un utente con il ruolo di ADS è autorizzato in base al token JWT fornito.
  ///
  /// Utilizza `JWTUtils` per verificare il token.
  @override
  Future<bool> checkUserADS(var token) async {
    if (token != null) {
      return JWTUtils.verifyAccessToken(
          accessToken: await token,
          secretKey: JWTConstants.accessTokenSecretKeyForADS);
    }
    return false;
  }
}
