import '../../entity/alloggio_temporaneo_DTO.dart';
abstract class AlloggioTemporaneoDAO {
  Future<bool> add(AlloggioTemporaneoDTO at);
  Future<bool> existById(int id);
  Future<List<AlloggioTemporaneoDTO>> findAll();
  Future<AlloggioTemporaneoDTO?> findById(int id);
  Future<bool> removeById(int id);
  Future<bool> update(AlloggioTemporaneoDTO at);
}