import 'package:flutter/material.dart';
import 'package:teste_projeto/repository/contact_repository.dart';
import '../models/contact.dart';
import 'add_or_edit_sreen.dart';

class ContactScreen extends StatefulWidget {
  final Contact contact;

  const ContactScreen({super.key, required this.contact});

  @override
  ContactScreenState createState() => ContactScreenState();
}

class ContactScreenState extends State<ContactScreen> {
  final _repository = ContactRepository();
  late Contact _contact;

  @override
  void initState() {
    super.initState();
    _contact = widget.contact;
  }

  Widget _buildInfoSection(IconData icon, String info) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 138, 185, 223),
        borderRadius: BorderRadius.circular(96),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 24),
          Icon(icon, size: 36.0),
          const SizedBox(width: 24),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              info,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  void _loadInfos() async {
    Contact contact = await _repository.getContact(_contact.id);
    setState(() {
      _contact = contact;
    });
  }

  Future<void> deleteContact(Contact contact) async {
    await _repository.deleteContact(contact.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 89, 162, 223),
        title: const Text('Contato'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: const CircleAvatar(
                backgroundColor: Color.fromARGB(255, 122, 178, 224),
                radius: 96,
                child: Icon(
                  Icons.person,
                  size: 96,
                ),
              ),
            ),
            const SizedBox(height: 96),
            _buildInfoSection(Icons.person, _contact.name),
            const SizedBox(height: 36),
            _buildInfoSection(Icons.email, _contact.email),
            const SizedBox(height: 36),
            _buildInfoSection(Icons.phone, _contact.phone),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
            IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async => {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AddOrEditScreen(contact: _contact))),
                      _loadInfos(),
                    }),
            IconButton(
              color: Colors.red,
              icon: const Icon(Icons.delete),
              onPressed: () async => {
                await showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    content:
                        const Text('Tem certeza que deseja excluir o contato?'),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              onPressed: () async => {
                                    await deleteContact(_contact),
                                    Navigator.pop(context),
                                    Navigator.pop(context)
                                  },
                              child: const Text('Excluir')),
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancelar')),
                        ],
                      ),
                    ],
                  ),
                ),
              },
            ),
          ])),
    );
  }
}

class GradientLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.grey.withOpacity(0.3),
          Colors.grey,
          Colors.grey.withOpacity(0.3),
        ],
        stops: [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Desenhar a linha
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
