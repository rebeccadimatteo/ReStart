
import '../../../model/dao/autenticazione/utente/utente_DAO.dart';
import '../../../model/dao/autenticazione/utente/utente_DAO_impl.dart';
import '../../../model/dao/lavoro_adatto/lavoro_adatto_DAO.dart';
import '../../../model/dao/lavoro_adatto/lavoro_adatto_DAO_impl.dart';
import '../../../model/entity/utente_DTO.dart';
import '../adapter/lavoro_adatto_adapter.dart';
import '../adapter/lavoro_adatto_adapter_impl.dart';
import 'lavoro_adatto_service.dart';

class LavoroAdattoServiceImpl implements LavoroAdattoService{
  LavoroAdattoAdapter adapter = LavoroAdattoAdapterImpl();
  LavoroAdattoDAO dao = LavoroAdattoDAOImpl();

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