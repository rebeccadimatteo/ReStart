import '../../../model/dao/annuncio_di_lavoro/annuncio_di_lavoro_DAO.dart';
import '../../../model/dao/annuncio_di_lavoro/annuncio_di_lavoro_DAO_impl.dart';
import '../../../model/dao/autenticazione/utente/utente_DAO.dart';
import '../../../model/dao/autenticazione/utente/utente_DAO_impl.dart';
import '../../../model/dao/candidatura_lavoro/candidatura_DAO.dart';
import '../../../model/dao/candidatura_lavoro/candidatura_DAO_impl.dart';
import '../../../model/entity/candidatura_DTO.dart';
import 'candidatura_service.dart';

class CandidaturaServiceImpl implements CandidaturaService {
  final AnnuncioDiLavoroDAO _annuncioDiLavoroDAO;
  final UtenteDAO _utenteDAO;
  final CandidaturaDAO _candidaturaDAO;

  CandidaturaServiceImpl()
      : _utenteDAO = UtenteDAOImpl(),
        _annuncioDiLavoroDAO = AnnuncioLavoroDAOImpl(),
        _candidaturaDAO = CandidaturaDAOImpl();

  @override
  Future<bool> candidatura(int? idUtente, int? idLavoro) async {
    if (_annuncioDiLavoroDAO.existById(idLavoro!) == false ||
        _utenteDAO.existById(idUtente!) == false) {
      return false;
    }

    if (await _candidaturaDAO.existCandidatura(idUtente, idLavoro)) {
      return false;
    }

    CandidaturaDTO candidaturaDTO =
        CandidaturaDTO(id_lavoro: idLavoro, id_utente: idUtente);
    return _candidaturaDAO.add(candidaturaDTO);
  }
}
