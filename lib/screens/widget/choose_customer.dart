// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:barcode_scanner/models/sale_Invoice_model.dart';
import 'package:barcode_scanner/models/soled_product.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scanner/screens/widget/choose_supplier.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/Customer.dart';
import '../../qrscreens/readqr.dart';
import '../main_menu.dart';
import 'Sale_invoice.dart';
import 'header_widget.dart';




class ChooseCustomer extends StatefulWidget {
  @override
  _ChooseCustomerState createState() => _ChooseCustomerState();
}

class _ChooseCustomerState extends State<ChooseCustomer> {
  late SharedPreferences sharedPreferences;
  final double _headerHeight =220;
  List data =[];


  List<soled_product> _soled_prodects = [];
  late sale_Invoice_model sale_invoice_model;

  var items = [
    'Adham',
    'Rawad',
    'Alaa',
    'Mostafa',
    'Mohammed',
  ];

  @override
  void initState() {
    super.initState();
   fetchCustomers();
   Customers _customer = Customers();
   sale_invoice_model = sale_Invoice_model( 0,0,0,0,0, _soled_prodects, _customer);

  }
  List<Customers> _customer = [];

  @override
  Widget build(BuildContext context) {
    String text;
    String text1;
    _customer = (data).map<Customers>((item) => Customers.fromJson(item)).toList();
    String _chosenValue='kkll';

    return Scaffold(
      backgroundColor: Colors.white,

      body:SingleChildScrollView(child:
      Column(
        children:[
        Container(
        height: _headerHeight,
        child: HeaderWidget(_headerHeight,true,Icons.person_add),

        ),
          const Center(
            child:Text('اختيـار زبـون',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.black),),
          ),
          Column(
            children: [

              DropdownButton(
                focusColor:Colors.white38,
                elevation: 4,
                style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                iconEnabledColor:Colors.black,
                items:_customer.map(( Customers item) {
                  return DropdownMenuItem(
                    value: item.name.toString(),
                    child: Text(item.name),
                  );
                }).toList(),
                // After selecting the desired option,it will
                // change button value to selected value
                hint: const Text("اختيار زبون"),
                onChanged: (String? value) {
                  setState(()  {
                    _chosenValue = value!;
                    //SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
                    final index=_customer.indexWhere((element) => element.name==_chosenValue);

                    sale_invoice_model.customer = _customer[index];

                    getdept();

                    //print(sale_invoice_model.toString());
                    Navigator.push(context,  MaterialPageRoute(builder: (context)=>ScanScreen(sale_invoice_model: sale_invoice_model,)));
                  });
               },
              ),

              SizedBox(height: 20.0,),
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

                    padding: EdgeInsets.fromLTRB(40, 15, 40, 7),
                    child:Text(text1='زبون مفرق'.toUpperCase(),style:const TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
                  ),
                  onPressed:() {
                  }

              ),
              const SizedBox(height: 17.0,),
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
                    padding: EdgeInsets.fromLTRB(40, 15, 40, 7),
                    child:Text(text='زبون جملة'.toUpperCase(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
                  ),
                  onPressed:() {
                    //Navigator.push(context, MaterialPageRoute(builder: (context)=>SaleInvoice()));
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

  // Future <void> fetchCustomers() async {
  //
  //   final response =
  //   await http.get(Uri.parse("https://reqres.in/api/users?page=2"));
  //   if (response.statusCode == 200) {
  //     var resBody=json.decode(response.body)['data'];
  //     setState(() {
  //       data =resBody ;
  //     });
  //
  //   }else {
  //     throw Exception('Failed to load data.');}
  // }

  Future <void> fetchCustomers() async {
    sharedPreferences=await SharedPreferences.getInstance();
    var token=sharedPreferences.getString('token').toString();
    final response =
    await http.get(Uri.parse("http://192.168.43.110:8888/api/customers"), headers: <String,String>{
      'Authorization' : token,
    });
    if (response.statusCode == 200) {
      print(response.headers);
      var resBody=  json.decode(response.body)['data'];

      print(resBody);
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
    var _customerID = sharedPreferences.getString('customerid');
    final response =
    await http.get(Uri.parse("http://192.168.43.110:8888/api/SaleDebt/show/$_customerID"), headers: <String,String>{
      'Authorization' : token,
    });

    if (response.statusCode == 200) {
      var resBody=  json.decode(response.body)['data'];
      setState(() {
        sale_invoice_model.user_id = id;
        sale_invoice_model.saledept_id = resBody['id'];
        sale_invoice_model.dept_value = resBody['debt_value'];
      });
    }
  }

}




