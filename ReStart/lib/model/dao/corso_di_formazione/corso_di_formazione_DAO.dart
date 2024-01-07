
import '../../entity/corso_di_formazione_DTO.dart';

/// Questa classe rappresenta il dao del corso di formazione
abstract class CorsoDiFormazioneDAO{
  
  // Future<bool> add(CorsoDiFormazioneDTO cf);
  Future<bool> existById(int id);
  Future<List<CorsoDiFormazioneDTO>> findAll();
  Future<CorsoDiFormazioneDTO?> findById(int id);
  Future<bool> removeById(int id);
  Future<bool> update(CorsoDiFormazioneDTO cf);
}