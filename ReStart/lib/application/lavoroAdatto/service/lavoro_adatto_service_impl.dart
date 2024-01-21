import '../../../model/dao/autenticazione/utente/utente_DAO.dart';
import '../../../model/dao/autenticazione/utente/utente_DAO_impl.dart';
import '../../../model/dao/lavoro_adatto/lavoro_adatto_DAO.dart';
import '../../../model/dao/lavoro_adatto/lavoro_adatto_DAO_impl.dart';
import '../../../model/entity/utente_DTO.dart';
import '../adapter/lavoro_adatto_adapter.dart';
import '../adapter/lavoro_adatto_adapter_impl.dart';
import 'lavoro_adatto_service.dart';

/// Implementazione del service Lavoro Adatto.
///
/// Fornisce l'implementazione concreta dei metodi definiti nell'interfaccia `LavoroAdattoService`.
class LavoroAdattoServiceImpl implements LavoroAdattoService{
  LavoroAdattoAdapter adapter = LavoroAdattoAdapterImpl();
  LavoroAdattoDAO dao = LavoroAdattoDAOImpl();

  /// Determina il lavoro più adatto per un utente basandosi sui dati forniti e l'ID dell'utente.
  ///
  /// Utilizza l'adapter [LavoroAdattoAdapter] per determinare il lavoro più adatto.
  /// Successivamente, utilizza il DAO [LavoroAdattoDAO] per aggiornare le informazioni dell'utente con il lavoro adatto.
  ///
  /// Restituisce una stringa che rappresenta il lavoro adatto, o una stringa vuota in caso di errore.
  @override
  Future<String> lavoroAdatto(Map<String, dynamic> form, int id) async {
    try {
      UtenteDAO userDao = UtenteDAOImpl();
      String result = await adapter.lavoroAdatto(form);
      UtenteDTO? user = await userDao.findById(id);
      if(await dao.update(result, user!)){
        return result;
      }else{
        return '';
      }
    } catch(e){
      return '';
    }
  }
}