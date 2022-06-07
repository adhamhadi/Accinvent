class Supplier {
  var id, name;
  Supplier({this.id, this.name});
  factory  Supplier.fromJson(Map<String, dynamic> json){
    return Supplier(
      id: json['id'],
      name:json['name'],
    );
  }
  int get getId=>id;
  String get getname=>name;

}