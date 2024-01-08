import 'dart:developer' as developer;
import 'package:postgres/postgres.dart';
import '../../../connection/connector.dart';
import '../../../entity/ca_DTO.dart';
import 'ca_DAO.dart';

class CaDAOImpl implements CaDAO {
  Connector connector = Connector();

  /// questo metodo prende in input un [CaDTO] e lo aggiunge al database
  /// restituisce true se è andata a buon fine, false altrimenti.
  @override
  Future<bool> add(CaDTO ca) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named('INSERT INTO public."CA" (nome, username, password) '
            'VALUES (@nome, @username, @password) RETURNING id'),
        parameters: {
          'nome': ca.nome,
          'username': ca.username,
          'password': ca.password,
        },
      );
      var id = result[0][0];
      var result1 = await connection.execute(
          Sql.named('INSERT INTO public."Immagine" (immagine, id_ca) '
              'VALUES (@immagine, @id_ca)'),
          parameters: {
            'immagine': ca.immagine,
            'id_ca': id
          });

      var result2 = await connection.execute(
          Sql.named(
              'INSERT INTO public."Indirizzo" (via, citta, provincia, id_ca) '
                  'VALUES (@via, @citta, @provincia, @id_ca)'),
          parameters: {
            'via': ca.via,
            'citta': ca.citta,
            'provincia': ca.provincia,
            'id_ca': id
          });

      var result3 = await connection.execute(
          Sql.named(
              'INSERT INTO public."Contatti" (email, num_telefono, sito_web, id_ca) '
                  'VALUES (@email, @num_telefono, @sito_web, @id_ca)'),
          parameters: {
            'email': ca.email,
            'num_telefono': ca.num_telefono,
            'sito_web': ca.sito_web,
            'id_ca': id
          });

      await connector.closeConnection();
      if (result.affectedRows != 0 &&
          result1.affectedRows != 0 &&
          result2.affectedRows != 0 &&
          result3.affectedRows != 0) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    } finally {
      await connector.closeConnection();
    }
  }

  /// questo metodo dice se esiste un [CaDTO] preso in input l'id
  /// se esiste restituisce true, altrimenti false
  @override
  Future<bool> existById(int id) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named('SELECT * FROM public."CA" WHERE id = @id'),
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

  /// questo metodo dice se esiste un [CaDTO] preso in input l'username
  /// se esiste restituisce true, altrimenti false
  @override
  Future<bool> existByUsername(String username) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named('SELECT * FROM public."CA" WHERE username = @username'),
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

  /// questo metodo restituise la lista di tutti i [CaDTO] sul database
  /// restituisce l'utente generico se esiste, null altrimenti.
  @override
  Future<List<CaDTO>> findAll() async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(Sql.named(
          'SELECT ca.id, ca.nome, ca.username, ca.password, c.num_telefono, c.email, '
              'c.sito, i.immagine, ind.citta, ind.via, ind.provincia '
              'FROM public."CA" as ca, public."Contatti" as c, public."Immagine" as i, public."Indirizzo" as ind '
              'WHERE ca.id = c.id_ca AND ca.id = i.id_ca AND ca.id = ind.id_ca'));

      // Mappa i risultati della query in oggetti CaDTO
      List<CaDTO> collaboratoriAziendali = result.map((row) {
        return CaDTO.fromJson(row.toColumnMap());
      }).toList();

      return collaboratoriAziendali;
    } catch (e) {
      developer.log(e.toString());
      return [];
    } finally {
      await connector.closeConnection();
    }
  }
  /// questo metodo restituise un [CaDTO] preso in input il suo id
  /// restituisce l'utente generico se esiste, null altrimenti.
  @override
  Future<CaDTO?> findById(int id) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named(
            'SELECT  ca.id, ca.nome, ca.username, ca.password, c.num_telefono, c.email, '
                'c.sito, i.immagine, ind.citta, ind.via, ind.provincia '
                'FROM public."CA" as ca, public."Contatti" as c, '
                'public."Immagine" as i, public."Indirizzo" as ind '
                'WHERE ca.id = c.id_ca AND ca.id = i.id_ca AND ca.id = ind.id_ca AND ca.id = @id'),
        parameters: {'id': id},
      );
      if (result.isNotEmpty) {
        return CaDTO.fromJson(result.first.toColumnMap());
      }
    } catch (e) {
      developer.log(e.toString());
      return null;
    } finally {
      await connector.closeConnection();
    }
    return null;
  }
  /// rimuove dal database [CaDTO] preso in input il suo id
  /// restituisce true se viene rimosso correttamente, false altrimenti.
  @override
  Future<bool> removeById(int id) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named('DELETE FROM public."CA" WHERE id = @id'),
        parameters: {'id': id},
      );
      if (result.affectedRows != 0) {
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

  /// rimuove dal database [CaDTO] dato in input il suo username
  /// restituisce true se viene rimosso correttamente, false altrimenti.
  @override
  Future<bool> removeByUsername(String username) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named('DELETE FROM public."CA" WHERE username = @username'),
        parameters: {'username': username},
      );
      if (result.affectedRows != 0) {
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

  /// aggiorna i campi di [CaDTO]
  /// restituisce true se è andato a buon fine, false altrimenti.
  @override
  Future<bool> update(CaDTO ca) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named('UPDATE public."CA" SET nome = @nome, username = @username, '
            'password = @password '
            'WHERE id = @id'),
        parameters: {
          'id': ca.id,
          'nome': ca.nome,
          'username': ca.username,
          'password': ca.password,
        },
      );

      var result1 = await connection.execute(
        Sql.named('UPDATE public."Contatti" SET num_telefono = @num_telefono, email = @email, '
            'WHERE id_ca = @id_ca'),
        parameters: {
          'num_telefono': ca.num_telefono,
          'email': ca.email,
          'password': ca.password,
          'id_ca': ca.id,
        },
      );

      var result2 = await connection.execute(
        Sql.named('UPDATE public."Indirizzo" SET citta = @citta, via = @via, provincia = @provincia'
            ' WHERE id_ca = @id_ca'),
        parameters: {
          'citta': ca.citta,
          'via': ca.via,
          'provincia': ca.provincia,
          'id_ca': ca.id
        },
      );

      var result3 = await connection.execute(
          Sql.named('UPDATE public."Immagine" SET immagine = @immagine'
              ' WHERE id_ca = @id_ca'),
          parameters: {'immagine': ca.immagine, 'id_ca': ca.id});

      if (result.affectedRows != 0 &&
          result1.affectedRows != 0 &&
          result2.affectedRows != 0 &&
          result3.affectedRows != 0) {
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

  /// restituise un [CaDTO] preso in input il suo username
  /// restituisce [CaDTO] se esiste, null altrimenti.
  @override
  Future<CaDTO?> findByUsername(String username) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named(
            'SELECT ca.id, ca.nome, ca.username, ca.password,  c.num_telefono, c.email, c.sito, i.immagine, ind.citta, ind.via, ind.provincia'
                ' FROM public."CA" as ca, public."Contatti" as c, public."Immagine" as i, public."Indirizzo" as ind '
                'WHERE ca.username = @username'),
        parameters: {'username': username},
      );
      if (result.isNotEmpty) {
        return CaDTO.fromJson(result.first.toColumnMap());
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

