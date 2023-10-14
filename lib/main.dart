import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_usinhg_app/person.dart';

void main() async {
  try {
    await Hive.initFlutter();
    Hive.registerAdapter(PersonAdapter());
    await Hive.openBox<Person>('personbox');
  } catch (e) {
    print('Error initializing Hive: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hive',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  final Box<Person> box = Hive.box<Person>('personbox');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My App'),
      ),
      body: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Name',
            ),
          ),
          const SizedBox(height: 10.0),
          TextField(
            controller: ageController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Age',
            ),
          ),
          const SizedBox(height: 10.0),
          TextButton(
            onPressed: () {
              setState(() {
                final me = Person(name: nameController.text, age: int.parse(ageController.text));
                box.put('me', me);
              });
            },
            child: const Text('Add'),
          ),
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ValueListenableBuilder(
                  valueListenable: box.listenable(),
                  builder: (context, Box<Person> box, child) {
                    return ListView.builder(
                      itemCount: box.length,
                      itemBuilder: (context, index) {
                        Person? person = box.getAt(index);
                        return ListTile(
                          title: Text(person!.name),
                          subtitle: Text('Age: ${person.age.toString()}'),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () {
              setState(() {
                box.clear();
              });
            },
            icon: const Icon(Icons.delete_outline),
            label: const Text('Delete All'),
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}
