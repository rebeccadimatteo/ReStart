import 'package:flutter/material.dart';
import 'package:restart/presentation/screens/inserimento_alloggio/inserimento_alloggio.dart';
import 'package:restart/presentation/screens/inserimento_corso/inserimento_corso.dart';
import 'package:restart/presentation/screens/inserimento_supporto/inserimento_supporto.dart';
import 'package:restart/presentation/screens/utente/lista_utenti.dart';
import '../alloggi_temporanei/alloggi_temporanei.dart';
import '../alloggi_temporanei/alloggi_temporanei_ads.dart';
import '../annunci_di_lavoro/annunci_di_lavoro_pubblicati.dart';
import '../annunci_di_lavoro/annuncio_di_lavoro.dart';
import '../annunci_di_lavoro/annuncio_di_lavoro_ads.dart';
import '../annunci_di_lavoro/annuncio_di_lavoro_modify.dart';
import '../corsi_di_formazione/corso_di_formazione.dart';
import '../corsi_di_formazione/corso_di_formazione_ads.dart';
import '../eventi/eventi.dart';
import '../eventi/eventi_ads.dart';
import '../eventi/eventi_pubblicati.dart';
import '../eventi/evento_modify.dart';
import '../home/home_ads.dart';
import '../home/home_ca.dart';
import '../home/home_utente.dart';
import '../inserimento_annuncio/inserimento_annuncio.dart';
import '../inserimento_evento/inserimento_evento.dart';
import '../lavoro_adatto/lavoro_adatto.dart';
import '../lavoro_adatto/visualizza_lavoro_adatto.dart';
import '../login_signup/login.dart';
import '../login_signup/signup.dart';
import '../login_signup/start.dart';
import '../richieste/richieste.dart';
import '../supporto_medico/supporto_medico.dart';
import '../supporto_medico/supporto_medico_ads.dart';
import '../utente/lista_utenti_candidati.dart';
import '../utente/profilo.dart';

/// Classe che definisce le routes per la navigazione tra gli screens.
class AppRoutes {
  static const String home = '/';
  static const String homeUtente = '/homeUtente';
  static const String homeADS = '/homeAds';
  static const String homeCA = '/homeCa';
  static const String login = '/login';
  static const String signup = '/registrati';
  static const String alloggi = '/alloggiTemporanei';
  static const String dettaglialloggio = '/alloggiTemporanei/dettagli';
  static const String annunci = '/annunciDiLavoro';
  static const String dettagliannuncio = '/annunciDiLavoro/dettagli';
  static const String eventi = '/communityEvents';
  static const String dettaglievento = '/communityEvents/dettagli';
  static const String corsi = '/corsiDiFormazione';
  static const String dettaglicorso = '/corsiDiFormazione/dettagli';
  static const String supporti = '/supportiMedici';
  static const String dettaglisupporto = '/supportiMedici/dettagli';
  static const String profilo = '/profilo';
  static const String modificaprofilo = '/profilo/edit';
  static const String annunciAds = '/annunciDiLavoroAds';
  static const String dettagliannuncioAds = '/annunciDiLavoroAds/dettagliAds';
  static const String alloggiAds = '/alloggiTemporaneiAds';
  static const String dettaglialloggioAds = '/alloggiTemporaneiAds/dettagliAds';
  static const String eventiAds = '/communityEventsAds';
  static const String dettaglieventoAds = '/communityEventsAds/dettagliAds';
  static const String corsiAds = '/corsiDiFormazioneAds';
  static const String dettaglicorsoAds = '/corsiDiFormazioneAds/dettagliAds';
  static const String supportiAds = '/supportiMediciAds';
  static const String dettaglisupportoAds = '/supportiMediciAds/dettagliAds';
  static const String richiesteAds = '/richieste';
  static const String annuncipubblicati = '/annunciPubblicati';
  static const String dettagliannunciopub = '/annunciPubblicati/dettagli';
  static const String eventipubblicati = '/eventiPubblicati';
  static const String dettaglieventipub = '/eventiPubblicati/dettagli';
  static const String addevento = '/aggiungiEvento';
  static const String addannuncio = '/aggiungiAnnuncio';
  static const String modificaevento = '/modifyEvento';
  static const String modificalavoro = '/modifyAnnuncio';
  static const String lavoroadatto = '/lavoroAdatto';
  static const String listaCandidati = '/annunciPubblicati/listaCandidati';
  static const String profiloCandidato = '/annunciPubblicati/listaCandidati/profilo';
  static const String visualizzaLavoroAdatto = '/lavoroAdatto/visualizzaLavoroAdatto';
  static const String inserisciCorso = '/aggiungiCorso';
  static const String inserisciAlloggio = '/aggiungiAlloggio';
  static const String inserisciSupporto = '/aggiungiSupporto';
  static const String listaUtenti = '/listaUtenti';

  /// Definizione di tutte le [AppRoutes]
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => Home(),
      homeADS: (context) => HomeAds(),
      homeUtente: (context) => HomeUtente(),
      homeCA: (context) => HomeCa(),
      login: (context) => LoginPage(),
      signup: (context) => SignUpPage(),
      alloggi: (context) => AlloggiTemporanei(),
      dettaglialloggio: (context) => DetailsAlloggio(),
      annunci: (context) => AnnunciDiLavoro(),
      dettagliannuncio: (context) => DetailsLavoro(),
      eventi: (context) => CommunityEvents(),
      dettaglievento: (context) => DetailsEvento(),
      corsi: (context) => CorsoDiFormazione(),
      dettaglicorso: (context) => DetailsCorso(),
      supporti: (context) => SupportoMedico(),
      dettaglisupporto: (context) => DetailsSupporto(),
      profilo: (context) => Profilo(),
      modificaprofilo: (context) => ProfiloEdit(),
      annuncipubblicati: (context) => AnnunciDiLavoroPubblicati(),
      eventipubblicati: (context) => CommunityEventsPubblicati(),
      dettagliannunciopub: (context) => DetailsLavoroPub(),
      dettaglieventipub: (context) => DetailsEventoPub(),
      addevento: (context) => InserisciEvento(),
      addannuncio: (context) => InserisciLavoro(),
      annunciAds: (context) => AnnunciDiLavoroAds(),
      dettagliannuncioAds: (context) => DetailsLavoroAds(),
      alloggiAds: (context) => AlloggiTemporaneiAds(),
      dettaglialloggioAds: (context) => DetailsAlloggioAds(),
      eventiAds: (context) => CommunityEventsAds(),
      dettaglieventoAds: (context) => DetailsEventoAds(),
      corsiAds: (context) => CorsoDiFormazioneAds(),
      dettaglicorsoAds: (context) => DetailsCorsoAds(),
      supportiAds: (context) => SupportoMedicoAds(),
      dettaglisupportoAds: (context) => DetailsSupportoAds(),
      richiesteAds: (context) => Richieste(),
      modificaevento: (context) => ModifyEvento(),
      lavoroadatto: (context) => LavoroAdatto(),
      listaCandidati: (context) => ListaUtentiCandidati(),
      visualizzaLavoroAdatto: (context) => VisualizzaLavoroAdatto(),
      profiloCandidato: (context) => ProfiloCandidato(),
      modificalavoro: (context) => ModifyLavoro(),
      inserisciCorso: (context) => InserisciCorso(),
      inserisciAlloggio: (context) => InserisciAlloggio(),
      inserisciSupporto: (context) => InserisciSupporto(),
      listaUtenti: (context) => ListaUtenti(),
    };
  }
}
