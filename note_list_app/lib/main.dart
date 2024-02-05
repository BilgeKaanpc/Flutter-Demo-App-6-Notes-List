import 'package:flutter/material.dart';
import 'package:note_list_app/models/kategori.dart';
import 'package:note_list_app/not_details.dart';
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
  DatabaseHelper databaseHelper = DatabaseHelper();
  var scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  NoteList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Center(child: Text("Note List")),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "kategoriEkle",
            shape: const CircleBorder(),
            onPressed: () {
              kategoriEkleDialog(context);
            },
            tooltip: "Kategori Ekle",
            mini: true,
            child: const Icon(Icons.add_circle),
          ),
          FloatingActionButton(
            heroTag: "notEkle",
            shape: const CircleBorder(),
            tooltip: "Not Ekle",
            onPressed: () => {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NotDetail("Yeni Not")))
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
      body: Container(),
    );
  }

  void goNoteDetaild(BuildContext context) {}

  Future<dynamic> kategoriEkleDialog(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    String? newKategoriName;

    return showDialog(
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
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onSaved: (newValue) {
                    newKategoriName = newValue!;
                  },
                  decoration: const InputDecoration(
                      label: Text("Kategori Adı"),
                      border: OutlineInputBorder()),
                  validator: (value) {
                    if (value!.length < 3) {
                      return "En az 3 karakter giriniz";
                    }
                    return null;
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
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      databaseHelper
                          .kategoriEkle(
                              Kategori(kategoriBaslik: newKategoriName))
                          .then((value) {
                        if (value > 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Kategori Eklendi"),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      });
                    }
                  },
                  child: const Text("Kaydet"),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
