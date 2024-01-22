import '../../../model/entity/utente_DTO.dart';

/// Interfaccia per il service di gestione delle candidature.
///
/// Definisce i metodi necessari per gestire le operazioni relative alle candidature
/// per i lavori, inclusa la candidatura degli utenti e la ricerca dei candidati.
abstract class CandidaturaService {
  /// Registra la candidatura di un utente per un lavoro specifico.
  ///
  /// Accetta lo username dell'utente e l'ID opzionale del lavoro.
  /// Restituisce una stringa che descrive il risultato dell'operazione.
  Future<String> candidatura(String username, int? idLavoro);

  /// Fornisce un elenco di candidati per un determinato lavoro.
  ///
  /// Accetta l'ID del lavoro e restituisce una lista di oggetti `UtenteDTO`
  /// che rappresentano i candidati.
  Future<List<UtenteDTO>> listaCandidati(int idLavoro);
}
