
import 'dart:convert';
import 'dart:io';

import 'package:barcode_scanner/models/sale_Invoice_model.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scanner/screens/widget/read_invoice.dart';
import 'package:barcode_scanner/screens/widget/header_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme_helper/themes.dart';
import 'Sale_invoice.dart';
import 'package:http/http.dart' as http;

import '../main_menu.dart';
import 'Sale_invoice.dart';
import 'header_widget.dart';

class finalInvoice extends StatelessWidget {
  late SharedPreferences sharedPreferences;
  sale_Invoice_model sale_invoice_model;
  var totalPaidController=TextEditingController(text: '0');

  finalInvoice(this.sale_invoice_model); //final int value1=10123456789;
  @override
  Widget build(BuildContext context) {
    var total_cost=sale_invoice_model.total_price+sale_invoice_model.dept_value;
    // TODO: implement build
    return Scaffold(

      backgroundColor: Colors.white,
      body:SingleChildScrollView(child:

      Column(

        children:[
          Container(
            height: 200,
            child: const HeaderWidget(200,false,Icons.print),

          ),


          Text(' : فاتورة بيع لـ'+'\n'+sale_invoice_model.customer.getname,style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.black),textAlign: TextAlign.center,),



          Container(
            padding: const EdgeInsets.all(30),
            margin: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black,width: 3.0)
               ),
            //alignment: Alignment.topRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,

              children: [
                 Text(sale_invoice_model.total_price.toString()+'  :  قيمة المشتريات',style:  TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
                const Divider(),
                const SizedBox(height: 10.0,),
                 Text('${sale_invoice_model.dept_value.toString()}  :  قيمة الديون',style:  TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
                const Divider(),
                const SizedBox(height: 10.0,),
                 Text('${total_cost.toString()}:إجمالي المبلغ المستحق',style:  TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
                const Divider(),
                const SizedBox(height: 10.0,),
                TextField(
                  controller:totalPaidController,
                    onChanged:(totalPaidController)=>print(totalPaidController.toString()),
                  decoration: ThemeHelper().textInputDecoration( 'المبلغ', 'أدخل المبلغ المدفوع'),
                  keyboardType: TextInputType.number,

                ),

                const Divider(),
                const SizedBox(height: 10.0,),
                Text((total_cost-int.parse(totalPaidController.text.toString()) ).toString()+'  : المبلغ المتبقي',style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
                const Divider(),
                const SizedBox(height: 60.0,),
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
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child:Text('رجوع'.toUpperCase(),style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
                    ),
                    onPressed:() {
                      Navigator.pop(context,  MaterialPageRoute(builder: (context)=>SaleInvoice( sale_invoice_model)));
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
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child:Text('إتمام'.toUpperCase(),style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
                    ),
                    onPressed:() {
                      sale_invoice_model.total_price=total_cost;
                      sale_invoice_model.amount_paid=int.parse(totalPaidController.text);
                      commitInvoice();
                      Navigator.push(context,  MaterialPageRoute(builder: (context)=>readInvoice(sale_invoice_model)));
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
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child:Text('إلغـاء'.toUpperCase(),style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
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
  Future<void> commitInvoice() async {
    sharedPreferences=await SharedPreferences.getInstance();
    var token=sharedPreferences.getString('token').toString();
    sale_invoice_model.user_id =1;

    print(json.encode(sale_invoice_model.tojson()));
    print("products"+List<dynamic>.from(sale_invoice_model.products.map((e) => e.tojson())).toString(),);
    var response= await http.post(Uri.parse("http://192.168.43.110:8888/api/SaleInvoice"),
        headers: {'Authorization' :token},
         body:
         //json.encode(sale_invoice_model.tojson())
         {
           "user_id": sale_invoice_model.user_id.toString(),
           "customer_id": sale_invoice_model.customer.customer_id.toString(),
           "total_price": sale_invoice_model.total_price.toString(),
           "amount_paid": sale_invoice_model.amount_paid.toString(),
           "products":List<dynamic>.from(sale_invoice_model.products.map((e) => e.tojson())).toString(),
           //(sale_invoice_model.products.map((e) => e.tojson()).toList()).toString(),
        //    //List<dynamic>.from(sale_invoice_model.soled_products.map((e) => e.tojson())),
          }
         );
      if(response.statusCode==201){
      //  print(sale_invoice_model.tojson());
        print(response.body);
        print("jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj");
       // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Black field not allowed"),));
      } else {
        print(response.body);
      }
  }
}

