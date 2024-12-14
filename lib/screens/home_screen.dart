import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../repository/contact_repository.dart';
import '../screens/contact_screen.dart';
import 'add_or_edit_sreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final _repository = ContactRepository();
  final _searchController = TextEditingController();
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final contacts = await _repository.getAllContacts();

    setState(() {
      _contacts = contacts;
      _filteredContacts = contacts;
    });
  }

  void _filterContacts(String query) {
    setState(() {
      _filteredContacts = _contacts
          .where((contact) =>
              contact.name.toLowerCase().contains(query.toLowerCase()) ||
              contact.email.toLowerCase().contains(query.toLowerCase()) ||
              contact.phone.contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    _filteredContacts
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 89, 162, 223),
        title: const Text('Lista de Contatos'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterContacts,
              decoration: const InputDecoration(
                labelText: 'Pesquisar',
                prefixIcon: Icon(Icons.search),
                border: UnderlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredContacts.length,
              itemBuilder: (_, index) {
                final contact = _filteredContacts[index];
                final currentLetter = contact.name[0].toUpperCase();
                final bool showHeader = index == 0 ||
                    currentLetter !=
                        _filteredContacts[index - 1].name[0].toUpperCase();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showHeader)
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            currentLetter,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    if (showHeader)
                      Divider(
                        thickness: 1,
                        color: Colors.grey.shade400,
                      ),
                    ListTile(
                      title: Text(contact.name),
                      key: const Key("infos"),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ContactScreen(contact: contact),
                          ),
                        );
                        _loadContacts();
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(255, 89, 162, 223),
        child: IconButton(
          onPressed: () async => {
            await Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddOrEditScreen())),
            _loadContacts(),
          },
          icon: const Icon(Icons.add),
          color: Colors.black,
        ),
      ),
    );
  }
}
