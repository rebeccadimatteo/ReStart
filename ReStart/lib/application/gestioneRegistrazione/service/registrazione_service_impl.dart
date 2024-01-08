import '../../../model/dao/autenticazione/utente/utente_DAO.dart';
import '../../../model/dao/autenticazione/utente/utente_DAO_impl.dart';
import '../../../model/entity/utente_DTO.dart';
import 'registrazione_service.dart';

class RegistrazioneServiceImpl implements RegistrazioneService {
  final UtenteDAO _utenteDAO;

  /// costruttore
  RegistrazioneServiceImpl()
      : _utenteDAO = UtenteDAOImpl();

  /// questo metodo interagisce con il dao dell'utente.
  /// se l'utente preso in input è valido e non esiste gia, viene registrato e return true
  /// altrimenti ritorna false.else if(ug.runtimeType == UtenteDTO)
  @override
  Future<bool> signUp(UtenteDTO utente) async {
    return _utenteDAO.add(utente);
  }
}