import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MedecinProvider(),
      child: MaterialApp(
        home: MedecinFormScreen(),
      ),
    );
  }
}

class MedecinProvider extends ChangeNotifier {
  List<Medecin> _medecins = [];

  List<Medecin> get medecins => _medecins;

  void ajouterMedecin(Medecin medecin) {
    _medecins.add(medecin);
    notifyListeners();
  }
}

class Medecin {
  final String nom;
  final String specialite;
  final String contact;

  Medecin({required this.nom, required this.specialite, required this.contact});
}

class MedecinFormScreen extends StatefulWidget {
  @override
  _MedecinFormScreenState createState() => _MedecinFormScreenState();
}

class _MedecinFormScreenState extends State<MedecinFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _specialiteController = TextEditingController();
  final _contactController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un Médecin'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomController,
                decoration: InputDecoration(labelText: 'Nom'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _specialiteController,
                decoration: InputDecoration(labelText: 'Spécialité'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une spécialité';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _contactController,
                decoration: InputDecoration(labelText: 'Contact'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un contact';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    final medecin = Medecin(
                      nom: _nomController.text,
                      specialite: _specialiteController.text,
                      contact: _contactController.text,
                    );
                    Provider.of<MedecinProvider>(context, listen: false).ajouterMedecin(medecin);
                    _nomController.clear();
                    _specialiteController.clear();
                    _contactController.clear();
                  }
                },
                child: Text('Ajouter Médecin'),
              ),
              Expanded(
                child: Consumer<MedecinProvider>(
                  builder: (context, provider, child) {
                    return ListView.builder(
                      itemCount: provider.medecins.length,
                      itemBuilder: (context, index) {
                        final medecin = provider.medecins[index];
                        return ListTile(
                          title: Text(medecin.nom),
                          subtitle: Text('${medecin.specialite} - ${medecin.contact}'),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
