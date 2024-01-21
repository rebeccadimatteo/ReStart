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

/// Implementazione del service di gestione degli annunci di lavoro.
///
/// Fornisce l'implementazione concreta dei metodi definiti nell'interfaccia `LavoroService`.
/// Interagisce con i DAO per l'accesso e la manipolazione dei dati relativi agli annunci di lavoro.
class LavoroServiceImpl implements LavoroService {
  /// DAO per la gestione degli annunci di lavoro.
  final AnnuncioDiLavoroDAO _lavoroDAO;

  /// DAO per la gestione dei CA
  final CaDAO _caDAO;

  /// DAO per la gestione degli utenti.
  final UtenteDAO _utenteDAO;

  /// Costruttore che inizializza i DAO necessari per la gestione degli annunci di lavoro.
  LavoroServiceImpl()
      : _lavoroDAO = AnnuncioDiLavoroDAOImpl(),
        _caDAO = CaDAOImpl(),
        _utenteDAO = UtenteDAOImpl();

  AnnuncioDiLavoroDAO get lavoroDAO => _lavoroDAO;

  CaDAO get caDAO => _caDAO;

  UtenteDAO get utenteDAO => _utenteDAO;

  /// Aggiunge un nuovo annuncio di lavoro al sistema.
  ///
  /// Accetta un oggetto [AnnuncioDiLavoroDTO] contenente i dettagli dell'annuncio da aggiungere.
  @override
  Future<bool> addLavoro(AnnuncioDiLavoroDTO annuncio) {
    return _lavoroDAO.add(annuncio);
  }

  /// Approva un annuncio di lavoro specificato dal suo ID.
  ///
  /// Verifica l'esistenza dell'annuncio e, in caso affermativo, lo segna come approvato.
  @override
  Future<String> approveLavoro(int idAnnuncio) async {
    if (await _lavoroDAO.existById(idAnnuncio) == false) {
      return "L'annuncio di lavoro non esiste";
    }
    AnnuncioDiLavoroDTO? lavoro = await _lavoroDAO.findById(idAnnuncio);

    if (lavoro == null) return "Evento non trovato";

    lavoro.approvato = true;

    if (await _lavoroDAO.update(lavoro)) return "Approvazione effettuata";

    return "fallito";
  }

  /// Elimina un annuncio di lavoro specificato dal suo ID.
  ///
  /// Accetta l'ID dell'annuncio da eliminare.
  @override
  Future<bool> deleteLavoro(int id) {
    return _lavoroDAO.removeById(id);
  }

  /// Modifica un annuncio di lavoro esistente.
  ///
  /// Prende in input un oggetto [AnnuncioDiLavoroDTO] aggiornato e applica le modifiche.
  @override
  Future<bool> modifyLavoro(AnnuncioDiLavoroDTO annuncio) {
    return _lavoroDAO.update(annuncio);
  }

  /// Restituisce un elenco di tutte le offerte di lavoro disponibili.
  ///
  /// Recupera e restituisce un elenco completo di annunci di lavoro attivi.
  @override
  Future<List<AnnuncioDiLavoroDTO>> offerteLavoro() {
    return _lavoroDAO.findAll();
  }

  /// Restituisce un elenco di offerte di lavoro pubblicate da un CA specifico.
  ///
  /// Filtra gli annunci in base al nome utente del CA.
  @override
  Future<List<AnnuncioDiLavoroDTO>> offertePubblicate(String usernameCA) {
    return _lavoroDAO.findByApprovato(usernameCA);
  }

  /// Restituisce un elenco di annunci di lavoro che sono stati approvati.
  ///
  /// Filtra gli annunci in base allo stato di approvazione.
  @override
  Future<List<AnnuncioDiLavoroDTO>> annunciApprovati() async {
    List<AnnuncioDiLavoroDTO> list = await _lavoroDAO.findAll();

    // Controlla se l'evento è stato approvato altrimenti non deve essere visualizzato
    var itemsToRemove = <AnnuncioDiLavoroDTO>[];
    for (var a in list) {
      if (!a.approvato) {
        itemsToRemove.add(a);
      }
    }
    list.removeWhere((e) => itemsToRemove.contains(e));

    return list;
  }

  /// Rifiuta un annuncio di lavoro specificato dal suo ID.
  ///
  /// Verifica l'esistenza dell'annuncio e, in caso affermativo, lo rimuove.
  @override
  Future<String> rejectLavoro(int idAnnuncio) async {
    if (await _lavoroDAO.existById(idAnnuncio) == false) {
      return "L'annuncio di lavoro non esiste";
    }

    if (await _lavoroDAO.removeById(idAnnuncio)) return "Rifiuto effettuato";

    return "fallito";
  }

  /// Restituisce un elenco di utenti che si sono candidati per un annuncio di lavoro specifico.
  ///
  /// Prende un oggetto [AnnuncioDiLavoroDTO] e restituisce gli utenti candidati.
  @override
  Future<List<UtenteDTO?>?> utentiCandidati(
      AnnuncioDiLavoroDTO annuncio) async {
    CandidaturaDAO candidaturaDAO = CandidaturaDAOImpl();
    List<CandidaturaDTO> candidature = await candidaturaDAO.findAll();
    List<UtenteDTO?>? userCandidati = [];
    for (CandidaturaDTO c in candidature) {
      if (c.id_lavoro == annuncio.id) {
        userCandidati.add(await utenteDAO.findById(c.id_utente));
      }
    }
    return userCandidati;
  }

  /// Restituisce un elenco di richieste di annunci di lavoro in attesa di approvazione.
  ///
  /// Recupera gli annunci di lavoro che sono ancora in attesa di approvazione.
  @override
  Future<List<AnnuncioDiLavoroDTO>> richiesteAnnunci() {
    return lavoroDAO.findByNotApprovato();
  }
}
