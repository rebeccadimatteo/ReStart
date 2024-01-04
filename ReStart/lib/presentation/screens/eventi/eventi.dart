import 'package:flutter/material.dart';
import '../../components/generic_app_bar.dart';

class CommunityEvents extends StatelessWidget {
  List<int> eventi = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  // findALl -> List<evento> eventi

  @override
  Widget build(BuildContext context) {
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
                'Community Events',
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
              itemCount: eventi.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsEvento(eventi),
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
                            'https://img.freepik.com/free-vector/men-success-laptop-relieve-work-from-home-computer-great_10045-646.jpg?size=338&ext=jpg&ga=GA1.1.1546980028.1703635200&semt=ais'),
                      ),
                      title: Text('Evento',
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

class DetailsEvento extends StatelessWidget {
  DetailsEvento(List<int> eventi);

  @override
  Widget build(BuildContext context) {
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
                      'https://img.freepik.com/free-vector/men-success-laptop-relieve-work-from-home-computer-great_10045-646.jpg?size=338&ext=jpg&ga=GA1.1.1546980028.1703635200&semt=ais'),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Nome Evento',
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
          const Expanded(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Contatti',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        Text('example@example.com'),
                        Text('www.example.com'),
                        SizedBox(height: 20),
                        Text(
                          'Informazioni',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        Text('Data / Ora'),
                      ],
                    ),
                  )))
        ],
      ),
    );
  }
}
