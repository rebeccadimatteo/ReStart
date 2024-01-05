import 'package:postgres/postgres.dart';
import 'dart:developer' as developer;
import '../../connection/connector.dart';
import '../../entity/evento_DTO.dart';
import 'evento_DAO.dart';

/// Classe che implementa i metodi dell'interfaccia EventoDAO
class EventoDAOImpl implements EventoDAO {
  /// Istanza di un oggetto connector per la connessione al database
  Connector connector = Connector();

  /// Metodo che, dato un oggetto EventoDTO, lo inserisce all'interno del database e sulla base del risultato dell'operazione restituisce un bool
  @override
  Future<bool> add(EventoDTO e) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named('INSERT INTO public."Evento" (nome, descrizione, data, approvato) '
            'VALUES (@nome, @descrizione, @data, @approvato) RETURNING id'),
        parameters: {
          'nome': e.nomeEvento,
          'descrizione': e.descrizione,
          'data': e.date,
          'approvato': e.approvato,
        },
      );
      var id = result[0][0];
      var result1 = await connection.execute(
          Sql.named('INSERT INTO public."Immagine" (immagine, id_evento) '
              'VALUES (@immagine, @id_evento)'),
          parameters: {
            'immagine': e.immagine,
            'id_evento': id
          });

      var result2 = await connection.execute(
          Sql.named('INSERT INTO public."Indirizzo" (via, citta, provincia, id_evento) '
              'VALUES (@via, @citta, @provincia, @id_evento)'),
          parameters: {
            'via': e.via,
            'citta': e.citta,
            'provincia': e.provincia,
            'id_evento': id
          });

      var result3 = await connection.execute(
          Sql.named('INSERT INTO public."Contatti" (email, sito, id_evento) '
              'VALUES (@email, @sito, @id_evento)'),
          parameters: {
            'email': e.email,
            'sito': e.sito,
            'id_evento': id,
          });

      await connector.closeConnection();
      if (result1.affectedRows != 0 &&
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

  /// Metodo che, dato un id, verifica se esiste un evento con quel determinato id e restituisce un bool in base al risultato
  @override
  Future<bool> existById(int id) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named('SELECT * FROM public."Evento" WHERE id = @id'),
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

  /// Metodo che permette di ottenere una lista contenente tutti gli eventi presenti all'interno del database
  @override
  Future<List<EventoDTO>> findAll() async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
          Sql.named('SELECT  e.id, e.nome, e.descrizione, e.data, e.approvato, c.email,'
              'c.sito, i.immagine, ind.via, ind.citta, ind.provincia, FROM public."Evento" as e, public."Contatti" as c, public."Immagine" as i, public."Indirizzo" as ind'
              'WHERE e.id = c.id_evento AND e.id = i.id_evento AND e.id = ind.id_evento')); // verificare se funziona

      // Mappa i risultati della query in oggetti SupportoMedicoDTO
      List<EventoDTO> eventi = result.map((row) {
        return EventoDTO.fromJson(row.toColumnMap());
      }).toList();

      return eventi;
    } catch (e) {
      developer.log(e.toString());
      return [];
    } finally {
      await connector.closeConnection();
    }
  }

  /// Metodo che, dato un id, permette di ottenere l'evento con quel determinato id, se esiste, altrimenti restituisce null
  @override
  Future<EventoDTO?> findById(int id) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named('SELECT  e.id, e.nome, e.descrizione, e.data, e.approvato, c.id, c.email,'
            'c.sito, i.immagine, ind.via, ind.citta, ind.provincia, FROM public."Evento" as e, public."Contatti" as c, public."Immagine" as i, public."Indirizzo" as ind'
            'WHERE e.id = @id AND e.id = c.id_evento AND e.id = i.id_evento AND e.id = ind.id_evento'),
        parameters: {'id': id},
      );
      if (result.isNotEmpty) {
        return EventoDTO.fromJson(result.first.toColumnMap());
      }
    } catch (e) {
      developer.log(e.toString());
      return null;
    } finally {
      await connector.closeConnection();
    }
    return null;
  }

  /// Metodo che, dato un id, elimina l'evento dal database con quel determinato id se esiste, e in base al risultato dell'operazione restituisce un bool
  @override
  Future<bool> removeById(int id) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named('DELETE FROM public."Evento" WHERE id = @id'),
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

  /// Metodo che, dato un oggetto EventoDTO, permette l'update di un determinato evento con i campi di quello passato come parametro. In base al risultato dell'operazione, restituisce un bool
  @override
  Future<bool> update(EventoDTO e) async {
    try {
      Connection connection = await connector.openConnection();
      var result1 = await connection.execute(
        Sql.named('UPDATE public."Evento" SET nome = @nome, descrizione = @descrizione '
            'data = @data, approvato = @approvato'
            'WHERE id = @id'),
        parameters: {
          'id': e.id,
          'nome': e.nomeEvento,
          'descrizione': e.descrizione,
          'data': e.date,
          'approvato': e.approvato
        },
      );

      var result2 = await connection.execute(
        Sql.named('UPDATE public."Contatti" SET email = @email, sito = @sito, '
            'WHERE id_evento = @id_evento'),
        parameters: {
          'email': e.email,
          'sito': e.sito,
          'id_evento': e.id,
        },
      );

      var result3 = await connection.execute(
        Sql.named('UPDATE public."Indirizzo" SET via = @via, citta = @citta, provincia = @provincia'
            'WHERE id_evento = @id_evento'),
        parameters: {
          'via': e.via,
          'citta': e.citta,
          'provincia': e.provincia,
          'id_evento': e.id
        },
      );

      var result4 = await connection.execute(
          Sql.named('UPDATE public."Immagine" SET immagine = @immagine'
              'WHERE id_evento = @id_evento'),
          parameters: {'immagine': e.immagine, 'id_evento': e.id});

      if (result1.affectedRows != 0 &&
          result2.affectedRows != 0 &&
          result3.affectedRows != 0 &&
          result4.affectedRows != 0) {
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
