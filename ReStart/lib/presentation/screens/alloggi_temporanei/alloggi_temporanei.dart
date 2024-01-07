import 'package:flutter/material.dart';
import '../../components/generic_app_bar.dart';

/// Schermata che mostra una lista di alloggi temporanei disponibili.
class AlloggiTemporanei extends StatelessWidget {
  final List<int> alloggiTemporanei = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  // findALl -> List<AlloggiTemporanei> alloggiTemporanei

  @override
  Widget build(BuildContext context) {
    /// Restituisce uno scaffold, dove appbar e drawer sono ricavati dal file generic_app_bar.dart.
    return Scaffold(
      appBar: GenericAppBar(
        showBackButton: true,
      ),
      endDrawer: GenericAppBar.buildDrawer(context),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(10),
              color: Colors.white,
              child: const Text(
                'Alloggi Disponibili',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: ListView.builder(
              itemCount: alloggiTemporanei.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsAlloggio(alloggiTemporanei),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(left: 5, bottom: 5, right: 5),
                    child: ListTile(
                      visualDensity: VisualDensity(vertical: 4, horizontal: 4),
                      minVerticalPadding: 50,
                      minLeadingWidth: 80,
                      tileColor: Colors.grey,
                      leading: CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(
                            'https://img.freepik.com/free-photo/real-estate-broker-agent-presenting-consult-customer-decision-making-sign-insurance-form-agreement_1150-15023.jpg?w=996&t=st=1703846100~exp=1703846700~hmac=f81b22dab9dc2a0900a3cc79de365b5f367c1c4442d434f369a5e82f12cde1f9'),
                      ),
                      title: Text('Alloggio',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Descrizione'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

///Classe che builda il widget per mostrare i dettagli di un alloggio temporaneo selezionato.
class DetailsAlloggio extends StatelessWidget {
  DetailsAlloggio(List<int> alloggioTemporaneo);

  @override
  Widget build(BuildContext context) {
    /// Restituisce uno scaffold, dove appbar e drawer sono ricavati dal file generic_app_bar.dart.
    return Scaffold(
      appBar: GenericAppBar(
        showBackButton: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      'https://img.freepik.com/free-photo/real-estate-broker-agent-presenting-consult-customer-decision-making-sign-insurance-form-agreement_1150-15023.jpg?w=996&t=st=1703846100~exp=1703846700~hmac=f81b22dab9dc2a0900a3cc79de365b5f367c1c4442d434f369a5e82f12cde1f9'),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Nome Alloggio',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum, ',
            ),
          ),
          Flexible(
            child: Container(),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Contatti',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Text('example@example.com'),
                Text('www.example.com'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

