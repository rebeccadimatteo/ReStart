import 'package:postgres/postgres.dart';
import 'dart:developer' as developer;

import '../../connection/connector.dart';
import '../../entity/corso_di_formazione_DTO.dart';
import 'corso_di_formazione_DAO.dart';

/// Questa classe rappresenta l'implementazione del dao del corso di formazione
class CorsoDiFormazioneDAOImpl implements CorsoDiFormazioneDAO {
  Connector connector = Connector();

  ///metodo che permette di aggiungere un [CorsoDiFormazioneDTO] nel DataBase
  ///restituisce true se l'operazione è andata a buon fine
  @override
  Future<bool> add(CorsoDiFormazioneDTO cf) async {
    try {
      Connection connection = await connector.openConnection();

      var result = await connection.execute(
        Sql.named(
            'INSERT INTO public."CorsoDiFormazione" (nome_corso, nome_responsabile, cognome_responsabile, descrizione, url_corso, immagine) '
            'VALUES (@nome_corso, @nome_responsabile, @cognome_responsabile, @descrizione, @url_corso, @immagine) RETURNING id'),
        parameters: {
          'nomeCorso': cf.nomeCorso,
          'nomeResponsabile': cf.nomeResponsabile,
          'cognomeResponsabile': cf.cognomeResponsabile,
          'descrizione': cf.descrizione,
          'urlCorso': cf.urlCorso,
        },
      );
      var id = result[0][0];

      var result1 = await connection.execute(
          Sql.named('INSERT INTO public."Immagine" (immagine, idCorso) '
              'VALUES (@immagine, @idCorso)'),
          parameters: {'immagine': cf.immagine, 'idCorso': id});


      await connector.closeConnection();

      if (result1.affectedRows != 0 &&
          result.affectedRows != 0) {
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

  ///metodo che permette di verificare se un [CorsoDiFormazioneDTO] è presente nel DataBase
  ///prende in input un [int] che rappresenta l'id del supporto medico e restituisce true se esiste
  @override
  Future<bool> existById(int id) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named('SELECT * FROM public."CorsoDiFormazione" WHERE id = @id'),
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

  ///metodo che restituisce la lista di tutti i [CorsoDiFormazioneDTO]presenti nel DataBase
  @override
  Future<List<CorsoDiFormazioneDTO>> findAll() async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(Sql.named(
          'SELECT cf.id, cf.nome_corso, cf.nome_responsabile, cf.cognome_responsabile, cf.descrizione, cf.url_corso, '
          'i.immagine FROM public."CorsoDiFormazione" as cf, public."Immagine" as i '
          'WHERE cf.id = i.id_corso'));
      await connector.closeConnection();

      // Mappa i risultati della query in oggetti CorsoDiFormazioneDTO
      List<CorsoDiFormazioneDTO> corsi = result.map((row) {
        return CorsoDiFormazioneDTO.fromJson(row.toColumnMap());
      }).toList();

      return corsi;
    } catch (e) {
      developer.log(e.toString());
      print(e);
      return [];
    } finally {
      await connector.closeConnection();
    }
  }

  ///metodo che restituisce un [CorsoDiFormazioneDTO] se quest'ultimo è presente nel DataBase
  @override
  Future<CorsoDiFormazioneDTO?> findById(int id) async {
    try {
      Connection connection = await connector.openConnection();

      var result = await connection.execute(
        Sql.named(
            'SELECT  cf.id, cf.nome_corso, cf.nome_responsabile, cf.cognome_responsabile, cf.descrizione, cf.url_corso, '
            'c.sito, i.immagine FROM public."CorsoDiFormazione" as cf, public."Immagine" as i '
            'WHERE cf.id = @id AND cf.id = i.id_corso'),
        parameters: {'id': id},
      );

      if (result.isNotEmpty) {
        return CorsoDiFormazioneDTO.fromJson(result.first.toColumnMap());
      }
    } catch (e) {
      developer.log(e.toString());
      return null;
    } finally {
      await connector.closeConnection();
    }
    return null;
  }

  ///metodo che rimuove un [CorsoDiFormazioneDTO] del DataBase
  ///restituisce true se l'operazione è andata a buon fine
  @override
  Future<bool> removeById(int id) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named('DELETE FROM public."CorsoDiFormazione" WHERE id = @id'),
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

  ///metodo che aggiorna un [CorsoDiFormazioneDTO] nel DataBase
  ///restituisce true se l'operazione è andata a buon fine
  @override
  Future<bool> update(CorsoDiFormazioneDTO cf) async {
    try {
      Connection connection = await connector.openConnection();
      var result1 = await connection.execute(
        Sql.named(
            'UPDATE public."CorsoDiFormazione" SET nome_corso = @nomeCorso, nome_responsabile = @nomeResponsabile, '
            'cognome_responsabile = @cognomeResponsabile, descrizione = @descrizione, '
            'url_corso = @urlCorso'
            'WHERE id = @id'),
        parameters: {
          'id': cf.id,
          'nomeCorso': cf.nomeCorso,
          'nomeResponsabile': cf.nomeResponsabile,
          'cognomeResponsabile': cf.cognomeResponsabile,
          'descrizione': cf.descrizione,
          'urlCorso': cf.urlCorso,
          'immagine': cf.immagine
        },
      );

      var result2 = await connection.execute(
          Sql.named('UPDATE public."Immagine" SET immagine = @immagine '
              'WHERE id_corso = @id_corso'),
          parameters: {'immagine': cf.immagine, 'id_corso': cf.id});

      if (result1.affectedRows != 0 && result2.affectedRows != 0) {
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
}
