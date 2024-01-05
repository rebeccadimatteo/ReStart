import 'dart:developer' as developer;
import 'package:postgres/postgres.dart';
import '../../connection/connector.dart';
import '../../entity/candidatura_DTO.dart';
import 'candidatura_DAO.dart';

/// Questa classe rappresenta l'implementazione del dao della Candidatura

class CandidaturaDAOImpl implements CandidaturaDAO {
  Connector connector = Connector();

  ///metodo che permette di aggiungere una [CandidaturaDTO] nel DataBase
  ///restituisce true se l'operazione è andata a buon fine
  @override
  Future<bool> add(CandidaturaDTO ca) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        'INSERT INTO ReStart.Candidatura (id_utente, id_lavoro) '
            'VALUES (@id_utente, @id_lavoro)',
        parameters: {
          'id_utente': [ca.id_utente],
          'id_lavoro': [ca.id_lavoro],
        },
      );
      await connector.closeConnection();
      if (result.affectedRows != 0) {
        return true;
      }
      return false;
    }catch(e){
      print(e);
      return false;
    }finally{
      await connector.closeConnection();
    }
  }

  /// Questo metodo verifica se esiste una [CandidaturaDTO] prendendo in input un
  /// [int] che rappresenta l'id utente fornito.
  /// Restituisce `true` se esiste, `false` altrimenti.
  @override
  Future<bool> existByIdUtente(int id_utente) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        'SELECT * FROM ReStart.Candidatura WHERE id_utente = @id_utente',
        parameters: {'id': id_utente},
      );

      if (result.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      developer.log(e.toString());
      return false;
    }finally{
      await connector.closeConnection();
    }
  }

  /// Questo metodo verifica se esiste una [CandidaturaDTO] prendendo in input un
  /// [int] che rappresenta l'id lavoro fornito.
  /// Restituisce `true` se esiste, `false` altrimenti.
  @override
  Future<bool> existByIdLavoro(int id_lavoro) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        'SELECT * FROM ReStart.Candidatura WHERE id_lavoro = @id_lavoro',
        parameters: {'id': id_lavoro},
      );

      if (result.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      developer.log(e.toString());
      return false;
    }finally{
      await connector.closeConnection();
    }
  }

  /// Questo metodo recupera tutte le candidature presenti nel database.
  /// Restituisce una lista di oggetti [CandidaturaDTO].
  @override
  Future<List<CandidaturaDTO>> findAll() async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute('SELECT * FROM ReStart.Candidatura');

      // Mappa i risultati della query in oggetti CandidaturaDTO
      List<CandidaturaDTO> candidature = result.map((row) {
        return CandidaturaDTO.fromJson(row.toColumnMap());
      }).toList();

      return candidature;
    } catch (e) {
      developer.log(e.toString());
      return [];
    }finally{
      await connector.closeConnection();
    }
  }

  /// Questo metodo cerca una [CandidaturaDTO] prendendo in input un
  /// [int] che rappresenta l'id utente fornito.
  /// Restituisce un oggetto [CandidaturaDTO] se trovato.
  @override
  Future<CandidaturaDTO?> findByIdUtente(int id_utente) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named('SELECT * FROM ReStart.Candidatura ca WHERE ca.id_utente = @id'),
        parameters: {'id': id_utente},
      );
      if (result.isNotEmpty) {
        return CandidaturaDTO.fromJson(result.first.toColumnMap());
      }
    } catch (e) {

      developer.log(e.toString());
      return null;
    }finally{
      await connector.closeConnection();
    }
    return null;
  }

  /// Questo metodo cerca una [CandidaturaDTO] prendendo in input un
  /// [int] che rappresenta l'id lavoro fornito.
  /// Restituisce un oggetto [CandidaturaDTO] se trovato.
  @override
  Future<CandidaturaDTO?> findByIdLavoro(int id_lavoro) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named('SELECT * FROM ReStart.Candidatura ca WHERE ca.id_lavoro = @id'),
        parameters: {'id': id_lavoro},
      );
      if (result.isNotEmpty) {
        return CandidaturaDTO.fromJson(result.first.toColumnMap());
      }
    } catch (e) {

      developer.log(e.toString());
      return null;
    }finally{
      await connector.closeConnection();
    }
    return null;
  }

  /// Questo metodo rimuove una [CandidaturaDTO] dal database prendendo in input due
  /// [int] che rappresentano l'id utente e l'id lavoro forniti.
  /// Restituisce `true` se la rimozione è riuscita, `false` altrimenti.
  @override
  Future<bool> removeById(int id_utente, int id_lavoro) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        'DELETE FROM ReStart.CA WHERE id_utente = @id_utente AND id_lavoro = @id_lavoro',
        parameters: {
          'id_utente': id_utente,
          'id_lavoro': id_lavoro,
        },
      );
      if(result.affectedRows != 0){
        return true;
      }
      return false;
    } catch (e) {
      developer.log(e.toString());
      return false;
    }finally{
      await connector.closeConnection();
    }
  }
}