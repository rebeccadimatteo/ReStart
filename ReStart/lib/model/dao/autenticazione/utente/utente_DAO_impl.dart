import 'package:postgres/postgres.dart';
import 'dart:developer' as developer;
import '../../../connection/connector.dart';
import '../../../entity/utente_DTO.dart';
import 'utente_DAO.dart';

class UtenteDAOImpl implements UtenteDAO {
  Connector connector = Connector();

  /// questo metodo prende in input un [UtenteDTO] e lo aggiunge al database
  /// restituisce true se è andata a buon fine, false altrimenti.
  @override
  Future<bool> add(UtenteDTO u) async {
    Connection connection = await connector.openConnection();
    try {
      var result1 = await connection.execute(
        Sql.named(
            'INSERT INTO public."Utente"  (nome, cognome, cod_fiscale, data_nascita, luogo_nascita, genere, username, password) '
            'VALUES (@nome, @cognome, @cod_fiscale, @data_nascita, @luogo_nascita, @genere, @username, @password) RETURNING id'),
        parameters: {
          'nome': u.nome,
          'cognome': u.cognome,
          'cod_fiscale': u.cod_fiscale,
          'data_nascita': u.data_nascita,
          'luogo_nascita': u.luogo_nascita,
          'genere': u.genere,
          'username': u.username,
          'password': u.password,
        },
      );
      var id = result1[0][0];
      var result2 = await connection.execute(
          Sql.named(
              'INSERT INTO public."Indirizzo" (via, citta, provincia, id_utente) '
              'VALUES (@via, @citta, @provincia, @id_utente)'),
          parameters: {
            'via': u.via,
            'citta': u.citta,
            'provincia': u.provincia,
            'id_utente': id
          });

      var result3 = await connection.execute(
          Sql.named(
              'INSERT INTO public."Contatti" (email, num_telefono, id_utente) '
              'VALUES (@email, @telefono, @id_utente)'),
          parameters: {
            'id_utente': id,
            'email': u.email,
            'telefono': u.num_telefono,
          });

      var result4 = await connection.execute(
          Sql.named('INSERT INTO public."Immagine" (immagine, id_utente)'
              'VALUES (@immagine, @id)'),
          parameters: {
            'immagine': u.immagine,
            'id': id
          }
      );

      if (result1.affectedRows != 0 &&
          result2.affectedRows != 0 &&
          result3.affectedRows != 0 &&
          result4.affectedRows != 0) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      developer.log(e.toString());
      return false;
    } finally {
      await connector.closeConnection();
    }
  }

  /// questo metodo dice se esiste un [UtenteDTO] preso in input l'id
  /// se esiste restituisce true, altrimenti false
  @override
  Future<bool> existById(int id) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named('SELECT * FROM public."Utente" u WHERE u.id = @id'),
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

  /// questo metodo dice se esiste un [UtenteDTO] preso in input l'username
  /// se esiste restituisce true, altrimenti false
  @override
  Future<bool> existByUsername(String username) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named(
            'SELECT * FROM public."Utente" u WHERE u.username = @username'),
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

  /// questo metodo restituise la lista di tutti gli [UtenteDTO] sul database
  /// restituisce l'utente generico se esiste, null altrimenti.
  @override
  Future<List<UtenteDTO>> findAll() async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(Sql.named(
          'SELECT u.id, u.nome, u.cognome, u.cod_fiscale, u.data_nascita, u.luogo_nascita, u.genere, u.username,u.lavoro_adatto, c.email, c.num_telefono, im.immagine, i.via, i.citta, i.provincia FROM public."Utente" u, '
          'public."Contatti" c, public."Indirizzo" i, public."Immagine" im WHERE u.id = c.id_utente AND u.id = i.id_utente AND im.id_utente = u.id'));

      // Mappa i risultati della query in oggetti Utente_DTO
      List<UtenteDTO> list = result.map((row) {
        return UtenteDTO.fromJson(row.toColumnMap());
      }).toList();

      return list;
    } catch (e) {
      developer.log(e.toString());
      return [];
    } finally {
      await connector.closeConnection();
    }
  }

  /// questo metodo restituise un [UtenteDTO] preso in input il suo id
  /// restituisce l'utente generico se esiste, null altrimenti.
  @override
  Future<UtenteDTO?> findById(int id) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named(
            'SELECT u.*, c.email, c.num_telefono,img.immagine, i.via, i.citta, i.provincia FROM public."Utente" u, public."Contatti" c, public."Immagine" img, '
            'public."Indirizzo" i WHERE @id = c.id_utente AND @id = i.id_utente AND @id = img.id_utente AND u.id = @id'),
        parameters: {'id': id},
      );
      if (result.isNotEmpty) {
        return UtenteDTO.fromJson(result.first.toColumnMap());
      }
    } catch (e) {
      developer.log(e.toString());
      return null;
    } finally {
      connector.closeConnection();
    }
    return null;
  }

  /// rimuove dal database [UtenteDTO] preso in input il suo id
  /// restituisce true se viene rimosso correttamente, false altrimenti.
  @override
  Future<bool> removeById(int id) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named('DELETE FROM public."Utente" WHERE id = @id'),
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

  /// rimuove dal database [UtenteDTO] dato in input il suo username
  /// restituisce true se viene rimosso correttamente, false altrimenti.
  @override
  Future<bool> removeByUsername(String username) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named('DELETE FROM public."Utente" WHERE username = @username'),
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

  /// aggiorna i campi di [UtenteDTO]
  /// restituisce true se è andato a buon fine, false altrimenti.
  @override
  Future<bool> update(UtenteDTO u) async {
    try {
      Connection connection = await connector.openConnection();
      var result1 = await connection.execute(
        Sql.named(
            'UPDATE public."Utente" SET nome = @nome, cognome = @cognome, cod_fiscale = @cod_fiscale, data_nascita = @data_nascita, luogo_nascita = @luogo_nascita, '
            'genere = @genere, username = @username, password = @password WHERE id = @id'),
        parameters: {
          'id': u.id,
          'nome': u.nome,
          'cognome': u.cognome,
          'cod_fiscale': u.cod_fiscale,
          'data_nascita': u.data_nascita,
          'luogo_nascita': u.luogo_nascita,
          'genere': u.genere,
          'username': u.username,
          'password': u.password,
        },
      );

      var result2 = await connection.execute(
        Sql.named(
            'UPDATE public."Contatti" SET email = @email, num_telefono = @num_telefono '
            'WHERE id_utente = @id_utente'),
        parameters: {
          'email': u.email,
          'num_telefono': u.num_telefono,
          'id_utente': u.id,
        },
      );

      var result3 = await connection.execute(
        Sql.named(
            'UPDATE public."Indirizzo" SET via = @via, citta = @citta, provincia = @provincia '
            'WHERE id_utente = @id_utente'),
        parameters: {
          'via': u.via,
          'citta': u.citta,
          'provincia': u.provincia,
          'id_utente': u.id
        },
      );

      var result4 = await connection.execute(
          Sql.named('UPDATE public."Immagine" SET immagine = @immagine '
              'WHERE id_utente = @id'),
          parameters: {
            'immagine': u.immagine,
            'id': u.id
          }
      );

      if (result1.affectedRows != 0 &&
          result2.affectedRows != 0 &&
          result3.affectedRows != 0 &&
          result4.affectedRows != 0) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      developer.log(e.toString());
      return false;
    } finally {
      await connector.closeConnection();
    }
  }

  /// restituise un [UtenteDTO] preso in input il suo username
  /// restituisce [UtenteDTO] se esiste, null altrimenti.
  @override
  Future<UtenteDTO?> findByUsername(String username) async {
    try {
      Connection connection = await connector.openConnection();
      var result1 = await connection.execute(
        Sql.named('SELECT u.id FROM public."Utente" as u WHERE u.username = @username'),
        parameters: {'username': username},
      );
      if (result1.isNotEmpty) {
        int id = result1[0][0] as int;
        var result = await connection.execute(
          Sql.named(
              'SELECT u.*, c.email, c.num_telefono,img.immagine, i.via, i.citta, i.provincia FROM public."Utente" u, public."Contatti" c, public."Immagine" img, '
                  'public."Indirizzo" i WHERE @id = c.id_utente AND @id = i.id_utente AND @id = img.id_utente AND u.id = @id'),
          parameters: {'id': id},
        );
        if (result.isNotEmpty) {
          return UtenteDTO.fromJson(result.first.toColumnMap());
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
