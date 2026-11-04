
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:faker/faker.dart' as faker_package;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:avatar_glow/avatar_glow.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(const MyApp());
}

class Contact {
  final String name;
  final String phone;
  final String email;
  final String category;
  final DateTime date;

  Contact({
    required this.name,
    required this.phone,
    required this.email,
    required this.category,
    required this.date,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Daftar Kontak',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  final faker_package.Faker faker = faker_package.Faker();

  final List<String> categories = [
    'Keluarga',
    'Teman',
    'Kerja',
  ];

  late final List<Contact> contacts;

  @override
  void initState() {
    super.initState();

    contacts = List.generate(15, (index) {
      return Contact(
        name: faker.person.name(),
        phone: faker.phoneNumber.us(),
        email: faker.internet.email(),
        category: categories[index % categories.length],
        date: DateTime.now().subtract(
          Duration(days: index * 3),
        ),
      );
    });
  }

  final List<Widget> pages = [];

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      ContactPage(contacts: contacts),
      SearchPage(categories: categories),
      const ProfilePage(),
    ];

    return Scaffold(
      body: pages[selectedIndex],

      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Colors.indigo,
        activeColor: Colors.white,
        color: Colors.white70,
        style: TabStyle.react,
        initialActiveIndex: 0,
        items: const [
          TabItem(
            icon: Icons.contacts,
            title: 'Kontak',
          ),
          TabItem(
            icon: Icons.search,
            title: 'Cari',
          ),
          TabItem(
            icon: Icons.person,
            title: 'Profil',
          ),
        ],
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}

class ContactPage extends StatelessWidget {
  final List<Contact> contacts;

  const ContactPage({
    super.key,
    required this.contacts,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Kontak',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),

      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Kontak',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${contacts.length} Kontak',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),

                    leading: CircleAvatar(
                      backgroundColor: Colors.indigo.shade100,
                      child: Text(
                        contact.name.isNotEmpty
                            ? contact.name[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    title: Text(
                      contact.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Telepon: ${contact.phone}'),
                          Text('Email: ${contact.email}'),
                          Text('Kategori: ${contact.category}'),
                          const SizedBox(height: 5),

                          Text(
                            'Ditambahkan pada: ${DateFormat(
                              'dd MMMM yyyy',
                              'id_ID',
                            ).format(contact.date)}',
                            style: const TextStyle(
                              color: Colors.indigo,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
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

class SearchPage extends StatefulWidget {
  final List<String> categories;

  const SearchPage({
    super.key,
    required this.categories,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cari Kontak',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            const Text(
              'Pilih Kategori Kontak',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            DropdownSearch<String>(
              items: (filter, props) {
                return widget.categories
                    .where(
                      (item) => item.toLowerCase().contains(
                        filter.toLowerCase(),
                      ),
                    )
                    .toList();
              },

              popupProps: const PopupProps.menu(
                showSearchBox: true,
                fit: FlexFit.loose,
              ),

              decoratorProps: const DropDownDecoratorProps(
                decoration: InputDecoration(
                  hintText: 'Pilih kategori',
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(),
                ),
              ),

              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
            ),

            const SizedBox(height: 25),

            if (selectedCategory != null)
              Card(
                elevation: 2,
                child: ListTile(
                  leading: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 35,
                  ),
                  title: const Text(
                    'Kategori dipilih',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(selectedCategory!),
                ),
              )
            else
              const Center(
                child: Text(
                  'Silakan pilih kategori kontak.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
      
            AvatarGlow(
              glowColor: Colors.indigo,
              duration: const Duration(milliseconds: 2000),
              repeat: true,
              animate: true,
              curve: Curves.easeInOut,
              child: const Material(
                elevation: 8,
                shape: CircleBorder(),
                child: CircleAvatar(
                  radius: 65,
                  backgroundColor: Colors.indigo,
                  child: Icon(
                    Icons.person,
                    size: 75,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Nama Mahasiswa',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Mahasiswa Sistem Informasi',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 25),

            Card(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: const ListTile(
                leading: Icon(
                  Icons.phone_android,
                  color: Colors.indigo,
                ),
                title: Text('Aplikasi Daftar Kontak'),
                subtitle: Text('Mobile Programming - Flutter'),
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Versi 1.0.0',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
