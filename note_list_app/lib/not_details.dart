import 'package:flutter/material.dart';
import 'package:note_list_app/models/kategori.dart';
import 'package:note_list_app/utils/database_helper.dart';

class NotDetail extends StatefulWidget {
  String title;
  NotDetail(this.title, {super.key});

  @override
  State<NotDetail> createState() => _NotDetailState();
}

class _NotDetailState extends State<NotDetail> {
  var formKey = GlobalKey<FormState>();
  late List<Kategori> allKategori;
  late DatabaseHelper db;
  int kategoriID = 1;
  static var oncelikler = ["Düşük", "Orta", "Yüksek"];
  int secilenOncelik = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      allKategori = <Kategori>[];
      db = DatabaseHelper();
      Create();
    });
  }

  Future<void> Create() async {
    await db.kategorileriGetir().then((value) {
      for (Map<String, dynamic> maps in value) {
        allKategori.add(Kategori.fromMap(maps));
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: allKategori.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              "Kategori:",
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 2,
                              horizontal: 12,
                            ),
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.redAccent,
                                width: 1,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                items: kategoriItemCreate(),
                                value: kategoriID,
                                onChanged: (value) {
                                  setState(() {
                                    kategoriID = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: "Not başliğini giriniz",
                            labelText: "Başlik",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: "Not içeriğini giriniz",
                            labelText: "İçerik",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              "Öncelik:",
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 2,
                              horizontal: 12,
                            ),
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.redAccent,
                                width: 1,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                items: oncelikler.map((e) {
                                  return DropdownMenuItem<int>(
                                    value: oncelikler.indexOf(e),
                                    child: Text(
                                      e,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  );
                                }).toList(),
                                value: secilenOncelik,
                                onChanged: (value) {
                                  setState(() {
                                    secilenOncelik = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ));
  }

  List<DropdownMenuItem<int>> kategoriItemCreate() {
    var newList = allKategori.map((e) {
      return DropdownMenuItem(
        value: e.kategoriID,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            e.kategoriBaslik.toString(),
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    }).toList();
    return newList;
  }
}


/*

Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 48,
                ),
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.redAccent,
                    width: 2,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                child: DropdownButtonHideUnderline(
                  child: allKategori.isEmpty
                      ? const CircularProgressIndicator()
                      : DropdownButton<int>(
                          items: kategoriItemCreate(),
                          onChanged: (value) {
                            setState(() {
                              kategoriID = value!;
                            });
                          },
                          value: kategoriID,
                        ),
                ),
              ),
            )
          ],
        ),
      ),

 */