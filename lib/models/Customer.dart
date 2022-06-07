
class Customers {
  var customer_id, name, phone, type;
  Customers({this.customer_id, this.name, this.phone, this.type});
  factory  Customers.fromJson(Map<String, dynamic> json){
    return Customers(
      customer_id: json['id'],
      name:json['name'],
      phone:json['phone'],
      type:json['type'],
    );
  }
  String get getname=>name;
  String get getType => type;
}