import 'package:flutter/material.dart';
import 'package:note_list_app/models/kategori.dart';
import 'package:note_list_app/utils/database_helper.dart';

class Kategoriler extends StatefulWidget {
  const Kategoriler({super.key});

  @override
  State<Kategoriler> createState() => _KategorilerState();
}

class _KategorilerState extends State<Kategoriler> {
  late List<Kategori> allKategori;
  late DatabaseHelper db;
  @override
  void initState() {
    db = DatabaseHelper();

    allKategori = <Kategori>[];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (allKategori.isEmpty) {
      updateKategoriler();
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text("Kategoriler"),
        ),
        body: ListView.builder(
          itemCount: allKategori.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () => kategoriUpdate(allKategori[index]),
              title: Text(allKategori[index].kategoriBaslik!),
              trailing: GestureDetector(
                onTap: () => kategoriSil(allKategori[index].kategoriID!),
                child: const Icon(Icons.delete),
              ),
              leading: const Icon(Icons.category),
            );
          },
        ));
  }

  void kategoriUpdate(Kategori kate) {
    kategoriUpdateDialog(context, kate);
  }

  Future<dynamic> kategoriUpdateDialog(BuildContext context, Kategori kate) {
    var formKey = GlobalKey<FormState>();
    String? newKategoriName;

    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text(
            "Kategori Güncelle",
            style: TextStyle(color: Colors.blue),
          ),
          children: [
            Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: kate.kategoriBaslik,
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
                      db
                          .kategoriGuncelle(
                              Kategori.withID(kate.kategoriID, newKategoriName))
                          .then((value) {
                        if (value != 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Kategori Güncellendi"),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          setState(() {
                            updateKategoriler();
                          });
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

  void kategoriSil(int value) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Kategori Sil"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                    "Kategoriyi sildiğinizide onunla ilgili tüm notlar da silinecektir!"),
                ButtonBar(
                  children: [
                    TextButton(
                      child: const Text("Vazgeç"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text(
                        "Sil",
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        db.kategoriSil(value).then((value) {
                          if (value != 0) {
                            setState(() {
                              updateKategoriler();
                              Navigator.of(context).pop();
                            });
                          }
                        });
                      },
                    )
                  ],
                ),
              ],
            ),
          );
        },
        barrierDismissible: false);
  }

  void updateKategoriler() {
    db.kategoriList().then((value) {
      setState(() {
        allKategori = value;
      });
    });
  }
}
