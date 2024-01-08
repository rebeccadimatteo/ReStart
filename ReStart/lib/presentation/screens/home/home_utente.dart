import 'package:flutter/material.dart';
import '../../components/generic_app_bar.dart';
import '../routes/routes.dart';

/// Classe che builda il widget della schermata di home dell'utente
class HomeUtente extends StatelessWidget {
  final List<int> lavori = [1, 2, 3, 4, 5];
  final List<int> eventi = [1, 2, 3, 4, 5];

  HomeUtente({super.key});

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
                itemCount: lavori.length,
                itemBuilder: (context, pagePosition) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.eventi,
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
                itemCount: lavori.length,
                itemBuilder: (context, pagePosition) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.annunci,
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

