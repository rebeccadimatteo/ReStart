import 'dart:developer' as developer;
import 'package:postgres/postgres.dart';
import '../../connection/connector.dart';
import '../../entity/candidatura_DTO.dart';
import '../../entity/utente_DTO.dart';
import 'candidatura_DAO.dart';

class CandidaturaDAOImpl implements CandidaturaDAO {
  Connector connector = Connector();

  @override
  Future<bool> add(CandidaturaDTO ca) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named('INSERT INTO public."Candidatura" (id_utente, id_annuncio) '
            'VALUES (@id_utente, @id_lavoro)'),
        parameters: {
          'id_utente': ca.id_utente,
          'id_lavoro': ca.id_lavoro,
        },
      );
      await connector.closeConnection();
      if (result.affectedRows != 0) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    } finally {
      await connector.closeConnection();
    }
  }

  @override
  Future<bool> existByIdUtente(int idUtente) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named(
            'SELECT * FROM public."Candidatura" WHERE id_utente = @id_utente'),
        parameters: {'id_utente': idUtente},
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

  @override
  Future<bool> existByIdLavoro(int idLavoro) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named(
            'SELECT * FROM public."Candidatura" WHERE id_lavoro = @id_lavoro'),
        parameters: {'id_lavoro': idLavoro},
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

  @override
  Future<List<CandidaturaDTO>> findAll() async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection
          .execute(Sql.named('SELECT * FROM public."Candidatura"'));

      // Mappa i risultati della query in oggetti CandidaturaDTO
      List<CandidaturaDTO> candidature = result.map((row) {
        return CandidaturaDTO.fromJson(row.toColumnMap());
      }).toList();

      return candidature;
    } catch (e) {
      developer.log(e.toString());
      return [];
    } finally {
      await connector.closeConnection();
    }
  }

  @override
  Future<CandidaturaDTO?> findByIdUtente(int idUtente) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named(
            'SELECT * FROM public."Candidatura" ca WHERE ca.id_utente = @id'),
        parameters: {'id': idUtente},
      );
      if (result.isNotEmpty) {
        return CandidaturaDTO.fromJson(result.first.toColumnMap());
      }
    } catch (e) {
      developer.log(e.toString());
      return null;
    } finally {
      await connector.closeConnection();
    }
    return null;
  }

  @override
  Future<CandidaturaDTO?> findByIdLavoro(int idLavoro) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named(
            'SELECT * FROM public."Candidatura" ca WHERE ca.id_lavoro = @id'),
        parameters: {'id': idLavoro},
      );
      if (result.isNotEmpty) {
        return CandidaturaDTO.fromJson(result.first.toColumnMap());
      }
    } catch (e) {
      developer.log(e.toString());
      return null;
    } finally {
      await connector.closeConnection();
    }
    return null;
  }

  @override
  Future<bool> removeById(int idUtente, int idLavoro) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named(
            'DELETE FROM public."CA" WHERE id_utente = @id_utente AND id_lavoro = @id_lavoro'),
        parameters: {
          'id_utente': idUtente,
          'id_lavoro': idLavoro,
        },
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

  @override
  Future<bool> existCandidatura(int? idUtente, int? idLavoro) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named(
            'SELECT * FROM public."Candidatura" WHERE id_annuncio = @id_lavoro AND id_utente = @id_utente '),
        parameters: {
          'id_lavoro': idLavoro,
          'id_utente': idUtente,
        },
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

  @override
  Future<List<UtenteDTO>> findCandidati(int idLavoro) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
          Sql.named(
              'SELECT u.id, u.nome, u.cognome, u.cod_fiscale, u.data_nascita, u.luogo_nascita, u.genere, u.username,u.lavoro_adatto, c.email, c.num_telefono, im.immagine, i.via, i.citta, i.provincia FROM public."Utente" u, '
              'public."Contatti" c, public."Indirizzo" i, public."Immagine" im, public."Candidatura" cand WHERE u.id = c.id_utente AND u.id = i.id_utente AND im.id_utente = u.id AND cand.id_lavoro = @id_lavoro'),
          parameters: {'id_lavoro': idLavoro});

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
}
