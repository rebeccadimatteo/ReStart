import 'package:postgres/postgres.dart';
import 'dart:developer' as developer;

import '../../connection/connector.dart';
import '../../entity/ads_DTO.dart';
import '../../entity/ca_DTO.dart';
import '../../entity/utente_DTO.dart';
import 'ADS/ads_DAO_impl.dart';
import 'CA/ca_DAO_impl.dart';
import 'autenticazione_DAO.dart';
import 'utente/utente_DAO_impl.dart';

class AutenticazioneDAOImpl implements AutenticazioneDAO {
  Connector connector = Connector();

  /// Questa funzione restituisce il tipo dell'oggetto preso in input
  Future<String> getTipoDynamic(dynamic ug) async {
    if (ug.runtimeType == AdsDTO)
      return "ADS";
    else if (ug.runtimeType == UtenteDTO)
      return "Utente";
    else
      return "CA";
  }

  /// restituisce il tipo dell'utente generico (ads, utente, ca) dato in input l'username
  Future<String> getTipoByUsername(String username) async {
    UtenteDAOImpl utenteDao = UtenteDAOImpl();
    CaDAOImpl caDao = CaDAOImpl();
    AdsDAOImpl adsDao = AdsDAOImpl();

    bool utente = await utenteDao.existByUsername(username);
    bool ca = await caDao.existByUsername(username);
    bool ads = await adsDao.existByUsername(username);

    if (utente != false)
      return "Utente";
    else if (ca != false)
      return "CA";
    else
      return "ADS";
  }

  /// questo metodo prende in input un utente generico e lo aggiunge al database
  /// restituisce true se è andata a buon fine, false altrimenti.
  @override
  Future<bool> add(dynamic ug) async {
    try {
      Connection connection = await connector.openConnection();
      String tipo = getTipoDynamic(ug) as String;
      switch (tipo) {
        case "Utente":
          {
            UtenteDTO utenteDTO = ug;
            UtenteDAOImpl dao = UtenteDAOImpl();
            return dao.add(utenteDTO);
          }
        case "CA":
          {
            CaDTO caDTO = ug;
            CaDAOImpl dao = CaDAOImpl();
            return dao.add(caDTO);
          }
        case "ADS":
          {
            AdsDTO adsDTO = ug;
            AdsDAOImpl dao = AdsDAOImpl();
            return dao.add(adsDTO);
          }
        default:
          return false;
      }
    } catch (e) {
      developer.log(e.toString());
      return false;
    } finally {
      await connector.closeConnection();
    }
  }

  /// rimuove dal database l'utente generico dato in input il suo username
  /// restituisce true se viene rimosso correttamente, false altrimenti.
  @override
  Future<bool> removeByUsername(String username) async {
    try {
      Connection connection = await connector.openConnection();
      String tipo = getTipoByUsername(username) as String;
      switch (tipo) {
        case "Utente":
          {
            UtenteDAOImpl dao = UtenteDAOImpl();
            return dao.removeByUsername(username);
          }
        case "CA":
          {
            CaDAOImpl dao = CaDAOImpl();
            return dao.removeByUsername(username);
          }
        case "ADS":
          {
            AdsDAOImpl dao = AdsDAOImpl();
            return dao.removeByUsername(username);
          }
        default:
          return false;
      }
    } catch (e) {
      developer.log(e.toString());
      return false;
    } finally {
      await connector.closeConnection();
    }
  }

  /// aggiorna i campi di un utente generico
  /// restituisce true se è andato a buon fine, false altrimenti.
  @override
  Future<bool> update(dynamic ug) async {
    try {
      Connection connection = await connector.openConnection();
      String tipo = getTipoDynamic(ug) as String;
      switch (tipo) {
        case "Utente":
          {
            UtenteDTO utenteDTO = ug;
            UtenteDAOImpl dao = UtenteDAOImpl();
            return dao.update(utenteDTO);
          }
        case "CA":
          {
            CaDTO caDTO = ug;
            CaDAOImpl dao = CaDAOImpl();
            return dao.update(caDTO);
          }
        case "ADS":
          {
            AdsDTO adsDTO = ug;
            AdsDAOImpl dao = AdsDAOImpl();
            return dao.update(adsDTO);
          }
        default:
          return false;
      }
    } catch (e) {
      developer.log(e.toString());
      return false;
    } finally {
      await connector.closeConnection();
    }
  }

  /// questo metodo restituise un utente generico preso in input il suo username
  /// restituisce l'utente generico se esiste, null altrimenti.
  @override
  Future<dynamic> findByUsername(String username) async {
    try {
      String tipo = await getTipoByUsername(username);
      switch (tipo) {
        case "Utente":
          {
            UtenteDAOImpl dao = UtenteDAOImpl();
            return dao.findByUsername(username);
          }
        case "CA":
          {
            CaDAOImpl dao = CaDAOImpl();
            return dao.findByUsername(username);
          }
        case "ADS":
          {
            AdsDAOImpl dao = AdsDAOImpl();
            return dao.findByUsername(username);
          }
        default:
          return null;
      }
    } catch (e) {
      developer.log(e.toString());
      return null;
    }
  }
}
