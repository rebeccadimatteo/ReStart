import 'package:postgres/postgres.dart';
import 'dart:developer' as developer;

import '../../connection/connector.dart';
import '../../entity/annuncio_di_lavoro_DTO.dart';
import 'annuncio_di_lavoro_DAO.dart';

/// Questa classe, `AnnuncioLavoroDAOImpl`, implementa l'interfaccia `AnnuncioDiLavoroDAO`
/// e si occupa di gestire la persistenza degli annunci di lavoro in un database PostgreSQL.
class AnnuncioLavoroDAOImpl implements AnnuncioDiLavoroDAO {
  Connector connector = Connector();
  ///metodo `add` che aggiunge un nuovo annuncio nel database
  @override
  Future<bool> add(AnnuncioDiLavoroDTO annuncio) async {
    try {
      Connection connection = await connector.openConnection();
      var result1 = await connection.execute(
        Sql.named('INSERT INTO public."AnnuncioDiLavoro" (nome, descrizione, approvato) '
            'VALUES (@nome, @descrizione, @approvato) RETURNING id'),
        parameters: {
          'nome': annuncio.nome,
          'descrizione': annuncio.descrizione,
          'approvato': annuncio.approvato,
        },
      );
      var id = result1[0][0];
      var result2 = await connection.execute(
          Sql.named('INSERT INTO public."Immagine" (immagine, id_annuncio) '
              'VALUES (@immagine, @id_annuncio)'),
          parameters: {
            'immagine': annuncio.immagine,
            'id_supporto': id
          });

      var result3 = await connection.execute(
          Sql.named('INSERT INTO public."Indirizzo" (via, citta, provincia, id_annuncio) '
              'VALUES (@via, @citta, @provincia, @id_annuncio)'),
          parameters: {
            'via': annuncio.via,
            'citta': annuncio.citta,
            'provincia': annuncio.provincia,
            'id_supporto': id
          }
      );

      var result4 = await connection.execute(
          Sql.named('INSERT INTO public."Contatti" (email, num_telefono, id_annuncio) '
              'VALUES (@email, @num_telefono, @id_annuncio)'),
          parameters: {
            'email': annuncio.email,
            'num_telefono': annuncio.numTelefono,
            'id_annuncio': id
          }
      );

      if (result1.affectedRows != 0 && result2.affectedRows != 0 &&
          result3.affectedRows != 0 && result4.affectedRows != 0) {
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
  ///metodo `existById` che verifica l'esistenza di un annuncio basato sull'ID
  @override
  Future<bool> existById(int id) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named('SELECT * FROM public."AnnuncioDiLavoro" WHERE id = @id'),
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
    }finally{
      await connector.closeConnection();
    }
  }
  /// metodo `findAll` che recupera tutti gli annunci di lavoro dal database
  @override
  Future<List<AnnuncioDiLavoroDTO>> findAll() async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(Sql.named('SELECT adl.nome, adl.descrizione, adl.approvato, ind.via, ind.citta, ind.provincia,'
          ' i.immagine, c.email, c.num_telefono  FROM public."AnnuncioDiLavoro" as adl, public."Contatti" as c, '
          ' public."Immagine" as i, public."Indirizzo" as ind '
          'WHERE adl.id = c.id_annuncio AND adl.id = i.id_annuncio AND adl.id = ind.id_annuncio')); // verificare se funziona

      List<AnnuncioDiLavoroDTO> annunci = result.map((row) {
        return AnnuncioDiLavoroDTO.fromJson(row.toColumnMap());
      }).toList();

      return annunci;
    } catch (e) {
      developer.log(e.toString());
      return [];
    }finally{
      await connector.closeConnection();
    }
  }
  /// metodo `findById` che trova un annuncio basato sull'ID
  @override
  Future<AnnuncioDiLavoroDTO?> findById(int id) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named('SELECT  adl.id, adl.nome, adl.descrizione, adl.approvato, ind.via, ind.citta, ind.provincia,'
            ' i.immagine, c.email, c.num_telefono  FROM public."AnnuncioDiLavoro" as adl, public."Contatti" as c,'
            ' public."Immagine" as i, public."Indirizzo" as ind'
            ' WHERE adl.id = @id AND adl.id = c.id_annuncio AND adl.id = i.id_annuncio AND adl.id = ind.id_annuncio'),
        parameters: {'id': id},
      );
      if (result.isNotEmpty) {
        return AnnuncioDiLavoroDTO.fromJson(result.first.toColumnMap());
      }
    } catch (e) {
      developer.log(e.toString());
      return null;
    }finally{
      await connector.closeConnection();
    }
    return null;
  }
  ///metodo `removeById` che rimuove un annuncio basato sull'ID
  @override
  Future<bool> removeById(int id) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named('DELETE FROM public."AnnuncioDiLavoro" WHERE id = @id'),
        parameters: {'id': id},
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
  ///metodo `update` che aggiorna un annuncio esistente nel database
  @override
  Future<bool> update(AnnuncioDiLavoroDTO annuncio) async {
    try {
      Connection connection = await connector.openConnection();
      var result1 = await connection.execute (
        Sql.named('UPDATE public."AnnuncioDiLavoro" SET nome = @nome, descrizione = @descrizione, '
            'approvato = @approvato '
            'WHERE id = @id'),
        parameters: {
          'id': annuncio.id,
          'nome': annuncio.nome,
          'descrizione': annuncio.descrizione,
          'approvato': annuncio.approvato
        },
      );

      var result2 = await connection.execute (
        Sql.named('UPDATE public."Contatti" SET email = @email, num_telefono = @num_telefono '
            'WHERE id_annuncio = @id_annuncio'),
        parameters: {
          'email': annuncio.email,
          'num_telefono': annuncio.numTelefono,
          'id_annuncio': annuncio.id,
        },
      );

      var result3 = await connection.execute (
        Sql.named('UPDATE public."Indirizzo" SET via = @via, citta = @citta, provincia = @provincia '
            'WHERE id_annuncio = @id_annuncio'),
        parameters: {
          'via': annuncio.via,
          'citta': annuncio.citta,
          'provincia': annuncio.provincia,
          'id_annuncio': annuncio.id
        },
      );

      var result4 = await connection.execute(
          Sql.named('UPDATE public."Immagine" SET immagine = @immagine '
              'WHERE id_annuncio = @id_annuncio'),
          parameters: {
            'immagine': annuncio.immagine,
            'id_annuncio': annuncio.id
          }
      );

      if (result1.affectedRows != 0 && result2.affectedRows != 0 && result3.affectedRows != 0 && result4.affectedRows != 0){
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