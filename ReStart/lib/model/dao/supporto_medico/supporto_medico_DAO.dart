
import '../../entity/supporto_medico_DTO.dart';

/// Questa classe rappresenta il dao del Supporto Medico
abstract class SupportoMedicoDAO {
  Future<bool> add(SupportoMedicoDTO sm);
  Future<bool> existById(int id);
  Future<List<SupportoMedicoDTO>> findAll();
  Future<SupportoMedicoDTO?> findById(int id);
  Future<bool> removeById(int id);
  Future<bool> update(SupportoMedicoDTO sm);
}