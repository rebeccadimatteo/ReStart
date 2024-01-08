import 'dart:async';
import '../../../../model/entity/alloggio_temporaneo_DTO.dart';
import '../../../../model/entity/corso_di_formazione_DTO.dart';
import '../../../../model/entity/supporto_medico_DTO.dart';

abstract class ReintegrazioneService {
  Future<List<CorsoDiFormazioneDTO>> corsiDiFormazione();

  Future<List<AlloggioTemporaneoDTO>> alloggiTemporanei();

  Future<List<SupportoMedicoDTO>> supportiMedici();

  Future<bool> addCorso(CorsoDiFormazioneDTO c);

  Future<bool> addSupportoMedico(SupportoMedicoDTO sm);

  Future<bool> addAlloggio(AlloggioTemporaneoDTO at);
}
