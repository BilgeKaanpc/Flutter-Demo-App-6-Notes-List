import 'package:flutter/material.dart';
import 'package:note_list_app/utils/database_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flutter Demo",
      theme: ThemeData(),
      home: NoteList(),
    );
  }
}

class NoteList extends StatelessWidget {
  const NoteList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Note List")),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            shape: const CircleBorder(),
            onPressed: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    
                    title: const Text(
                      "Kategori Ekle",
                      style: TextStyle(color: Colors.blue),
                    ),
                    children: [
                      Form(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            decoration: const InputDecoration(
                                label: Text("Kategori Adı"),
                                border: OutlineInputBorder()),
                            validator: (value) {
                              if (value!.length < 3) {
                                return "En az 3 karakter giriniz";
                              }
                            },
                          ),
                        ),
                      ),
                      ButtonBar(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Vazgeç"),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text("Kaydet"),
                          ),
                        ],
                      )
                    ],
                  );
                },
              );
            },
            tooltip: "Kategori Ekle",
            mini: true,
            child: const Icon(Icons.add_circle),
          ),
          FloatingActionButton(
            shape: const CircleBorder(),
            tooltip: "Not Ekle",
            onPressed: () {},
            child: const Icon(Icons.add),
          ),
        ],
      ),
      body: Container(),
    );
  }
}
