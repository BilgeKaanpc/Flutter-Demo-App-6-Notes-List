import 'dart:io';

import 'package:flutter/material.dart';
import 'package:note_list_app/kategori_islem.dart';
import 'package:note_list_app/models/kategori.dart';
import 'package:note_list_app/models/note.dart';
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
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: ListTile(
                    leading: const Icon(Icons.category),
                    title: const Text("Kategoriler"),
                    onTap:() {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Kategoriler()));
                    },
                  ),
                ),
              ];
            },
          )
        ],
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
                  builder: (context) => NotDetail("Yeni Not", null)))
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
      body: const Notes(),
    );
  }


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

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  late List<Not> allNotes;
  late DatabaseHelper db;
  @override
  void initState() {
    allNotes = <Not>[];
    db = DatabaseHelper();

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    setState(() {
      
    });
    return FutureBuilder(
      future: db.notList(),
      builder: (context, AsyncSnapshot<List<Not>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          sleep(const Duration(milliseconds: 500));
          allNotes = snapshot.data!;
          return ListView.builder(
            itemCount: allNotes.length,
            itemBuilder: (context, index) {
              return ExpansionTile(
                leading: oncelikCreate(allNotes[index].notOncelik!),
                title: Text(
                  allNotes[index].notBaslik!,
                ),
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Kategori",
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                allNotes[index].kategoriBaslik!,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Oluşturulma Tarihi",
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                db.dataFormat(
                                    DateTime.parse(allNotes[index].notTarih!)),
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "İçerik :\n${allNotes[index].notIcerik!}",
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        ButtonBar(
                          alignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              onPressed: () => notSil(allNotes[index].notID!),
                              child: const Text(
                                "Sil",
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => NotDetail(
                                        "Notu Düzenle", allNotes[index])));
                              },
                              child: const Text(
                                "Güncelle",
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              );
            },
          );
        } else {
          return const Center(
            child: Text("Yükleniyor..."),
          );
        }
      },
    );
  }

  notSil(int iD) {
    db.notSil(iD).then((value) {
      if (value != 0) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Not Silindi.")));
        setState(() {});
      }
    });
  }

  oncelikCreate(int oncelik) {
    switch (oncelik) {
      case 0:
        return CircleAvatar(
          backgroundColor: Colors.redAccent.shade100,
          child: const Text(
            "Az",
            style: TextStyle(color: Colors.white),
          ),
        );
      case 1:
        return CircleAvatar(
          backgroundColor: Colors.redAccent.shade400,
          child: const Text(
            "Orta",
            style: TextStyle(color: Colors.white),
          ),
        );
      case 2:
        return CircleAvatar(
          backgroundColor: Colors.redAccent.shade700,
          child: const Text(
            "Acil",
            style: TextStyle(color: Colors.white),
          ),
        );
    }
  }
}
