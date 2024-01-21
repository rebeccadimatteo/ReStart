import '../../../model/dao/autenticazione/utente/utente_DAO.dart';
import '../../../model/dao/autenticazione/utente/utente_DAO_impl.dart';
import '../../../model/entity/utente_DTO.dart';
import 'registrazione_service.dart';

/// Implementazione del servizio di registrazione degli utenti.
///
/// Fornisce l'implementazione concreta dei metodi definiti nell'interfaccia `RegistrazioneService`.
/// Interagisce con il DAO degli utenti per gestire la registrazione degli utenti sulla piattaforma.
class RegistrazioneServiceImpl implements RegistrazioneService {
  final UtenteDAO _utenteDAO;

  /// Costruttore che inizializza il DAO degli utenti.
  RegistrazioneServiceImpl()
      : _utenteDAO = UtenteDAOImpl();

  /// Registra un nuovo utente sulla piattaforma.
  ///
  /// Accetta un oggetto [UtenteDTO] contenente le informazioni dell'utente.
  /// Interagisce con il DAO degli utenti per registrare l'utente nel sistema.
  /// Restituisce [true] se la registrazione è andata a buon fine, altrimenti [false].
  @override
  Future<bool> signUp(UtenteDTO utente) async {
    return _utenteDAO.add(utente);
  }
}