import '../../../entity/ca_DTO.dart';

/// Questa classe rappresenta il DAO del CA
abstract class CaDAO {
  Future<bool> add(CaDTO ca);
  Future<bool> existById(int id);
  Future<bool> existByUsername(String username);
  Future<List<CaDTO>> findAll();
  Future<CaDTO?> findById(int id);
  Future<CaDTO?> findByUsername(String username);
  Future<bool> removeById(int id);
  Future<bool> removeByUsername(String username);
  Future<bool> update(CaDTO ca);
}