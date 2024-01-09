import 'package:postgres/postgres.dart';
import 'dart:developer' as developer;
import '../../../connection/connector.dart';
import '../../../entity/ads_DTO.dart';
import 'ads_DAO.dart';

class AdsDAOImpl implements AdsDAO {
  Connector connector = Connector();

  /// questo metodo prende in input un [AdsDTO] e lo aggiunge al database
  /// restituisce true se è andata a buon fine, false altrimenti.
  @override
  Future<bool> add(AdsDTO a) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named('INSERT INTO public."ADS" (username, password) '
            'VALUES (@username, @password) RETURNING id'),
        parameters: {
          'username': a.username,
          'password': a.password,
        },
      );
      var id = result[0][0];
      var result1 = await connection.execute(
          Sql.named(
              'INSERT INTO public."Indirizzo" (via, citta, provincia, id_corso) '
              'VALUES (@via, @citta, @provincia, @id_ads)'),
          parameters: {
            'via': a.via,
            'citta': a.citta,
            'provincia': a.provincia,
            'id_ads': id
          });

      var result2 = await connection.execute(
          Sql.named(
              'INSERT INTO public."Contatti" (email, num_telefono, id_ads) '
              'VALUES (@email, @telefono, @id_ads)'),
          parameters: {
            'email': a.email,
            'telefono': a.num_telefono,
            'id_ads': id
          });
      if (result.affectedRows != 0 &&
          result1.affectedRows != 0 &&
          result2.affectedRows != 0) {
        return true;
      }
      return false;
    } catch (e) {
      developer.log(e.toString());
      return false;
    } finally {
      await connector.closeConnection();
    }
  }

  /// questo metodo dice se esiste un [AdsDTO] preso in input l'id
  /// se esiste restituisce true, altrimenti false
  @override
  Future<bool> existById(int id) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named('SELECT * FROM public."ADS" a WHERE a.id = @id'),
        parameters: {'id': id},
      );

      if (result.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      developer.log(e.toString());
      return false;
    } finally {
      await connector.closeConnection();
    }
  }

  /// questo metodo dice se esiste un [AdsDTO] preso in input l'username
  /// se esiste restituisce true, altrimenti false
  @override
  Future<bool> existByUsername(String username) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named('SELECT * FROM public."ADS" a WHERE a.username = @username'),
        parameters: {'username': username},
      );
      if (result.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      developer.log(e.toString());
      return false;
    } finally {
      await connector.closeConnection();
    }
  }

  /// questo metodo restituise la lista di tutti gli [AdsDTO] sul database
  /// restituisce l'utente generico se esiste, null altrimenti.
  @override
  Future<List<AdsDTO>> findAll() async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(Sql.named(
          'SELECT a.id, a.username, a.password, c.email, c.num_telefono, ind.citta, ind.via, ind.provincia '
          ' FROM public."ADS" a, public."Contatti" c, public."Indirizzo" ind '
          ' WHERE a.id = c.id_ca AND a.id = ind.id_ca'));

      List<AdsDTO> ads = result.map((row) {
        return AdsDTO.fromJson(row.toColumnMap());
      }).toList();

      return ads;
    } catch (e) {
      developer.log(e.toString());
      return [];
    } finally {
      await connector.closeConnection();
    }
  }

  /// questo metodo restituise un [AdsDTO] preso in input il suo id
  /// restituisce l'utente generico se esiste, null altrimenti.
  @override
  Future<AdsDTO?> findById(int id) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named(
            'SELECT a.id, a.username, a.password, c.email, c.num_telefono, ind.citta, ind.via, ind.provincia '
            ' FROM public."ADS" a, public."Contatti" c, public."Indirizzo" ind '
            ' WHERE @id = c.id_ca AND @id = ind.id_ca AND a.id = @id'),
        parameters: {'id': id},
      );
      if (result.isNotEmpty) {
        return AdsDTO.fromJson(result.first.toColumnMap());
      }
    } catch (e) {
      developer.log(e.toString());
      return null;
    } finally {
      await connector.closeConnection();
    }
    return null;
  }

  /// rimuove dal database [AdsDTO] preso in input il suo id
  /// restituisce true se viene rimosso correttamente, false altrimenti.
  @override
  Future<bool> removeById(int id) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named('DELETE FROM public."ADS" WHERE id = @id'),
        parameters: {'id': id},
      );
      if (result.isNotEmpty) {
        return true;
      }
      return false;
    } catch (e) {
      developer.log(e.toString());
      return false;
    } finally {
      await connector.closeConnection();
    }
  }

  /// rimuove dal database [AdsDTO] dato in input il suo username
  /// restituisce true se viene rimosso correttamente, false altrimenti.
  @override
  Future<bool> removeByUsername(String username) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named('DELETE FROM public."ADS" WHERE username = @username'),
        parameters: {'username': username},
      );
      if (result.isNotEmpty) {
        return true;
      }
      return false;
    } catch (e) {
      developer.log(e.toString());
      return false;
    } finally {
      await connector.closeConnection();
    }
  }

  /// aggiorna i campi di [AdsDTO]
  /// restituisce true se è andato a buon fine, false altrimenti.
  @override
  Future<bool> update(AdsDTO a) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named(
            'UPDATE public."ADS" SET username = @username, password = @password '
            'WHERE id = @id'),
        parameters: {
          'id': a.id,
          'username': a.username,
          'password': a.password,
        },
      );

      var result1 = await connection.execute(
        Sql.named(
            'UPDATE public."Contatti" SET email = @email, num_telefono = @num_telefono '
            'WHERE id_ADS = @id_ADS'),
        parameters: {
          'email': a.email,
          'num_telefono': a.num_telefono,
          'id_ADS': a.id,
        },
      );

      var result2 = await connection.execute(
        Sql.named(
            'UPDATE public."Indirizzo" SET via = @via, citta = @citta, provincia = @provincia '
            'WHERE id_ADS = @id_ADS'),
        parameters: {
          'via': a.via,
          'citta': a.citta,
          'provincia': a.provincia,
          'id_ADS': a.id
        },
      );
      if (result.affectedRows != 0 &&
          result1.affectedRows != 0 &&
          result2.affectedRows != 0) {
        return true;
      }
      return false;
    } catch (e) {
      developer.log(e.toString());
      return false;
    } finally {
      await connector.closeConnection();
    }
  }

  /// restituise un [AdsDTO] preso in input il suo username
  /// restituisce [AdsDTO] se esiste, null altrimenti.
  @override
  Future<AdsDTO?> findByUsername(String username) async {
    try {
      Connection connection = await connector.openConnection();
      var result1 = await connection.execute(
        Sql.named(
            'SELECT a.id FROM public."ADS" a WHERE a.username = @username'),
        parameters: {'username': username},
      );
      if (result1.isNotEmpty) {
        int id = result1[0][0] as int;
        var result = await connection.execute(
          Sql.named(
              'SELECT a.id, a.username, a.password, c.email, c.num_telefono, ind.citta, ind.via, ind.provincia '
                  ' FROM public."ADS" a, public."Contatti" c, public."Indirizzo" ind '
                  ' WHERE @id = c.id_ca AND @id = ind.id_ca AND a.id = @id'),
          parameters: {'id': id},
        );
        if (result.isNotEmpty) {
          return AdsDTO.fromJson(result.first.toColumnMap());
        }
      }
    } catch (e) {
      developer.log(e.toString());
      return null;
    } finally {
      await connector.closeConnection();
    }
    return null;
  }
}
