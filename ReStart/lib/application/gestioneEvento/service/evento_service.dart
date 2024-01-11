import 'dart:async';

import '../../../model/entity/evento_DTO.dart';

abstract class EventoService {

  Future<List<EventoDTO>> communityEvents();

  Future<List<EventoDTO>> eventiPubblicati(String usernameCa);

  Future<bool> addEvento(EventoDTO e);

  Future<bool> deleteEvento(int id);

  Future<bool> modifyEvento(EventoDTO e);

  Future<String> approveEvento(int id_evento);

  Future<String> rejectEvento(int  id_evento);
}
