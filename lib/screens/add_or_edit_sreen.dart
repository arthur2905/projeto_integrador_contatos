import 'package:flutter/material.dart';
import 'package:teste_projeto/repository/contact_repository.dart';
import '../models/contact.dart';

// ignore: must_be_immutable
class AddOrEditScreen extends StatefulWidget {
  Contact? contact;

  AddOrEditScreen({super.key, this.contact});

  @override
  AddOrEditScreenState createState() => AddOrEditScreenState();
}

class AddOrEditScreenState extends State<AddOrEditScreen> {
  final _repository = ContactRepository();

  @override
  Widget build(BuildContext context) {
    final nameController =
        TextEditingController(text: widget.contact?.name ?? '');
    final emailController =
        TextEditingController(text: widget.contact?.email ?? '');
    final phoneController =
        TextEditingController(text: widget.contact?.phone ?? '');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 89, 162, 223),
        title: Text(
            widget.contact == null ? 'Adicionar Contato' : 'Editar Contato'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                key: const Key('name_field'),
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nome')),
            TextField(
                key: const Key('email_field'),
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email')),
            TextField(
                key: const Key('phone_field'),
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Telefone')),
            const SizedBox(height: 36),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  key: const Key('salvar'),
                  onPressed: () async {
                    final newContact = Contact(
                      id: widget.contact?.id,
                      name: nameController.text,
                      email: emailController.text,
                      phone: phoneController.text,
                    );
                    if (widget.contact == null) {
                      await _repository.insertContact(newContact);
                    } else {
                      await _repository.updateContact(newContact);
                    }
                    Navigator.pop(context);
                  },
                  child: Text(widget.contact == null ? 'Adicionar' : 'Salvar'),
                ),
                const SizedBox(width: 36),
                ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
