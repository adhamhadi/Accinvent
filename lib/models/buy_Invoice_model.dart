


import 'dart:convert';

import 'package:barcode_scanner/models/Customer.dart';
import 'package:barcode_scanner/models/reciept_product.dart';
import 'package:barcode_scanner/models/soled_product.dart';
import 'package:barcode_scanner/models/supplier.dart';

class buy_Invoice_model {

  Supplier supplier;
  var total_amount, amount_receved, saledept_id, dept_value;
  late List<reciept_product> reciept_products;


  buy_Invoice_model(
      this.total_amount,
      this.amount_receved,
      this.saledept_id,
      this.dept_value,
      this.reciept_products,
      this.supplier,
      );
  Map<String, dynamic> tojson()=><String, dynamic>{
    "supplier_id": supplier.id.toString(),
    //"saleDebt_id":saledept_id,
    "total_price":total_amount.toString(),
    "amount_paid":amount_receved.toString(),
    "products": json.encode(List<dynamic>.from(reciept_products.map((e) => e.tojson())))

  };

  @override
  String toString() {
    return 'buy_Invoice_model{supplier: $supplier, total_amount: $total_amount, amount_receved: $amount_receved, saledept_id: $saledept_id, dept_value: $dept_value}';
  }
}