import '../../entity/evento_DTO.dart';

abstract class EventoDAO {
  /// Metodo che permette l'aggiunta di un evento
  Future<bool> add(EventoDTO e);
  /// Metodo che verifica se un evento esiste, dato il suo id
  Future<bool> existById(int? id);
  /// Metodo che permette di ottenere la lista di tutti gli eventi presenti nel sistema
  Future<List<EventoDTO>> findAll();
  /// Metodo che permette di trovare un evento dato il suo id
  Future<EventoDTO?> findById(int id);
  /// Metodo che permette la rimozione di evento dato il suo id
  Future<bool> removeById(int? id);
  /// Metodo che permette la modifica dei dati di un evento
  Future<bool> update(EventoDTO? e);
  ///Metodo che permette la ricerca di tutti gli eventi approvati da un Ca
  Future<List<EventoDTO>> findByApprovato(String usernameCa);
  ///Metodo che permette la ricerca di tutti gli eventi non ancora approvati da un Ca
  Future<List<EventoDTO>> findByNotAppovato();
}