import 'dart:async';
import '../../../../model/entity/alloggio_temporaneo_DTO.dart';
import '../../../../model/entity/corso_di_formazione_DTO.dart';
import '../../../../model/entity/supporto_medico_DTO.dart';

/// Interfaccia per il service di reintegrazione.
///
/// Definisce i metodi per la gestione dei corsi di formazione, alloggi temporanei e supporti medici.
abstract class ReintegrazioneService {
  /// Restituisce un elenco di tutti i corsi di formazione disponibili.
  ///
  /// Utilizza per ottenere informazioni dettagliate su ciascun corso di formazione.
  Future<List<CorsoDiFormazioneDTO>> corsiDiFormazione();

  /// Restituisce un elenco di tutti gli alloggi temporanei disponibili.
  ///
  /// Utilizza per ottenere informazioni dettagliate su ciascun alloggio temporaneo.
  Future<List<AlloggioTemporaneoDTO>> alloggiTemporanei();

  /// Restituisce un elenco di tutti i supporti medici disponibili.
  ///
  /// Utilizza per ottenere informazioni dettagliate su ciascun supporto medico.
  Future<List<SupportoMedicoDTO>> supportiMedici();

  /// Aggiunge un nuovo corso di formazione al sistema.
  ///
  /// Prende in input un oggetto [CorsoDiFormazioneDTO] contenente i dettagli del corso.
  Future<bool> addCorso(CorsoDiFormazioneDTO c);

  /// Aggiunge un nuovo supporto medico al sistema.
  ///
  /// Prende in input un oggetto [SupportoMedicoDTO] contenente i dettagli del supporto medico.
  Future<bool> addSupportoMedico(SupportoMedicoDTO sm);

  /// Aggiunge un nuovo alloggio temporaneo al sistema.
  ///
  /// Prende in input un oggetto [AlloggioTemporaneoDTO] contenente i dettagli dell'alloggio.
  Future<bool> addAlloggio(AlloggioTemporaneoDTO at);

  /// Elimina un alloggio temporaneo specificato dal suo ID.
  ///
  /// Accetta l'ID dell'alloggio da eliminare.
  Future<bool> deleteAlloggio(int idAlloggio);

  /// Elimina un corso di formazione specificato dal suo ID.
  ///
  /// Accetta l'ID del corso da eliminare.
  Future<bool> deleteCorso(int idCorso);

  /// Elimina un supporto medico specificato dal suo ID.
  ///
  /// Accetta l'ID del supporto medico da eliminare.
  Future<bool> deleteSupporto(int idSupporto);
}
