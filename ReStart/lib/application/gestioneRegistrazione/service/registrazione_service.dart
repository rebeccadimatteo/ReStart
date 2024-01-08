import '../../../model/entity/utente_DTO.dart';

/// Questa classe rappresenta il service che si occupa della registrazione
/// di un utente alla piattaforma
abstract class RegistrazioneService{

  Future<bool> signUp(UtenteDTO ug);

}