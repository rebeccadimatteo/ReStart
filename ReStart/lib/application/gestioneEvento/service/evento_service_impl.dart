import 'dart:async';

import '../../../model/dao/autenticazione/CA/ca_DAO.dart';
import '../../../model/dao/autenticazione/CA/ca_DAO_impl.dart';
import '../../../model/dao/evento/evento_DAO.dart';
import '../../../model/dao/evento/evento_DAO_impl.dart';
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
  Future<bool> addEvento(EventoDTO e) async {
    return _eventoDAO.add(e);
  }

  @override
  Future<bool> deleteEvento(int id) {
    return _eventoDAO.removeById(id);
  }

  @override
  Future<List<EventoDTO>> communityEvents() {
    removeEventiScaduti();
    return _eventoDAO.findAll();
  }

  @override
  Future<bool> modifyEvento(EventoDTO e) {
    return _eventoDAO.update(e);
  }

  @override
  Future<List<EventoDTO>> eventiSettimanali() async {
    List<EventoDTO> list = await _eventoDAO.findAll();

    // Controlla se la data dell'evento è nella settimana corrente
    for (EventoDTO e in list) {
      if (e.date.isBefore(DateTime.now().add(const Duration(days: 7)))) {
        list.remove(e);
      }
    }

    return list;
  }

  @override
  Future<String> approveEvento(int idEvento) async {

    if (await _eventoDAO.existById(idEvento) == false) return "L'evento non esiste";

    EventoDTO? evento = await _eventoDAO.findById(idEvento);

    evento?.approvato = true;

    if (await _eventoDAO.update(evento)) return "Approvazione effettuata";

    return "Approvazione fallita";
  }

  @override
  Future<List<EventoDTO>> eventiPubblicati(String usernameCa) {
    return _eventoDAO.findByApprovato(usernameCa);
  }

  @override
  Future<List<EventoDTO>> richiesteEventi() {
    return _eventoDAO.findByNotAppovato();
  }

  @override
  Future<String> rejectEvento(int idEvento) async {

    if (await _eventoDAO.existById(idEvento) == false) return "L'evento non esiste";

    if (await _eventoDAO.removeById(idEvento)) return "Rifiuto effettuato";

    return "fallito";
  }

  @override
  Future<bool> removeEventiScaduti() {
    return _eventoDAO.removeEventiScaduti();
  }
}
