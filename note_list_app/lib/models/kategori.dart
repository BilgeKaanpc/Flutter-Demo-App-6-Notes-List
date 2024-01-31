// ignore_for_file: public_member_api_docs, sort_constructors_first
class Kategori {
  int? kategoriID;
  String? kategoriBaslik;
  Kategori({
    this.kategoriBaslik,
  });
  Kategori.withID(this.kategoriID, this.kategoriBaslik);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["kategoriID"] = kategoriID;
    map["kategoriBaslik"] = kategoriBaslik;
    return map;
  }

  Kategori.fromMap(Map<String, dynamic> map) {
    kategoriID = map["kategoriID"];
    kategoriBaslik = map["kategoriBaslik"];
  }

  @override
  String toString() {
    return "Kategori{kategoriID: $kategoriID, kategoriBaslik: $kategoriBaslik}";
  }
}
