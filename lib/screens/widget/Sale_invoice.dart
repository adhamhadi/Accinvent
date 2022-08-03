
import 'dart:convert';

import 'package:barcode_scanner/qrscreens/readqr.dart';
import 'package:barcode_scanner/screens/widget/choose_customer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/Customer.dart';
import '../../models/sale_Invoice_model.dart';
import '../main_menu.dart';
import 'final_ivoice.dart';
import 'header_widget.dart';



class SaleInvoice extends StatelessWidget{

  final sale_Invoice_model sale_invoice_model;


  SaleInvoice(this.sale_invoice_model);

  //Customers customer = new Customers();
  //List<Products> products = [];

  //final int value1=10123456789;

   int total_price=0;


  @override
  void initState() {


  }


  @override
  Widget build(BuildContext context) {
    print(total_price);
    return Scaffold(

        backgroundColor: Colors.white,
        body:SingleChildScrollView(child:

         Column(
            children:[
              Container(
                height: 25,
                child: const HeaderWidget(200,false,Icons.shopping_cart),
              ),
                Text(' : فاتورة بيع لـ\n${sale_invoice_model.customer.getname}',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.black),textAlign: TextAlign.center,),

              Container(// table of products
                height: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // for(Map<String, String> element in list_products){
                    //   Row(
                    //     children: [
                    //       Text(element['quantity'].toString()),
                    //     ],
                    //   ),
                    // }

                    Expanded(
                        child: ListView.builder(
                          itemCount: sale_invoice_model.products.length,
                            itemBuilder: build_list))

                  ],
                ),

              ),
              const SizedBox(height: 10,),

              Container(
                padding: EdgeInsets.all(30),
                margin: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black,width: 2.0)
                ),
                child: Column(
                   crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('$total_price :  قيمة الفاتورة',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
                    Divider(),
                    SizedBox(height: 7.0,),
                    Text(sale_invoice_model.dept_value.toString()+' :  قيمة الديون',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
                    Divider(),
                    SizedBox(height: 7.0,),
                    Text(sale_invoice_model.total_price.toString()+' : المبلغ المستحق',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
                    Divider(),
                    SizedBox(height: 40.0,),

                  ],
                ),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:[
                    ElevatedButton(
                        style:  ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white70),
                          elevation: MaterialStateProperty.all(4),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),

                            ),
                          ),
                        ),
                        child:Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child:Text('تأكيد'.toUpperCase(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
                        ),
                        onPressed:() {
                          sale_invoice_model.products.forEach((element) {
                            total_price=update_price(element.unit_price, int.parse(element.quantity));
                          });
                           sale_invoice_model.total_price=total_price;
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>finalInvoice( sale_invoice_model,)));
                        }
                    ),
                    //  SizedBox(width: 7.0,),
                    ElevatedButton(
                        style:  ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white70),
                          elevation: MaterialStateProperty.all(4),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),

                            ),
                          ),
                        ),
                        child:Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child:Text('إضـافة'.toUpperCase(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
                        ),
                        onPressed:() {
                          Navigator.push(context,  MaterialPageRoute(builder: (context)=>ScanScreen(sale_invoice_model: sale_invoice_model,)));
                        }
                    ),
                    // SizedBox(width: 7.0,),
                    ElevatedButton(
                        style:  ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white70),
                          elevation: MaterialStateProperty.all(4),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),

                            ),
                          ),
                        ),
                        child:Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child:Text('إلغـاء'.toUpperCase(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
                        ),
                        onPressed:() {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => menuPage()
                              ),
                              ModalRoute.withName("/Home"));
                        }
                    ),

                  ]
              ),

            ],
        ),
        ),
    );
  }

  int update_price(int price, int quantity){
    total_price = total_price + (price*quantity);
    return total_price;
  }

  Widget build_list(BuildContext context, int index){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      textDirection: TextDirection.rtl,
      children: [
        // total_price=total_price+ sale_invoice_model.soled_products[index].price*sale_invoice_model.soled_products[index].quantity,
        Text(sale_invoice_model.products[index].product_name+'         '+sale_invoice_model.products[index].unit_price.toString()+'      '+sale_invoice_model.products[index].unit_price.toString()),
        //Text(sale_invoice_model.soled_products[index].price.toString()),
        //Text(sale_invoice_model.soled_products[index].quantity.toString()),
       // Text(sale_invoice_model.soled_products[index].price.toString()),

      ],
    );
  }

}
