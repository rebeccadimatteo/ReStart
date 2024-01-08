import 'package:postgres/postgres.dart';
import 'dart:developer' as developer;
import '../../connection/connector.dart';
import '../../entity/supporto_medico_DTO.dart';
import 'supporto_medico_DAO.dart';


/// Questa classe rappresenta l'implementazione del dao del Supporto Medico
class SupportoMedicoDAOImpl implements SupportoMedicoDAO {
  Connector connector = Connector();

  ///metodo che permette di aggiungere un [SupportoMedicoDTO] nel DataBase
  ///restituisce true se l'operazione è andata a buon fine
  @override
  Future<bool> add(SupportoMedicoDTO sm) async {
    try {
      Connection connection = await connector.openConnection();
      var result1 = await connection.execute(
        Sql.named('INSERT INTO public."SupportoMedico" (nome, cognome, descrizione, tipo) '
            'VALUES (@nome, @cognome, @descrizione, @tipo) RETURNING id'),
        parameters: {
          'nome': sm.nomeMedico,
          'cognome': sm.cognomeMedico,
          'descrizione': sm.descrizione,
          'tipo': sm.tipo
        },
      );
      var id = result1[0][0];
      var result2 = await connection.execute(
          Sql.named('INSERT INTO public."Immagine" (immagine, id_supporto) '
              'VALUES (@immagine, @id_supporto)'),
          parameters: {
            'immagine': sm.immagine,
            'id_supporto': id
          });

      var result3 = await connection.execute(
          Sql.named('INSERT INTO public."Indirizzo" (via, citta, provincia, id_supporto) '
              'VALUES (@via, @citta, @provincia, @id_supporto)'),
          parameters: {
            'via': sm.via,
            'citta': sm.citta,
            'provincia': sm.provincia,
            'id_supporto': id
          });

      var result4 = await connection.execute(
          Sql.named('INSERT INTO public."Contatti" (email, num_telefono, id_supporto) '
              'VALUES (@email, @num_telefono, @id_supporto)'),
          parameters: {
            'email': sm.email,
            'num_telefono': sm.numTelefono,
            'id_supporto': id
          });

      await connector.closeConnection();
      if (result1.affectedRows != 0 && result2.affectedRows != 0 &&
          result3.affectedRows != 0 && result4.affectedRows != 0) {
        return true;
      }
      return false;
    }catch(e){
      developer.log(e.toString());
      return false;
    }finally{
      await connector.closeConnection();
    }
  }

  ///metodo che permette di verificare se un [SupportoMedicoDTO] è presente nel DataBase
  ///prende in input un [int] che rappresenta l'id del supporto medico e restituisce true se esiste
  @override
  Future<bool> existById(int id) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named('SELECT * FROM public."SupportoMedico" WHERE id = @id'),
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

  ///metodo che restituisce la lista di tutti i [SupportoMedicoDTO]presenti nel DataBase
  @override
  Future<List<SupportoMedicoDTO>> findAll() async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(Sql.named('SELECT  sm.id, sm.nome, sm.cognome, sm.descrizione, sm.tipo, c.id, c.num_telefono, c.email,'
          'c.sito, i.id, i.immagine, ind.id, ind.via, ind.citta, ind.provincia FROM public."SupportoMedico" as sm, public."Contatti" as c,'
          ' public."Immagine" as i, public."Indirizzo" as ind '
          'WHERE sm.id = c.id_supporto AND sm.id = i.id_supporto AND sm.id = ind.id_supporto')); // verificare se funziona

      List<SupportoMedicoDTO> supportiMedici = result.map((row) {
        return SupportoMedicoDTO.fromJson(row.toColumnMap());
      }).toList();

      return supportiMedici;
    } catch (e) {
      developer.log(e.toString());
      return [];
    }finally{
      await connector.closeConnection();
    }
  }

  ///metodo che restituisce un [SupportoMedicoDTO] se quest'ultimo è presente nel DataBase
  @override
  Future<SupportoMedicoDTO?> findById(int id) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named('SELECT  sm.id, sm.nome, sm.cognome, sm.descrizione, i.immagine, c.email, c.num_telefono, ind.via, ind.citta, ind.provincia '
            'FROM public."SupportoMedico" as sm, public."Immagine" as i, public."Contatti" as c, public."Indirizzo" as ind '
            'WHERE sm.id = @id AND sm.id = c.id_corso AND sm.id = i.id_corso AND sm.id = ind.id_corso'),
        parameters: {'id': id},
      );
      if (result.isNotEmpty) {
        return SupportoMedicoDTO.fromJson(result.first.toColumnMap());
      }
    } catch (e) {
      developer.log(e.toString());
      return null;
    }finally{
      await connector.closeConnection();
    }
    return null;
  }

  ///metodo che rimuove un [SupportoMedicoDTO] del DataBase
  ///restituisce true se l'operazione è andata a buon fine
  @override
  Future<bool> removeById(int id) async {
    try {
      Connection connection = await connector.openConnection();
      var result = await connection.execute(
        Sql.named('DELETE FROM public."SupportoMedico" WHERE id = @id'),
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

  ///metodo che aggiorna un [SupportoMedicoDTO] nel DataBase
  ///restituisce true se l'operazione è andata a buon fine
  @override
  Future<bool> update(SupportoMedicoDTO sm) async {
    try {
      Connection connection = await connector.openConnection();
      var result1 = await connection.execute (
        Sql.named('UPDATE public."SupportoMedico" SET nome = @nome, cognome = @cognome, '
            'descrizione = @descrizione '
            'WHERE id = @id'),
        parameters: {
          'id': sm.id,
          'nome': sm.nomeMedico,
          'cognome': sm.cognomeMedico,
          'descrizione': sm.descrizione,
        },
      );

      var result2 = await connection.execute (
        Sql.named('UPDATE public."Contatti" SET email = @email, num_telefono = @num_telefono '
            'WHERE id_supporto = @id_supporto'),
        parameters: {
          'email': sm.email,
          'num_telefono': sm.numTelefono,
          'idSupporto': sm.id,
        },
      );

      var result3 = await connection.execute (
        Sql.named('UPDATE public."Indirizzo" SET via = @via, citta = @citta, provincia = @provincia '
            'WHERE id_supporto = @id_supporto'),
        parameters: {
          'via': sm.via,
          'citta': sm.citta,
          'provincia': sm.provincia,
          'id_supporto': sm.id
        },
      );

      var result4 = await connection.execute(
          Sql.named('UPDATE public."Immagine" SET immagine = @immagine '
              'WHERE id_supporto = @id_supporto'),
          parameters: {
            'immagine': sm.immagine,
            'id_supporto': sm.id
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