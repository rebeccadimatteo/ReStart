

import 'package:restart_all_in_one/model/entity/utente_DTO.dart';

abstract class AutenticazioneService{
  Future<dynamic> login(String user, String psw);
}