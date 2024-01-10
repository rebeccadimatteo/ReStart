import 'dart:developer' as developer;
import 'package:postgres/postgres.dart';
import '../../connection/connector.dart';
import '../../entity/candidatura_DTO.dart';
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
  Future<bool> existByIdUtente(int id_utente) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named(
            'SELECT * FROM public."Candidatura" WHERE id_utente = @id_utente'),
        parameters: {'id_utente': id_utente},
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
  Future<bool> existByIdLavoro(int id_lavoro) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named(
            'SELECT * FROM public."Candidatura" WHERE id_lavoro = @id_lavoro'),
        parameters: {'id_lavoro': id_lavoro},
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
  Future<CandidaturaDTO?> findByIdUtente(int id_utente) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named(
            'SELECT * FROM public."Candidatura" ca WHERE ca.id_utente = @id'),
        parameters: {'id': id_utente},
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
  Future<CandidaturaDTO?> findByIdLavoro(int id_lavoro) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named(
            'SELECT * FROM public."Candidatura" ca WHERE ca.id_lavoro = @id'),
        parameters: {'id': id_lavoro},
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
  Future<bool> removeById(int id_utente, int id_lavoro) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named(
            'DELETE FROM public."CA" WHERE id_utente = @id_utente AND id_lavoro = @id_lavoro'),
        parameters: {
          'id_utente': id_utente,
          'id_lavoro': id_lavoro,
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
  Future<bool> existCandidatura(int? id_utente, int? id_lavoro) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named(
            'SELECT * FROM public."Candidatura" WHERE id_annuncio = @id_lavoro AND id_utente = @id_utente '),
        parameters: {
          'id_lavoro': id_lavoro,
          'id_utente': id_utente,
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
}
