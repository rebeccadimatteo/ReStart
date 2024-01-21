import '../../../model/entity/utente_DTO.dart';

/// Interfaccia per il service di autenticazione.
///
/// Definisce i metodi necessari per gestire l'autenticazione e le operazioni
/// correlate agli utenti.
abstract class AutenticazioneService {
  /// Effettua il login di un utente.
  ///
  /// Accetta come parametri il nome utente e la password.
  /// Restituisce un oggetto dinamico che può essere un DTO di utente o null in caso di fallimento.
  Future<dynamic> login(String user, String psw);

  /// Elimina un utente specificato dal suo username.
  ///
  /// Restituisce `true` se l'eliminazione ha successo, altrimenti `false`.
  Future<bool> deleteUtente(String username);

  /// Fornisce un elenco di tutti gli utenti.
  ///
  /// Restituisce una lista di oggetti `UtenteDTO` contenenti i dettagli degli utenti.
  Future<List<UtenteDTO>> listaUtenti();

  /// Modifica i dettagli di un utente.
  ///
  /// Accetta un oggetto `UtenteDTO` con i dettagli aggiornati dell'utente.
  /// Restituisce `true` se la modifica ha successo, altrimenti `false`.
  Future<bool> modifyUtente(UtenteDTO u);

  /// Visualizza i dettagli di un utente specificato dal suo username.
  ///
  /// Restituisce un oggetto `UtenteDTO` contenente i dettagli dell'utente o null se non trovato.
  Future<UtenteDTO?> visualizzaUtente(String username);

  /// Verifica se un utente è autorizzato in base al token fornito.
  ///
  /// Accetta un token JWT e restituisce `true` se l'utente è autorizzato, altrimenti `false`.
  Future<bool> checkUserUtente(var token);

  /// Verifica se un utente con il ruolo di ADS è autorizzato in base al token fornito.
  ///
  /// Accetta un token JWT e restituisce `true` se l'ADS è autorizzato, altrimenti `false`.
  Future<bool> checkUserADS(var token);

  /// Verifica se un utente con il ruolo di CA è autorizzato in base al token fornito.
  ///
  /// Accetta un token JWT e restituisce `true` se il CA è autorizzato, altrimenti `false`.
  Future<bool> checkUserCA(var token);
}
