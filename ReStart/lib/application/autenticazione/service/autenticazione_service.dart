import '../../../model/entity/utente_DTO.dart';

abstract class AutenticazioneService {
  Future<dynamic> login(String user, String psw);

  Future<bool> deleteUtente(String username);

  Future<List<UtenteDTO>> listaUtenti();

  Future<bool> modifyUtente(UtenteDTO u);

  Future<UtenteDTO?> visualizzaUtente(String username);

  Future<bool> checkUserUtente(var token);

  Future<bool> checkUserADS(var token);

  Future<bool> checkUserCA(var token);
}
