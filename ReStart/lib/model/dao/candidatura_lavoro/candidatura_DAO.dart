import '../../entity/utente_DTO.dart';
import '../../entity/candidatura_DTO.dart';

/// Questa classe rappresenta l'implementazione del dao della Candidatura

abstract class CandidaturaDAO {

  Future<bool> add(CandidaturaDTO ca);

  Future<bool> existByIdUtente(int idUtente);

  Future<bool> existByIdLavoro(int idLavoro);

  Future<bool> existCandidatura(int? idUtente, int? idLavoro);

  Future<List<CandidaturaDTO>> findAll();

  Future<CandidaturaDTO?> findByIdUtente(int idUtente);

  Future<CandidaturaDTO?> findByIdLavoro(int idLavoro);

  Future<bool> removeById(int idLavoro, int idUtente);

  Future<List<UtenteDTO>> findCandidati(int idLavoro);
}
