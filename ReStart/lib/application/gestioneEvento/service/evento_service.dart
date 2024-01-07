import 'dart:async';

import '../../../model/entity/evento_DTO.dart';


abstract class EventoService {
  Future<List<EventoDTO>> communityEvents();
  // Future<EventoDTO?> detailsEvento(int id);
  // Future<List<EventoDTO>> eventiPubblicati(String usernameCa);
  // Future<bool> addEvento(EventoDTO e);
  // Future<bool> deleteEvento(int id);
  // Future<bool> modifyEvento(EventoDTO e);
  // Future<bool> approveEvento(EventoDTO e);
  // Future<bool> rejectEvento(EventoDTO e);
}