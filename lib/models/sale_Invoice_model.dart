

import 'dart:convert';

import 'package:barcode_scanner/models/Customer.dart';
import 'package:barcode_scanner/models/soled_product.dart';

// String ToJson(sale_Invoice_model data) => json.encode(data.tojson());
class sale_Invoice_model {
  Customers customer;
  var user_id, total_price, amount_paid, saledept_id, dept_value;
   List<soled_product> products;
  sale_Invoice_model(
    this.user_id,
    this.total_price,
    this.amount_paid,
    this.saledept_id,
    this.dept_value,
     this.products,
     this.customer,
   );

  Map<String,dynamic> tojson()=>{
    // List<Map>? products = this.products!=null?this.products.map((i)=>i.tojson()).toList():null;
      'user_id':user_id.toString(),
      'customer_id':customer.customer_id.toString(),
      'total_price':total_price.toString(),
      'amount_paid':amount_paid.toString(),
      'products':List<dynamic>.from(products.map((e) => e.tojson())),

     };

  }

