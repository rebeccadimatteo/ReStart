import 'package:flutter/material.dart';
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
  static const String start = '/start';
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

  /// Definizione di tutte le [AppRoutes]
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => HomeUtente(),
      start: (context) => Home(),
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
    };
  }
}
