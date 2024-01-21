import 'dart:async';
import '../../../../model/dao/alloggio_temporaneo/alloggio_temporaneo_DAO.dart';
import '../../../../model/dao/alloggio_temporaneo/alloggio_temporaneo_DAO_impl.dart';
import '../../../../model/dao/corso_di_formazione/corso_di_formazione_DAO.dart';
import '../../../../model/dao/corso_di_formazione/corso_di_formazione_DAO_impl.dart';
import '../../../../model/dao/supporto_medico/supporto_medico_DAO.dart';
import '../../../../model/dao/supporto_medico/supporto_medico_DAO_impl.dart';
import '../../../../model/entity/alloggio_temporaneo_DTO.dart';
import '../../../../model/entity/supporto_medico_DTO.dart';
import 'reintegrazione_service.dart';
import '../../../../model/entity/corso_di_formazione_DTO.dart';

/// Implementazione del servizio di reintegrazione.
///
/// Fornisce l'implementazione concreta dei metodi definiti nell'interfaccia `ReintegrazioneService`.
/// Interagisce con i DAO per l'accesso e la manipolazione dei dati relativi ai corsi di formazione,
/// alloggi temporanei e supporti medici.
class ReintegrazioneServiceImpl implements ReintegrazioneService {
  /// DAO per la gestione dei supporti medici.
  /// Utilizzato per accedere e manipolare i dati relativi ai supporti medici offerti dalla piattaforma.
  final SupportoMedicoDAO _supportoDAO;

  /// DAO per la gestione degli alloggi temporanei.
  /// Utilizzato per accedere e manipolare i dati relativi agli alloggi temporanei offerti dalla piattaforma.
  final AlloggioTemporaneoDAO _alloggioDAO;

  /// DAO per la gestione dei corsi di formazione.
  /// Utilizzato per accedere e manipolare i dati relativi ai corsi di formazione offerti dalla piattaforma.
  final CorsoDiFormazioneDAO _corsoDAO;

  ReintegrazioneServiceImpl()
      : _corsoDAO = CorsoDiFormazioneDAOImpl(),
        _supportoDAO = SupportoMedicoDAOImpl(),
        _alloggioDAO = AlloggioTemporaneoDAOImpl();

  SupportoMedicoDAO get supportoDAO => _supportoDAO;

  AlloggioTemporaneoDAO get alloggioDAO => _alloggioDAO;

  CorsoDiFormazioneDAO get corsoDAO => _corsoDAO;

  /// Restituisce un elenco di tutti i corsi di formazione disponibili.
  ///
  /// Interagisce con il DAO dei corsi di formazione per recuperare l'elenco completo.
  @override
  Future<List<CorsoDiFormazioneDTO>> corsiDiFormazione() {
    return _corsoDAO.findAll();
  }

  /// Aggiunge un nuovo alloggio temporaneo al sistema.
  ///
  /// Prende un oggetto [AlloggioTemporaneoDTO] contenente i dettagli dell'alloggio da aggiungere.
  @override
  Future<bool> addAlloggio(AlloggioTemporaneoDTO at) {
    return _alloggioDAO.add(at);
  }

  /// Aggiunge un nuovo corso di formazione al sistema.
  ///
  /// Prende un oggetto [CorsoDiFormazioneDTO] contenente i dettagli del corso da aggiungere.
  @override
  Future<bool> addCorso(CorsoDiFormazioneDTO c) {
    return _corsoDAO.add(c);
  }

  /// Aggiunge un nuovo supporto medico al sistema.
  ///
  /// Prende un oggetto [SupportoMedicoDTO] contenente i dettagli del supporto medico da aggiungere.
  @override
  Future<bool> addSupportoMedico(SupportoMedicoDTO sm) {
    return _supportoDAO.add(sm);
  }

  /// Restituisce un elenco di tutti gli alloggi temporanei disponibili.
  ///
  /// Interagisce con il DAO degli alloggi temporanei per recuperare l'elenco completo.
  @override
  Future<List<AlloggioTemporaneoDTO>> alloggiTemporanei() {
    return _alloggioDAO.findAll();
  }

  /// Restituisce un elenco di tutti i supporti medici disponibili.
  ///
  /// Interagisce con il DAO dei supporti medici per recuperare l'elenco completo.
  @override
  Future<List<SupportoMedicoDTO>> supportiMedici() {
    return _supportoDAO.findAll();
  }

  /// Elimina un alloggio temporaneo specificato dal suo ID.
  ///
  /// Accetta l'ID dell'alloggio da eliminare.
  @override
  Future<bool> deleteAlloggio(int idAlloggio) {
    return _alloggioDAO.removeById(idAlloggio);
  }

  /// Elimina un corso di formazione specificato dal suo ID.
  ///
  /// Accetta l'ID del corso da eliminare.
  @override
  Future<bool> deleteCorso(int idCorso) {
    return _corsoDAO.removeById(idCorso);
  }

  /// Elimina un supporto medico specificato dal suo ID.
  ///
  /// Accetta l'ID del supporto medico da eliminare.
  @override
  Future<bool> deleteSupporto(int idSupporto) {
    return _supportoDAO.removeById(idSupporto);
  }
}
