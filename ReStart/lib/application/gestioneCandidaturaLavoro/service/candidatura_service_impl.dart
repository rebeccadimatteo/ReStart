import '../../../model/entity/utente_DTO.dart';
import '../../../model/dao/annuncio_di_lavoro/annuncio_di_lavoro_DAO.dart';
import '../../../model/dao/annuncio_di_lavoro/annuncio_di_lavoro_DAO_impl.dart';
import '../../../model/dao/autenticazione/utente/utente_DAO.dart';
import '../../../model/dao/autenticazione/utente/utente_DAO_impl.dart';
import '../../../model/dao/candidatura_lavoro/candidatura_DAO.dart';
import '../../../model/dao/candidatura_lavoro/candidatura_DAO_impl.dart';
import '../../../model/entity/candidatura_DTO.dart';
import 'candidatura_service.dart';

/// Implementazione del service di gestione delle candidature.
///
/// Fornisce l'implementazione concreta dei metodi definiti nell'interfaccia
/// `CandidaturaService`. Interagisce con DAO per l'accesso ai dati relativi
/// agli annunci di lavoro, agli utenti e alle candidature.
class CandidaturaServiceImpl implements CandidaturaService {
  /// DAO per la gestione degli annunci di lavoro.
  final AnnuncioDiLavoroDAO _annuncioDiLavoroDAO;

  /// DAO per la gestione degli utenti.
  final UtenteDAO _utenteDAO;

  /// DAO per la gestione delle candidature.
  final CandidaturaDAO _candidaturaDAO;

  /// Costruttore che inizializza i DAO necessari.
  CandidaturaServiceImpl()
      : _utenteDAO = UtenteDAOImpl(),
        _annuncioDiLavoroDAO = AnnuncioDiLavoroDAOImpl(),
        _candidaturaDAO = CandidaturaDAOImpl();

  /// Gestisce la candidatura di un utente a un lavoro specifico.
  ///
  /// Verifica l'esistenza dell'utente e del lavoro e registra la candidatura.
  /// Restituisce una stringa che indica l'esito dell'operazione.
  @override
  Future<String> candidatura(String username, int? idLavoro) async {
    UtenteDTO? utente = await _utenteDAO.findByUsername(username);

    if (utente == null) {
      return "Utente non trovato"; // non è stato possibile trovare l'utente
    }

    if (await _annuncioDiLavoroDAO.existById(idLavoro!) == false) {
      return "Lavoro non esistente"; // il lavoro già esiste
    }

    if (await _candidaturaDAO.existCandidatura(utente.id, idLavoro)) {
      return "Candidatura esistente"; // la candidatura già esiste
    }

    CandidaturaDTO candidaturaDTO =
        CandidaturaDTO(id_lavoro: idLavoro, id_utente: utente.id);

    if (await _candidaturaDAO.add(candidaturaDTO)) {
      return "Candidatura effettuata";
    }

    return "fallito";
  }

  /// Fornisce un elenco di candidati per un determinato lavoro.
  ///
  /// Recupera la lista dei candidati tramite `CandidaturaDAO`.
  /// Restituisce una lista di oggetti `UtenteDTO` che rappresentano i candidati.
  @override
  Future<List<UtenteDTO>> listaCandidati(int idLavoro) {
    return _candidaturaDAO.findCandidati(idLavoro);
  }
}
