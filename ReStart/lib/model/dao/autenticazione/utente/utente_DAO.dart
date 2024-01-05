import '../../../entity/utente_DTO.dart';

/// Questa classe rappresenta il DAO dell'Utente
abstract class UtenteDAO {
  Future<bool> add(UtenteDTO a);
  Future<bool> existById(int id);
  Future<bool> existByUsername(String username);
  Future<List<UtenteDTO>> findAll();
  Future<UtenteDTO?> findById(int id);
  Future<UtenteDTO?> findByUsername(String username);
  Future<bool> removeById(int id);
  Future<bool> removeByUsername(String username);
  Future<bool> update(UtenteDTO a);
}
