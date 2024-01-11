import '../../entity/annuncio_di_lavoro_DTO.dart';

/// Questa classe definisce le operazioni necessarie per gestire gli annunci di lavoro nel database.
/// Le implementazioni concrete di questa classe devono fornire funzionalità per aggiungere, cercare,
/// aggiornare e rimuovere annunci di lavoro.
abstract class AnnuncioDiLavoroDAO {
  /// Recupera tutti gli annunci di lavoro presenti nel database.
  Future<List<AnnuncioDiLavoroDTO>> findAll();

  /// Aggiunge un nuovo annuncio di lavoro al database.
  /// Restituisce true se l'operazione di aggiunta ha avuto successo, altrimenti false.
  Future<bool> add(AnnuncioDiLavoroDTO annuncioDiLavoro);

  /// Verifica se un annuncio di lavoro con l'ID specificato esiste nel database.
  Future<bool> existById(int? id);

  /// Cerca un annuncio di lavoro nel database tramite il suo ID.
  /// Restituisce l'annuncio di lavoro se trovato, altrimenti null.
  Future<AnnuncioDiLavoroDTO?> findById(int id);

  /// Aggiorna le informazioni di un annuncio di lavoro nel database.
  /// Restituisce true se l'operazione di aggiornamento ha avuto successo, altrimenti false.
  Future<bool> update(AnnuncioDiLavoroDTO? annuncioDiLavoro);

  /// Rimuove un annuncio di lavoro dal database utilizzando l'ID specificato.
  /// Restituisce true se l'operazione di rimozione ha avuto successo, altrimenti false.
  Future<bool> removeById(int? id);

  Future<List<AnnuncioDiLavoroDTO>> findByNotApprovato();

  Future<List<AnnuncioDiLavoroDTO>> findByApprovato(String usernameCa);
}
