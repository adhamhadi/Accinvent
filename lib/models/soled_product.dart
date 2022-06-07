import 'dart:convert';

String productsToJson(soled_product data) => json.encode(data.tojson());
class soled_product{
  soled_product(this.product_id, this.product_name, this.quantity, this.unit_price);
  var product_id, product_name, quantity, unit_price;
  // factory  soled_product.fromJson(Map<String, dynamic> json){
  //   return soled_product(
  //     product_id: json['product_id'],
  //     quantity: json['quantity'],
  //     unit_price: json['unit_price'],
  //   );
  // }
    Map<String,dynamic> tojson()=> {


      'product_id':product_id.toString(),
      'quantity':quantity.toString(),
      'unit_price':unit_price.toString(),
    };

  @override
  String toString() {
    return '{product_id: $product_id, quantity: $quantity, unit_price: $unit_price}';
  }
}
// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

// import 'dart:convert';
//
// Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));
//
// String welcomeToJson(Welcome data) => json.encode(data.toJson());
//
// class Welcome {
//   Welcome({
//     this.userId,
//     this.customerId,
//     this.totalPrice,
//     this.amountPaid,
//     this.products,
//   });
//
//   int userId;
//   int customerId;
//   int totalPrice;
//   int amountPaid;
//   List<Product> products;
//
//   factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
//     userId: json["user_id"],
//     customerId: json["customer_id"],
//     totalPrice: json["total_price"],
//     amountPaid: json["amount_paid"],
//     products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "user_id": userId,
//     "customer_id": customerId,
//     "total_price": totalPrice,
//     "amount_paid": amountPaid,
//     "products": List<dynamic>.from(products.map((x) => x.toJson())),
//   };
// }
//
// class Product {
//   Product({
//     this.productId,
//     this.quantity,
//     this.unitPrice,
//   });
//
//   String productId;
//   String quantity;
//   String unitPrice;
//
//  // factory Product.fromJson(Map<String, dynamic> json) => Product(
// //     productId: json["product_id"],
// //     quantity: json["quantity"],
// //     unitPrice: json["unit_price"],
// //   );
//
//   Map<String, dynamic> toJson() => {
//     "product_id": productId,
//     "quantity": quantity,
//     "unit_price": unitPrice,
//   };
// }
