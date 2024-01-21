import '../../entity/utente_DTO.dart';

/// Interfaccia per il Data Access Object (DAO) del Lavoro Adatto.
///
/// Definisce i metodi per la gestione del lavoro adatto nel database.
abstract class LavoroAdattoDAO {
  /// Aggiorna il lavoro adatto per un utente specifico.
  ///
  /// Prende in input una stringa [lavoroAdatto] che rappresenta il titolo del lavoro adatto
  /// e un oggetto [UtenteDTO] per identificare l'utente a cui aggiornare il lavoro adatto.
  /// Restituisce [true] se l'aggiornamento è andato a buon fine, altrimenti [false].
  Future<bool> update(String lavoroAdatto, UtenteDTO u);
}
