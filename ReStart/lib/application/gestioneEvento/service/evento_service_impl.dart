import 'dart:async';

import '../../../model/dao/autenticazione/CA/ca_DAO.dart';
import '../../../model/dao/autenticazione/CA/ca_DAO_impl.dart';
import '../../../model/dao/evento/evento_DAO.dart';
import '../../../model/dao/evento/evento_DAO_impl.dart';
import '../../../model/entity/evento_DTO.dart';
import 'evento_service.dart';

/// Implementazione del service di gestione degli eventi.
///
/// Fornisce l'implementazione concreta dei metodi definiti nell'interfaccia `EventoService`.
/// Interagisce con i DAO per l'accesso e la manipolazione dei dati relativi agli eventi.
class EventoServiceImpl implements EventoService {
  /// DAO per la gestione degli eventi.
  final EventoDAO _eventoDAO;

  /// DAO per la gestione dei CA.
  final CaDAO _caDAO;

  /// Costruttore che inizializza i DAO necessari.
  EventoServiceImpl()
      : _eventoDAO = EventoDAOImpl(),
        _caDAO = CaDAOImpl();

  EventoDAO get eventoDAO => _eventoDAO;

  CaDAO get caDAO => _caDAO;

  /// Aggiunge un nuovo evento al sistema.
  ///
  /// Accetta un oggetto [EventoDTO] contenente i dettagli dell'evento da aggiungere.
  /// Restituisce [true] se l'aggiunta è andata a buon fine, altrimenti [false].
  @override
  Future<bool> addEvento(EventoDTO e) async {
    return _eventoDAO.add(e);
  }

  /// Elimina un evento specificato dal suo ID.
  ///
  /// Accetta l'ID dell'evento da eliminare.
  /// Restituisce [true] se l'eliminazione è andata a buon fine, altrimenti [false].
  @override
  Future<bool> deleteEvento(int id) {
    return _eventoDAO.removeById(id);
  }

  /// Restituisce un elenco di tutti gli eventi nella community.
  ///
  /// Prima rimuove gli eventi scaduti, quindi recupera e restituisce tutti gli eventi.
  @override
  Future<List<EventoDTO>> communityEvents() async {
    await removeEventiScaduti();
    return _eventoDAO.findAll();
  }

  /// Modifica un evento esistente.
  ///
  /// Accetta un oggetto [EventoDTO] con i dettagli dell'evento aggiornati.
  /// Restituisce [true] se la modifica è andata a buon fine, altrimenti [false].
  @override
  Future<bool> modifyEvento(EventoDTO e) {
    return _eventoDAO.update(e);
  }

  /// Restituisce un elenco di eventi pianificati per la settimana corrente.
  ///
  /// Filtra gli eventi in base alla data corrente, restituendo solo quelli della settimana in corso.
  @override
  Future<List<EventoDTO>> eventiSettimanali() async {
    List<EventoDTO> list = await _eventoDAO.findAll();

    // Rimuove tutti gli eventi la cui data è precedente a quella odierna
    list.removeWhere((e) => e.date.isBefore(DateTime.now()));

    return list;
  }

  /// Restituisce un elenco di eventi che sono stati approvati.
  ///
  /// Filtra gli eventi in base allo stato di approvazione.
  @override
  Future<List<EventoDTO>> eventiApprovati() async {
    List<EventoDTO> list = await _eventoDAO.findAll();

    // Controlla se l'evento è stato approvato altrimenti non deve essere visualizzato
    var itemsToRemove = <EventoDTO>[];
    for (var e in list) {
      if (!e.approvato) {
        itemsToRemove.add(e);
      }
    }
    list.removeWhere((e) => itemsToRemove.contains(e));

    return list;
  }

  /// Approva un evento specificato dal suo ID.
  ///
  /// Verifica l'esistenza dell'evento e, in caso affermativo, lo segna come approvato.
  @override
  Future<String> approveEvento(int idEvento) async {
    if (await _eventoDAO.existById(idEvento) == false) {
      return "L'evento non esiste";
    }

    EventoDTO? evento = await _eventoDAO.findById(idEvento);

    if (evento == null) return "Evento non trovato";

    evento.approvato = true;

    if (await _eventoDAO.update(evento)) return "Approvazione effettuata";

    return "Approvazione fallita";
  }

  /// Restituisce un elenco di eventi pubblicati da un specifico utente CA.
  ///
  /// Filtra gli eventi in base al nome utente del CA.
  @override
  Future<List<EventoDTO>> eventiPubblicati(String usernameCa) {
    return _eventoDAO.findByApprovato(usernameCa);
  }

  /// Restituisce un elenco di richieste di eventi in attesa di approvazione.
  ///
  /// Recupera gli eventi che non sono ancora stati approvati.
  @override
  Future<List<EventoDTO>> richiesteEventi() {
    return _eventoDAO.findByNotAppovato();
  }

  /// Rifiuta un evento specificato dal suo ID.
  ///
  /// Verifica l'esistenza dell'evento e, in caso affermativo, lo rimuove.
  @override
  Future<String> rejectEvento(int idEvento) async {
    if (await _eventoDAO.existById(idEvento) == false) {
      return "L'evento non esiste";
    }

    if (await _eventoDAO.removeById(idEvento)) return "Rifiuto effettuato";

    return "fallito";
  }

  /// Rimuove gli eventi scaduti dal sistema.
  ///
  /// Elimina tutti gli eventi la cui data è passata.
  @override
  Future<bool> removeEventiScaduti() {
    return _eventoDAO.removeEventiScaduti();
  }
}
