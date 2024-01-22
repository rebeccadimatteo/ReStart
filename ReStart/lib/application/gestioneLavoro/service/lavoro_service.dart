import '../../../model/entity/annuncio_di_lavoro_DTO.dart';
import '../../../model/entity/utente_DTO.dart';

/// Interfaccia per il service di gestione degli annunci di lavoro.
///
/// Definisce i metodi per la manipolazione e il recupero degli annunci di lavoro,
/// incluso l'aggiunta, la modifica, l'approvazione, il rifiuto e la visualizzazione degli annunci.
abstract class LavoroService {
  /// Restituisce un elenco di tutte le offerte di lavoro disponibili.
  ///
  /// Utilizza per ottenere un elenco completo di annunci di lavoro attivi.
  Future<List<AnnuncioDiLavoroDTO>> offerteLavoro();

  /// Restituisce un elenco di offerte di lavoro pubblicate da un utente CA specifico.
  ///
  /// Accetta lo username del CA e restituisce gli annunci di lavoro pubblicati da quel CA.
  Future<List<AnnuncioDiLavoroDTO>> offertePubblicate(String usernameCa);

  /// Aggiunge un nuovo annuncio di lavoro al sistema.
  ///
  /// Prende in input un oggetto [AnnuncioDiLavoroDTO] contenente i dettagli dell'annuncio da aggiungere.
  Future<bool> addLavoro(AnnuncioDiLavoroDTO annuncio);

  /// Modifica un annuncio di lavoro esistente.
  ///
  /// Prende in input un oggetto [AnnuncioDiLavoroDTO] aggiornato e applica le modifiche.
  Future<bool> modifyLavoro(AnnuncioDiLavoroDTO annuncio);

  /// Elimina un annuncio di lavoro specificato dal suo ID.
  ///
  /// Accetta l'ID dell'annuncio da eliminare.
  Future<bool> deleteLavoro(int id);

  /// Restituisce un elenco di utenti che si sono candidati per un annuncio di lavoro specifico.
  ///
  /// Prende in input un oggetto [AnnuncioDiLavoroDTO] e restituisce gli utenti candidati.
  Future<List<UtenteDTO?>?> utentiCandidati(AnnuncioDiLavoroDTO annuncio);

  /// Approva un annuncio di lavoro specificato dal suo ID.
  ///
  /// Accetta l'ID dell'annuncio di lavoro e lo segna come approvato.
  Future<String> approveLavoro(int id_annuncio);

  /// Rifiuta un annuncio di lavoro specificato dal suo ID.
  ///
  /// Accetta l'ID dell'annuncio di lavoro e lo segna come rifiutato.
  Future<String> rejectLavoro(int id_annuncio);

  /// Restituisce un elenco di annunci di lavoro che sono stati approvati.
  ///
  /// Utilizza per ottenere gli annunci di lavoro che hanno ricevuto l'approvazione.
  Future<List<AnnuncioDiLavoroDTO>> annunciApprovati();

  /// Restituisce un elenco di richieste di annunci di lavoro in attesa di approvazione.
  ///
  /// Utilizza per ottenere gli annunci di lavoro che sono ancora in attesa di approvazione.
  Future<List<AnnuncioDiLavoroDTO>> richiesteAnnunci();
}
