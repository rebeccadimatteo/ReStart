import '../../entity/alloggio_temporaneo_DTO.dart';

/// Interfaccia per il Data Access Object (DAO) degli alloggi temporanei.
///
/// Definisce i metodi per la gestione degli alloggi temporanei nel database.
abstract class AlloggioTemporaneoDAO {
  /// Aggiunge un nuovo alloggio temporaneo al database.
  ///
  /// Accetta un oggetto [AlloggioTemporaneoDTO] contenente i dettagli dell'alloggio da aggiungere.
  Future<bool> add(AlloggioTemporaneoDTO at);

  /// Verifica l'esistenza di un alloggio temporaneo in base al suo ID.
  ///
  /// Restituisce [true] se l'alloggio esiste, altrimenti [false].
  Future<bool> existById(int id);

  /// Restituisce un elenco di tutti gli alloggi temporanei.
  ///
  /// Restituisce una lista di oggetti [AlloggioTemporaneoDTO].
  Future<List<AlloggioTemporaneoDTO>> findAll();

  /// Trova un alloggio temporaneo in base al suo ID.
  ///
  /// Restituisce un oggetto [AlloggioTemporaneoDTO] se trovato, altrimenti `null`.
  Future<AlloggioTemporaneoDTO?> findById(int id);

  /// Rimuove un alloggio temporaneo in base al suo ID.
  ///
  /// Restituisce [true] se l'alloggio è stato rimosso con successo, altrimenti [false].
  Future<bool> removeById(int id);

  /// Aggiorna i dettagli di un alloggio temporaneo esistente.
  ///
  /// Prende in input un oggetto [AlloggioTemporaneoDTO] aggiornato.
  Future<bool> update(AlloggioTemporaneoDTO at);
}
