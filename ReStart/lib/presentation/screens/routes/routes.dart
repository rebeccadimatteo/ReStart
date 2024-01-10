import 'package:flutter/material.dart';
import 'package:restart_all_in_one/presentation/screens/home/home_ads.dart';
import 'package:restart_all_in_one/presentation/screens/home/home_ca.dart';
import '../alloggi_temporanei/alloggi_temporanei.dart';
import '../annunci_di_lavoro/annuncio_di_lavoro.dart';
import '../corsi_di_formazione/corso_di_formazione.dart';
import '../eventi/eventi.dart';
import '../home/home_utente.dart';
import '../login_signup/login.dart';
import '../login_signup/signup.dart';
import '../login_signup/start.dart';
import '../supporto_medico/supporto_medico.dart';
import '../utente/profilo.dart';

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

  //NB: I DETTAGLI DELLE SEZIONI NEGLI ADS NON SONO A PRIORITA ALTA
  //static const String dettagliannuncioAds = '/annunciDiLavoroAds/dettagliAds';
  static const String alloggiAds = '/alloggiTemporaneiAds';

  //static const String dettaglialloggioAds = '/alloggiTemporaneiAds/dettagliAds';
  static const String eventiAds = '/communityEventsAds';

  //static const String dettaglieventoAds = '/communityEventsAds/dettagliAds';
  static const String corsiAds = '/corsiDiFormazioneAds';

  //static const String dettaglicorsoAds = '/corsiDiFormazioneAds/dettagliAds';
  static const String supportiAds = '/supportiMediciAds';

  //static const String dettaglisupportoAds = '/supportiMediciAds/dettagliAds';
  static const String richieste = '/richieste';

  /// Definizione di tutte le [AppRoutes]
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => Home(),
      homeADS: (context) => HomeAds(),
      homeUtente: (context) => HomeUtente(),
      homeCA: (context) => HomeCA(),
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
      /*annunciAds: (context) => AnnunciDiLavoroAds(),
      //dettagliannuncioAds: (context) => DetailsLavoroAds(),
      alloggiAds: AlloggiTemporaneiAds(),
      //dettaglialloggioAds: DetailsAllogioAds(),
      eventiAds: CommunityEventsAds(),
      //dettaglieventoAds: DetailsEventoAds(),
      corsiAds: CorsoDiFormazioneAds(),
      //dettaglicorsoAds: DetailsCorsoAds(),
      supportiAds: SupportoMedicoAds(),
      richieste: Richieste(),
      //dettaglisupportoAds: DetailsSupportoAds(), */
    };
  }
}
