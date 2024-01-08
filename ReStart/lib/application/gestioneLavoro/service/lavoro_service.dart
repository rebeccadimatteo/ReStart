import 'dart:async';
import 'package:restart_all_in_one/model/dao/annuncio_di_lavoro/annuncio_di_lavoro_DAO.dart';
import 'package:restart_all_in_one/model/entity/annuncio_di_lavoro_DTO.dart';
import 'package:restart_all_in_one/model/entity/ca_DTO.dart';
import 'package:restart_all_in_one/model/entity/utente_DTO.dart';

abstract class LavoroService {

  Future<List<AnnuncioDiLavoroDTO>> offerteLavoro();
  //Future<AnnuncioDiLavoroDTO?> detailsLavoro(int id);
  Future<List<AnnuncioDiLavoroDTO>> offertePubblicate(String usernameCa);
  Future<bool> addLavoro(AnnuncioDiLavoroDTO annuncio);
  Future<bool> modifyLavoro(AnnuncioDiLavoroDTO annuncio);
  Future<bool> deleteLavoro(int id);
  Future<List<UtenteDTO>> utentiCandidati(AnnuncioDiLavoroDTO annuncio);
  Future<UtenteDTO> profiloUtenteCandidato(UtenteDTO u);
  Future<List<AnnuncioDiLavoroDTO>> richiestaLavoro();
  Future<bool> approveLavoro(AnnuncioDiLavoroDTO annuncio);
  Future<bool> rejectLavoro(AnnuncioDiLavoroDTO annuncio);
}