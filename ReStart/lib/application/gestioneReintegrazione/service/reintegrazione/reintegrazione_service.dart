import 'dart:async';

import '../../../../model/entity/corso_di_formazione_DTO.dart';


abstract class ReintegrazioneService {

  Future<List<CorsoDiFormazioneDTO>> getListaCorsi();

  }