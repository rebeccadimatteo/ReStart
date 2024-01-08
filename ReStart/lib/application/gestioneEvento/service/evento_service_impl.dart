import 'dart:async';

import '../../../model/dao/autenticazione/CA/ca_DAO.dart';
import '../../../model/dao/autenticazione/CA/ca_DAO_impl.dart';
import '../../../model/dao/evento/evento_DAO.dart';
import '../../../model/dao/evento/evento_DAO_impl.dart';
import '../../../model/entity/ca_DTO.dart';
import '../../../model/entity/evento_DTO.dart';
import 'evento_service.dart';


class EventoServiceImpl implements EventoService {
  final EventoDAO _eventoDAO;
  final CaDAO _caDAO;

  EventoServiceImpl()
      : _eventoDAO = EventoDAOImpl(),
        _caDAO = CaDAOImpl();

  EventoDAO get eventoDAO => _eventoDAO;
  CaDAO get caDAO => _caDAO;

  @override
  Future<List<EventoDTO>> communityEvents() {
    return _eventoDAO.findAll();
  }

  @override
  Future<bool> modifyEvento (EventoDTO e) {
    return _eventoDAO.update(e);
  }

  @override
  Future<EventoDTO?> detailsEvento(int id) {
    return _eventoDAO.findById(id);
  }

}