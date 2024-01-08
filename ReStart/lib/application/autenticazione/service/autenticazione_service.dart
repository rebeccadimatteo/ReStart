abstract class AutenticazioneService {

  Future<dynamic> login(String user, String psw);

  Future<bool> deleteUtente(String username);
}
