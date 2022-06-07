import 'dart:convert';

import 'package:barcode_scanner/models/buy_Invoice_model.dart';
import 'package:barcode_scanner/models/reciept_product.dart';
import 'package:barcode_scanner/models/supplier.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../main_menu.dart';
import 'add_buy_invoice.dart';
import 'header_widget.dart';

class chooseSupplier extends StatefulWidget {
  @override
  _chooseSupplierState createState() => _chooseSupplierState();
}

class _chooseSupplierState extends State<chooseSupplier> {
  late SharedPreferences sharedPreferences;
  List data =[];
  late buy_Invoice_model buy_invoice_model;
  List<Supplier> _supplier = [];
  final double _headerHeight =220;

  @override
  void initState() {
    super.initState();
    fetchSupplier();
    List<reciept_product> _recipts=[];
    Supplier _supplier=Supplier() ;
    buy_invoice_model = buy_Invoice_model(null, null, null, null, _recipts, _supplier);

  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,

      body:SingleChildScrollView(child:
      Column(
          children:[
            Container(
              height: _headerHeight,
              child: HeaderWidget(_headerHeight,true,Icons.person_add),

            ),
            const Center(
              child:Text('اختيـار مورد',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.black),),
            ),
            Column(
              children: [

                DropdownButton(
                  focusColor:Colors.white38,
                  elevation: 4,
                  style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                  iconEnabledColor:Colors.black,
                  items:_supplier.map(( Supplier item) {
                    return DropdownMenuItem(
                      value: item.name.toString(),
                      child: Text(item.name),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  hint: const Text("اختيار مورد"),
                  onChanged: (String? value) {
                    setState(()  {
                    //  _chosenValue = value!;
                      //SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
                      final index=_supplier.indexWhere((element) => element.name==value);


                      buy_invoice_model.supplier = _supplier[index];

                      getdept();

                     Navigator.push(context,  MaterialPageRoute(builder: (context)=>BuyInvoice(buy_invoice_model: buy_invoice_model,)));
                    });
                  },
                ),


                SizedBox(height: 17.0,),
                ElevatedButton(
                    style:  ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white70),
                      shadowColor: MaterialStateProperty.all(Colors.black),
                      elevation: MaterialStateProperty.all(4),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),

                        ),
                      ),
                    ),
                    child:Padding(
                      padding: const EdgeInsets.fromLTRB(40, 15, 40, 7),
                      child:Text('إنشاء مورد'.toUpperCase(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
                    ),
                    onPressed:() {
                    }

                ),
                const SizedBox(height: 17.0,),
                ElevatedButton(
                    style:  ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white70),
                      shadowColor: MaterialStateProperty.all(Colors.black),
                      elevation: MaterialStateProperty.all(5),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),

                        ),
                      ),
                    ),
                    child:const Padding(
                      padding: EdgeInsets.fromLTRB(40, 15, 40, 7),
                      child:Text('رجــوع',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
                    ),
                    onPressed:() {
                      Navigator.pop(context,  MaterialPageRoute(builder: (context)=>menuPage()));
                    }

                ),
                SizedBox(height: 20.0,),
              ],
            ),

          ]
      ),
      ),


    );


  }

  Future <void> fetchSupplier() async {
    sharedPreferences=await SharedPreferences.getInstance();
    var token=sharedPreferences.getString('token').toString();
    final response =
    await http.get(Uri.parse("http://192.168.43.110:8888/api/supplier"), headers: <String,String>{
      'Authorization' : token,
    });
    if (response.statusCode == 200) {
      print(response.headers);
      var resBody=  json.decode(response.body)['data'];

      //print(resBody);
      setState(() {

        data =resBody ;
      });


    }
    else {
      throw Exception('Failed to load data.');}

  }

  Future <void> getdept() async {

    sharedPreferences=await SharedPreferences.getInstance();
    var token=sharedPreferences.getString('token').toString();
    int id = int.parse(sharedPreferences.getString('user_id').toString());
    //var _customerID = sharedPreferences.getString('customerid');
    final response =
    await http.get(Uri.parse("http://192.168.43.110:8888/api/RecieptDebt/show/${buy_invoice_model.supplier.id}"), headers: <String,String>{
      'Authorization' : token,
    });

    if (response.statusCode == 200) {
      var resBody=  json.decode(response.body)['data'];
      setState(() {
        buy_invoice_model.saledept_id = resBody['id'];
        buy_invoice_model.dept_value = resBody['debt_value'];

      });
    }
  }
}
