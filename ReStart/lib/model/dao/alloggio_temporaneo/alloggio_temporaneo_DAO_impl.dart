import 'package:postgres/postgres.dart';
import 'dart:developer' as developer;
import '../../connection/connector.dart';
import '../../entity/alloggio_temporaneo_DTO.dart';
import 'alloggio_temporaneo_DAO.dart';

/// Implementazione del Data Access Object (DAO) per gli alloggi temporanei.
///
/// Implementazione di [AlloggioTemporaneoDAO] per interagire con un database PostgreSQL.
class AlloggioTemporaneoDAOImpl implements AlloggioTemporaneoDAO {
  Connector connector = Connector();

  /// Aggiunge un nuovo alloggio temporaneo al database.
  ///
  /// Utilizza [AlloggioTemporaneoDTO] per inserire i dati dell'alloggio nel database.
  /// In caso di successo, restituisce [true], altrimenti [false].
  @override
  Future<bool> add(AlloggioTemporaneoDTO at) async {
    try {
      Connection conn = await connector.openConnection();
      var result1 = await conn.execute(
          Sql.named(
              'INSERT INTO public."AlloggioTemporaneo" (nome, descrizione, tipo) '
              'VALUES (@nome, @descrizione, @tipo) RETURNING id'),
          parameters: {
            'nome': at.nome,
            'descrizione': at.descrizione,
            'tipo': at.tipo
          });
      var id = result1[0][0];
      var result2 = await conn.execute(
          Sql.named(
              'INSERT INTO public."Indirizzo" (via, citta, provincia, id_alloggio) '
              'VALUES (@via, @citta, @provincia, @id_alloggio)'),
          parameters: {
            'id_alloggio': id,
            'via': at.via,
            'citta': at.citta,
            'provincia': at.provincia
          });
      var result3 = await conn.execute(
          Sql.named('INSERT INTO public."Contatti" (email, sito, id_alloggio) '
              'VALUES (@email, @sito, @id_alloggio)'),
          parameters: {'id_alloggio': id, 'email': at.email, 'sito': at.sito});
      var result4 = await conn.execute(
          Sql.named('INSERT INTO public."Immagine" (immagine, id_alloggio) '
              'VALUES (@immagine, @id_alloggio)'),
          parameters: {'id_alloggio': id, 'immagine': at.immagine});

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

  /// Controlla se un alloggio temporaneo esiste nel database in base al suo [id].
  ///
  /// Restituisce [true] se l'alloggio esiste, altrimenti [false].
  @override
  Future<bool> existById(int id) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named('SELECT * FROM public."AlloggioTemporaneo" WHERE id = @id'),
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

  /// Recupera tutti gli alloggi temporanei dal database.
  ///
  /// Restituisce una lista di [AlloggioTemporaneoDTO] con tutti gli alloggi trovati.
  @override
  Future<List<AlloggioTemporaneoDTO>> findAll() async {
    try {
      Connection connection = await connector.openConnection();

      var result = await connection.execute(
          'SELECT  at.id, at.nome, at.descrizione, at.tipo, ind.citta, ind.provincia, ind.via, '
          'c.email, c.sito, i.immagine FROM public."AlloggioTemporaneo" at, public."Contatti" c, public."Immagine" i, public."Indirizzo" ind '
          'WHERE at.id = c.id_alloggio AND at.id = i.id_alloggio AND at.id = ind.id_alloggio');

      List<AlloggioTemporaneoDTO> alloggi = result.map((row) {
        return AlloggioTemporaneoDTO.fromJson(row.toColumnMap());
      }).toList();

      return alloggi;
    } catch (e) {
      developer.log(e.toString());
      return [];
    } finally {
      await connector.closeConnection();
    }
  }

  /// Trova un alloggio temporaneo in base al suo [id].
  ///
  /// Restituisce un oggetto [AlloggioTemporaneoDTO] se trovato, altrimenti `null`.
  @override
  Future<AlloggioTemporaneoDTO?> findById(int id) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named(
            'SELECT at.id, at.nome, at.descrizione, at.tipo, ind.citta, ind.provincia, ind.via '
            'c.email, c.sito, i.immagine FROM public."AlloggioTemporaneo" at, '
            'public."Contatti" as c, public."Immagine" as i, public."Indirizzo" as ind '
            'WHERE at.id = @id AND @id = c.id_alloggio AND @id = i.id_alloggio AND @id = ind.id_alloggio'),
        parameters: {'id': id},
      );
      if (result.isNotEmpty) {
        return AlloggioTemporaneoDTO.fromJson(result.first.toColumnMap());
      }
    } catch (e) {
      developer.log(e.toString());
      return null;
    } finally {
      await connector.closeConnection();
    }
    return null;
  }

  /// Rimuove un alloggio temporaneo dal database in base al suo [id].
  ///
  /// Restituisce [true] se l'eliminazione è andata a buon fine, altrimenti [false].
  @override
  @override
  Future<bool> removeById(int id) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named('DELETE FROM public."AlloggioTemporaneo" WHERE id = @id'),
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

  /// Aggiorna i dettagli di un alloggio temporaneo esistente nel database.
  ///
  /// Prende un [AlloggioTemporaneoDTO] aggiornato come parametro.
  /// Restituisce [true] se l'aggiornamento è andato a buon fine, altrimenti [false].
  @override
  Future<bool> update(AlloggioTemporaneoDTO at) async {
    try {
      Connection connection = await connector.openConnection();
      var result1 = await connection.execute(
        Sql.named(
            'UPDATE public."AlloggioTemporaneo" SET nome = @nome, descrizione = @descrizione, '
            'tipo = @tipo '
            'WHERE id = @id'),
        parameters: {
          'id': at.id,
          'nome': at.nome,
          'descrizione': at.descrizione,
          'tipo': at.tipo,
        },
      );

      var result2 = await connection.execute(
        Sql.named('UPDATE public."Contatti" SET email = @email, sito = @sito '
            'WHERE id_alloggio = @id_alloggio'),
        parameters: {
          'email': at.email,
          'sito': at.sito,
          'id_alloggio': at.id,
        },
      );

      var result3 = await connection.execute(
        Sql.named(
            'UPDATE public."Indirizzo" SET via = @via, citta = @citta, provincia = @provincia '
            'WHERE id_alloggio = @id_alloggio'),
        parameters: {
          'via': at.via,
          'citta': at.citta,
          'provincia': at.provincia,
          'id_alloggio': at.id
        },
      );

      var result4 = await connection.execute(
          Sql.named('UPDATE public."Immagine" SET immagine = @immagine '
              'WHERE id_alloggio = @id_alloggio'),
          parameters: {'immagine': at.immagine, 'id_alloggio': at.id});

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
