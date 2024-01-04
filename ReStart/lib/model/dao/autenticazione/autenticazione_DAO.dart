/**
  Questa classe rappresenta il DAO dell'autenticazione (registrazione+login)
  si noti che ug si riferisce ad Utente Generico: [UtenteDTO], [CaDTO], [AdsDTO]
 */
abstract class AutenticazioneDAO {

  Future<bool> add(dynamic ug);

  Future<dynamic> findByUsername(String username);

  Future<bool> removeByUsername(String username);

  Future<bool> update(dynamic ug);
}