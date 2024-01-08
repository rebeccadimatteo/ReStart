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

class ReintegrazioneServiceImpl implements ReintegrazioneService {
  final SupportoMedicoDAO _supportoDAO;
  final AlloggioTemporaneoDAO _alloggioDAO;
  final CorsoDiFormazioneDAO _corsoDAO;

  ReintegrazioneServiceImpl()
      : _corsoDAO = CorsoDiFormazioneDAOImpl(),
        _supportoDAO = SupportoMedicoDAOImpl(),
        _alloggioDAO = AlloggioTemporaneoDAOImpl();

  SupportoMedicoDAO get supportoDAO => _supportoDAO;

  AlloggioTemporaneoDAO get alloggioDAO => _alloggioDAO;

  CorsoDiFormazioneDAO get corsoDAO => _corsoDAO;

  @override
  Future<List<CorsoDiFormazioneDTO>> corsiDiFormazione() {
    return _corsoDAO.findAll();
  }

  @override
  Future<bool> addAlloggio(AlloggioTemporaneoDTO at) {
    return _alloggioDAO.add(at);
  }

  @override
  Future<bool> addCorso(CorsoDiFormazioneDTO c) {
    return _corsoDAO.add(c);
  }

  @override
  Future<bool> addSupportoMedico(SupportoMedicoDTO sm) {
    return _supportoDAO.add(sm);
  }

  @override
  Future<List<AlloggioTemporaneoDTO>> alloggiTemporanei() {
    return _alloggioDAO.findAll();
  }

  @override
  Future<List<SupportoMedicoDTO>> supportiMedici() {
    return _supportoDAO.findAll();
  }
}
