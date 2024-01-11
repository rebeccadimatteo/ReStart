import '../../../model/entity/annuncio_di_lavoro_DTO.dart';
import '../../../model/entity/utente_DTO.dart';

abstract class LavoroService {
  Future<List<AnnuncioDiLavoroDTO>> offerteLavoro();

  Future<List<AnnuncioDiLavoroDTO>> offertePubblicate(String usernameCa);

  Future<bool> addLavoro(AnnuncioDiLavoroDTO annuncio);

  Future<bool> modifyLavoro(AnnuncioDiLavoroDTO annuncio);

  Future<bool> deleteLavoro(int id);

  Future<List<UtenteDTO?>?> utentiCandidati(AnnuncioDiLavoroDTO annuncio);

  Future<String> approveLavoro(int  id_annuncio);

  Future<String> rejectLavoro(int  id_annuncio);
}
