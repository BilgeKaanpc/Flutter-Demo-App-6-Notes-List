import 'package:flutter/material.dart';
import 'package:note_list_app/main.dart';
import 'package:note_list_app/models/kategori.dart';
import 'package:note_list_app/models/note.dart';
import 'package:note_list_app/utils/database_helper.dart';

class NotDetail extends StatefulWidget {
  String title;
  Not? duzenlenecekNot;
  NotDetail(this.title, this.duzenlenecekNot, {super.key});

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
  String notBaslik = "";
  String notIcerik = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      allKategori = <Kategori>[];
      db = DatabaseHelper();
      create();
    });
  }

  Future<void> create() async {
    await db.kategorileriGetir().then((value) {
      for (Map<String, dynamic> maps in value) {
        allKategori.add(Kategori.fromMap(maps));
      }
    });

    if (widget.duzenlenecekNot != null) {
      kategoriID = widget.duzenlenecekNot!.kategoriID!;
      secilenOncelik = widget.duzenlenecekNot!.notOncelik!;
    } else {
      kategoriID = 1;
      secilenOncelik = 0;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
                            padding: EdgeInsets.symmetric(horizontal: 8),
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
                          initialValue: widget.duzenlenecekNot != null
                              ? widget.duzenlenecekNot!.notBaslik
                              : "",
                          validator: (text) {
                            if (text!.length < 3) {
                              return "En az 3 karakter olmali";
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            notBaslik = newValue!;
                          },
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
                          initialValue: widget.duzenlenecekNot != null
                              ? widget.duzenlenecekNot!.notIcerik
                              : "",
                          onSaved: (newValue) {
                            notIcerik = newValue!;
                          },
                          maxLines: 4,
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
                      ButtonBar(
                        alignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.grey)),
                            child: const Text("Vazgeç"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();

                                var suan = DateTime.now();
                                debugPrint(db.dataFormat(suan));

                                if (widget.duzenlenecekNot == null) {
                                  db
                                      .notEkle(Not(
                                          kategoriID: kategoriID,
                                          notBaslik: notBaslik,
                                          notIcerik: notIcerik,
                                          notTarih: suan.toString(),
                                          notOncelik: secilenOncelik))
                                      .then((value) {
                                    if (value != 0) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const MyApp()),
                                      );
                                    }
                                  });
                                } else {
                                  db
                                      .notGuncelle(Not.withID(
                                          notID: widget.duzenlenecekNot!.notID,
                                          kategoriID: kategoriID,
                                          notBaslik: notBaslik,
                                          notIcerik: notIcerik,
                                          notTarih: suan.toString(),
                                          notOncelik: secilenOncelik))
                                      .then((value) {
                                    if (value != 0) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const MyApp()),
                                      );
                                    }
                                  });
                                }
                              }
                            },
                            style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.green)),
                            child: const Text(
                              "Kaydet",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      )
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
            style: const TextStyle(fontSize: 20),
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