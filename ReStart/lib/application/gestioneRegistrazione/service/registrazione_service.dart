import '../../../model/entity/utente_DTO.dart';

/// Interfaccia per il service di registrazione degli utenti.
///
/// Definisce il metodo per la registrazione di un utente alla piattaforma.
abstract class RegistrazioneService{

  /// Registra un nuovo utente sulla piattaforma.
  ///
  /// Accetta un oggetto [UtenteDTO] contenente le informazioni dell'utente e
  /// si occupa di eseguire le operazioni necessarie per la sua registrazione.
  ///
  /// Restituisce [true] se la registrazione è andata a buon fine, altrimenti [false].
  Future<bool> signUp(UtenteDTO ug);

}