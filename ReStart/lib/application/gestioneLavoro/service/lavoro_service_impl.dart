import '../../../model/dao/annuncio_di_lavoro/annuncio_di_lavoro_DAO.dart';
import '../../../model/dao/annuncio_di_lavoro/annuncio_di_lavoro_DAO_impl.dart';
import '../../../model/dao/autenticazione/CA/ca_DAO.dart';
import '../../../model/dao/autenticazione/CA/ca_DAO_impl.dart';
import '../../../model/dao/autenticazione/utente/utente_DAO.dart';
import '../../../model/dao/autenticazione/utente/utente_DAO_impl.dart';
import '../../../model/dao/candidatura_lavoro/candidatura_DAO.dart';
import '../../../model/dao/candidatura_lavoro/candidatura_DAO_impl.dart';
import '../../../model/entity/annuncio_di_lavoro_DTO.dart';
import '../../../model/entity/candidatura_DTO.dart';
import '../../../model/entity/utente_DTO.dart';
import 'lavoro_service.dart';

class LavoroServiceImpl implements LavoroService{
  final AnnuncioDiLavoroDAO _lavoroDAO;
  final CaDAO _caDAO;
  final UtenteDAO _utenteDAO;

  LavoroServiceImpl()

      : _lavoroDAO = AnnuncioDiLavoroDAOImpl(),
        _caDAO = CaDAOImpl(),
        _utenteDAO = UtenteDAOImpl();

  AnnuncioDiLavoroDAO get lavoroDAO => _lavoroDAO;
  CaDAO get caDAO => _caDAO;
  UtenteDAO get utenteDAO => _utenteDAO;

  @override
  Future<bool> addLavoro(AnnuncioDiLavoroDTO annuncio) {
    return _lavoroDAO.add(annuncio);
  }

  @override
  Future<String> approveLavoro(int id_annuncio) async {

    if(await _lavoroDAO.existById(id_annuncio) == false){
      return "L'annuncio di lavoro non esiste";
    }
    AnnuncioDiLavoroDTO? lavoro = await _lavoroDAO.findById(id_annuncio);

    lavoro?.approvato = true;

    if(await _lavoroDAO.update(lavoro)) return "Approvazione effettuata";

    return "fallito";
  }

  @override
  Future<bool> deleteLavoro(int id) {
    return _lavoroDAO.removeById(id);
  }

  @override
  Future<bool> modifyLavoro(AnnuncioDiLavoroDTO annuncio) {
    return _lavoroDAO.update(annuncio);
  }

  @override
  Future<List<AnnuncioDiLavoroDTO>> offerteLavoro() {
    return _lavoroDAO.findAll();
  }

  @override
  Future<List<AnnuncioDiLavoroDTO>> offertePubblicate(String usernameCA) {
    return _lavoroDAO.findByApprovato(usernameCA);
  }

  @override
  Future<List<AnnuncioDiLavoroDTO>> annunciApprovati() async {
    List<AnnuncioDiLavoroDTO> list = await _lavoroDAO.findAll();

    // Controlla se l'evento è stato approvato altrimenti non deve essere visualizzato
    for (AnnuncioDiLavoroDTO a in list) {
      if (!a.approvato) {
        list.remove(a);
      }
    }

    return list;
  }

  @override
  Future<String> rejectLavoro(int id_annuncio) async {

    if(await _lavoroDAO.existById(id_annuncio) == false){
      return "L'annuncio di lavoro non esiste";
    }

    if(await _lavoroDAO.removeById(id_annuncio)) return "Rifiuto effettuato";

    return "fallito";
  }

  @override
  Future<List<UtenteDTO?>?> utentiCandidati(AnnuncioDiLavoroDTO annuncio) async {
    CandidaturaDAO candidaturaDAO = CandidaturaDAOImpl();
    List<CandidaturaDTO> candidature = await candidaturaDAO.findAll();
    List<UtenteDTO?>? userCandidati = [];
    for(CandidaturaDTO c in candidature){
      if(c.id_lavoro == annuncio.id) {
        userCandidati.add(await utenteDAO.findById(c.id_utente));
      }
    }
    return userCandidati;
  }

  @override
  Future<List<AnnuncioDiLavoroDTO>> richiesteAnnunci() {
      return lavoroDAO.findByNotApprovato();
  }
}