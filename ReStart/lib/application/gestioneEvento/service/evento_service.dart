import 'dart:async';

import '../../../model/entity/evento_DTO.dart';

/// Interfaccia per il service di gestione degli eventi.
///
/// Definisce i metodi per operazioni quali aggiunta, modifica, eliminazione,
/// approvazione, rifiuto e visualizzazione di eventi.
abstract class EventoService {
  /// Restituisce un elenco di eventi della community.
  ///
  /// Interroga i DAO per recuperare tutti gli eventi disponibili.
  Future<List<EventoDTO>> communityEvents();

  /// Restituisce un elenco di eventi pubblicati da un CA specifico.
  ///
  /// Accetta lo username dell'utente CA e restituisce gli eventi pubblicati da quel CA.
  Future<List<EventoDTO>> eventiPubblicati(String usernameCa);

  /// Aggiunge un nuovo evento al sistema.
  ///
  /// Prende in input un oggetto `EventoDTO` e lo passa al DAO per salvarlo nel DB.
  Future<bool> addEvento(EventoDTO e);

  /// Elimina un evento specificato dal suo ID.
  ///
  /// Accetta l'ID dell'evento da eliminare e lo passa al DAO per rimuoverlo dal database.
  Future<bool> deleteEvento(int id);

  /// Modifica i dettagli di un evento esistente.
  ///
  /// Prende un oggetto `EventoDTO` aggiornato e lo passa al DAO per modificarlo nel DB.
  Future<bool> modifyEvento(EventoDTO e);

  /// Restituisce un elenco di richieste di eventi in attesa di approvazione.
  ///
  /// Trova tutti gli eventi che attendono approvazione.
  Future<List<EventoDTO>> richiesteEventi();

  /// Restituisce un elenco di eventi pianificati per la settimana corrente.
  ///
  /// Filtra gli eventi per quelli programmato nella settimana corrente.
  Future<List<EventoDTO>> eventiSettimanali();

  /// Restituisce un elenco di eventi che sono stati approvati.
  ///
  /// Filtra tutti gli eventi che hanno ricevuto l'approvazione.
  Future<List<EventoDTO>> eventiApprovati();

  /// Rimuove gli eventi scaduti dal sistema.
  ///
  /// Elimina tutti gli eventi la cui data è passata.
  Future<bool> removeEventiScaduti();

  /// Approva un evento specificato dal suo ID.
  ///
  /// Accetta l'ID di un evento e lo segna come approvato.
  Future<String> approveEvento(int id_evento);

  /// Rifiuta un evento specificato dal suo ID.
  ///
  /// Accetta l'ID di un evento e lo elimina.
  Future<String> rejectEvento(int id_evento);
}
