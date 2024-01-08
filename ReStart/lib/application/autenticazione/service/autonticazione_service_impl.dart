
import 'package:restart_all_in_one/application/autenticazione/service/autenticazione_service.dart';
import 'package:restart_all_in_one/model/dao/autenticazione/autenticazione_DAO.dart';
import 'package:restart_all_in_one/model/dao/autenticazione/autenticazione_DAO_impl.dart';
import 'package:restart_all_in_one/model/entity/ads_DTO.dart';
import 'package:restart_all_in_one/model/entity/ca_DTO.dart';
import 'package:restart_all_in_one/model/entity/utente_DTO.dart';

class AutenticazioneServiceImpl implements AutenticazioneService{
  final AutenticazioneDAO _autenticazioneDAO;


  AutenticazioneServiceImpl():
      _autenticazioneDAO = AutenticazioneDAOImpl();

  @override
  Future<dynamic> login(String user, String psw) async {
    dynamic utente = await _autenticazioneDAO.findByUsername(user);
    if(utente == null){
      return null;
    }else{
      if(utente is AdsDTO){
        AdsDTO utenteAds = utente;
        if(utenteAds.password == psw){
          return utenteAds;
        }
      }
      if(utente is UtenteDTO){
        UtenteDTO utenteU = utente;
        if(utenteU.password == psw){
          return utenteU;
        }
      }else{
        CaDTO utenteCa = utente;
        if(utenteCa.password == psw){
          return utenteCa;
        }
      }
    }
  }


}