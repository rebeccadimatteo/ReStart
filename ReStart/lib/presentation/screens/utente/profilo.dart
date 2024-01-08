import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../utils/utils.dart';
import '../../components/generic_app_bar.dart';
import '../routes/routes.dart';

class Profilo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double buttonWidth = screenWidth * 0.1;
    double buttonHeight = screenWidth * 0.1;

    return Scaffold(
      appBar: GenericAppBar(
        showBackButton: true,
      ),
      endDrawer: GenericAppBar.buildDrawer(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ListTile(
                leading: CircleAvatar(
                  radius: screenWidth * 0.1,
                  backgroundImage: const NetworkImage(
                    'https://img.freepik.com/free-photo/real-estate-broker-agent-presenting-consult-customer-decision-making-sign-insurance-form-agreement_1150-15023.jpg?w=996&t=st=1703846100~exp=1703846700~hmac=f81b22dab9dc2a0900a3cc79de365b5f367c1c4442d434f369a5e82f12cde1f9',
                  ),
                ),
                title: const Text(
                  'NOME UTENTE',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: screenWidth * 0.1),
              Column(
                children: [
                  buildProfileField(
                      'Email', 'example@example.com', screenWidth),
                  buildProfileField('Nome', 'esempio', screenWidth),
                  buildProfileField('Cognome', 'esempio', screenWidth),
                  buildProfileField(
                      'Data di nascita', 'esempio', screenWidth),
                  buildProfileField(
                      'Luogo di nascita', 'esempio', screenWidth),
                  buildProfileField('Genere', 'esempio', screenWidth),
                  buildProfileField('Password', '********', screenWidth),
                  buildProfileField('Lavoro adatto', 'esempio', screenWidth),
                ],
              ),
              SizedBox(height: screenWidth * 0.1),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.modificaprofilo,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[200],
                  foregroundColor: Colors.black,
                  shadowColor: Colors.grey,
                  elevation: 10,
                  minimumSize: Size(buttonWidth, buttonHeight),
                ),
                child: const Text(
                  'MODIFICA',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfiloEdit extends StatelessWidget {
  Uint8List? _image;

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    _image = img;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double avatarSize = screenWidth * 0.3;

    return Scaffold(
      appBar: GenericAppBar(
        showBackButton: true,
      ),
      endDrawer: GenericAppBar.buildDrawer(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.08),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: avatarSize,
                          height: avatarSize,
                          child: CircleAvatar(
                            backgroundImage: _image != null
                                ? MemoryImage(_image!)
                                : Image
                                .asset('images/avatar.png')
                                .image,
                          ),
                        ),
                        Positioned(
                          bottom: -1,
                          left: screenWidth * 0.18,
                          child: IconButton(
                            onPressed: selectImage,
                            icon: Icon(Icons.add_a_photo_sharp),
                          ),
                        )
                      ],
                    ),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'Nome utente',
                      ),
                    ),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                      ),
                    ),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'Nome',
                      ),
                    ),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'Cognome',
                      ),
                    ),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'Data di nascita',
                      ),
                    ),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'Luogo di nascita',
                      ),
                    ),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'Genere',
                      ),
                    ),
                    const TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenWidth * 0.1),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.profilo,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.black,
                  shadowColor: Colors.grey,
                  elevation: 10,
                  minimumSize: Size(screenWidth * 0.1, screenWidth * 0.1),
                ),
                child: const Text(
                  'APPLICA MODIFICHE',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildProfileField(String label, String value, double screenWidth) {
  return ListTile(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$label: ',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    ),
  );
}
