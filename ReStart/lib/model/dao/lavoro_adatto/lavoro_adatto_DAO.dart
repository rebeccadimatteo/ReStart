import '../../entity/utente_DTO.dart';

abstract class LavoroAdattoDAO{
  Future<bool> update(String lavoroAdatto, UtenteDTO u);
}