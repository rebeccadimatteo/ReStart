import '../../entity/candidatura_DTO.dart';

/// Questa classe rappresenta l'implementazione del dao della Candidatura
abstract class CandidaturaDAO {
  Future<bool> add(CandidaturaDTO ca);

  Future<bool> existByIdUtente(int id_utente);

  Future<bool> existByIdLavoro(int id_lavoro);

  Future<bool> existCandidatura(int? id_utente, int? id_lavoro);

  Future<List<CandidaturaDTO>> findAll();

  Future<CandidaturaDTO?> findByIdUtente(int id_utente);

  Future<CandidaturaDTO?> findByIdLavoro(int id_lavoro);

  Future<bool> removeById(int id_lavoro, int id_utente);
}
