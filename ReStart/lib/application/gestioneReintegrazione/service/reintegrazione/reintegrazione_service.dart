import 'dart:async';
import '../../../../model/entity/corso_di_formazione_DTO.dart';
import '../../../../model/entity/supporto_medico_DTO.dart';

abstract class ReintegrazioneService {
  Future<List<CorsoDiFormazioneDTO>> getListaCorsi();
  Future<List<SupportoMedicoDTO>> supportiMedici();
  Future<List<AlloggioTemporaneoDTO>> alloggiTemporanei();
}
