import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:restart_all_in_one/model/entity/annuncio_di_lavoro_DTO.dart';
import '../../../model/entity/evento_DTO.dart';
import '../../../utils/jwt_constants.dart';
import '../../../utils/jwt_utils.dart';
import '../../components/generic_app_bar.dart';
import '../routes/routes.dart';
import "package:http/http.dart" as http;

/// Classe che builda il widget della schermata di home dell'utente
class HomeUtente extends StatefulWidget {
  @override
  State<HomeUtente> createState() => _HomeUtenteState();
}

class _HomeUtenteState extends State<HomeUtente> {
  List<EventoDTO> eventi = [];
  List<AnnuncioDiLavoroDTO> annunci = [];

  void initState(){
    super.initState();
    fetchEventiFromServer();
    fetchLavoriFromServer();
  }
  Future<void> checkUser(BuildContext context) async {
    var token = await SessionManager().get("token");
    if(token != null) {
      if (!JWTUtils.verifyAccessToken(accessToken: await token, secretKey: JWTConstants.accessTokenSecretKeyForUtente)) {
        Navigator.pushNamed(context, AppRoutes.home);
      } else {
        print("benvenuto!!");
      }
    } else{
      Navigator.pushNamed(context, AppRoutes.home);
    }
  }
  Future<void> fetchEventiFromServer() async {
    final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/gestioneEvento/visualizzaEventi'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody.containsKey('eventi')) {
        final List<EventoDTO> data =
            List<Map<String, dynamic>>.from(responseBody['eventi'])
                .map((json) => EventoDTO.fromJson(json))
                .toList();
        setState(() {
          eventi = data;
        });
      } else {
        print('Chiave "eventi" non trovata nella risposta.');
      }
    } else {
      print('Errore');
    }
  }

  Future<void> fetchLavoriFromServer() async {
    final response = await http.post(Uri.parse(
        'http://10.0.2.2:8080/gestioneLavoro/visualizzaLavori'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody.containsKey('annunci')) {
        final List<AnnuncioDiLavoroDTO> data =
        List<Map<String, dynamic>>.from(responseBody['annunci'])
            .map((json) => AnnuncioDiLavoroDTO.fromJson(json))
            .toList();
        setState(() {
          annunci = data;
        });
      } else {
        print('Chiave "annunci" non trovata nella risposta.');
      }
    } else {
      print('Errore');
    }
  }

  @override
  Widget build(BuildContext context) {
    /// Restituisce uno scaffold, dove appbar e drawer presi dal file generic_app_bar.dart.
    /// Il tutto è ancora statico, manca la connessione al backend.
    return Scaffold(
      appBar: GenericAppBar(
        showBackButton: false,
      ),
      endDrawer: GenericAppBar.buildDrawer(context),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: Text(
                'QUESTA SETTIMANA...',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 150,
              child: PageView.builder(
                itemCount: eventi.length,
                itemBuilder: (context, index) {
                  EventoDTO evento = eventi[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.dettaglievento,
                        arguments: evento,
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: Image.network(
                        'https://img.freepik.com/free-vector/men-success-laptop-relieve-work-from-home-computer-great_10045-646.jpg?size=338&ext=jpg&ga=GA1.1.1546980028.1703635200&semt=ais',
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: Text(
                'COSA ASPETTI?',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 150,
              child: PageView.builder(
                itemCount: annunci.length,
                itemBuilder: (context, index) {
                  AnnuncioDiLavoroDTO annuncio = annunci[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.dettagliannuncio,
                        arguments: annuncio,
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: Image.network(
                        'https://img.freepik.com/free-vector/men-success-laptop-relieve-work-from-home-computer-great_10045-646.jpg?size=338&ext=jpg&ga=GA1.1.1546980028.1703635200&semt=ais',
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              childAspectRatio: 1.1,
            ),
            delegate: SliverChildListDelegate([
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.eventi,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  color: Colors.blue[200],
                  child: const Center(
                    child: Text(
                      'SCOPRI IL LAVORO CHE FA PER TE!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.alloggi,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  color: Colors.blue[200],
                  child: const Center(
                    child: Text(
                      'TROVA UN ALLOGGIO',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.corsi,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  color: Colors.blue[200],
                  child: const Center(
                    child: Text(
                      'IMPARA QUALCOSA DI NUOVO',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.supporti,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  color: Colors.blue[200],
                  child: const Center(
                    child: Text(
                      'PRENDITI CURA DI TE STESSO',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
