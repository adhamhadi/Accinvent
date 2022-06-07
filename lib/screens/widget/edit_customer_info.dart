import 'package:flutter/material.dart';
import 'package:barcode_scanner/screens/main_menu.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
class EditCustomerInfo extends StatefulWidget {
  @override
  _EditCustomerInfoState createState() => _EditCustomerInfoState();
}

class _EditCustomerInfoState extends State<EditCustomerInfo> {
  List data=[];
  List<Customers> _customer = [];
   late final index;
  var _chosenValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(child:
      Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: [
      Container(
      padding: const EdgeInsets.all(50.0),
        margin: const EdgeInsets.fromLTRB(50, 20, 50, 20),
        child: const Text("تعديل بيانات زبون",textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 25),),
      ),
       Center(
        child:
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
            hint: const Text(" اختر اسم الزبون ",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),),
            onChanged: (String? value) {
              setState(() {
                 _chosenValue = value!;
                 index=_customer.indexWhere((element) => element.name==_chosenValue);
                Navigator.push(context,  MaterialPageRoute(builder: (context)=>menuPage()));
              });
            },
          ),
      ],

    ),
       ),

    ],
      ),
    ),
    );
  }
  Future <void> fetchCustomers() async {
    var token  = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiNWUzM2I2Y2Q0MTVjNTFlMzA0OWRlNWY0ODlmNDRiMzhiODE3Y2MwZWJiNGVkMDllMzAxZDNkZTE0NDM0NWQ1YTdiNjVlMmJlYTJkZjMwZTQiLCJpYXQiOjE2NTI3ODMzNTcuNzE5NTIsIm5iZiI6MTY1Mjc4MzM1Ny43MTk1MjQsImV4cCI6MTY4NDMxOTM1Ny41NDMyMzcsInN1YiI6IjEiLCJzY29wZXMiOltdfQ.gzUTjg4SJcTSLVvc5kFMmAl7dxuBUkCnmKrfYjdeiW2aGdAjEs52H6t_ehFQsSZwfb3TlIF3mXRiu06d3jW4X1Qcj2W6q5uJy93YS2f8hIp3pVOPbVb_bwc2MiryEvvRWmyFWmDP4RG0p4HDyQtB1anFEuWc58VFgKRA_4zERoFR24Rnrchw7-ToWI3xZfa1dcLUx4cmYEWW3tsKrbi_4LQmzCAL-DcyxjUqZmZcBZ1UAPz5nBUdKPfoQpNAs6XBu2Vj1yHcZ_up8dHuLtrzw0cYgKZSOP-UtCqmrd8ubCrj_-PFmms1P8MGk63e5RGkpoNGaSGT_RgrMB2OKFOnuMDp7rnf59u7CTR2hdA5JFvrN4h5MEAosIenomThr51fDd0LweWz-cSSJjKFFTsdImPSC8n6K50GxLTojemfDuNytmZ4wazs4m8dEUlbD9QCa7eGQGFQ19MJrticiJl5akuo0Uci_C-AMTdntw5logwpp09Dg3ZzOg7ljU4-T34CGc806IUeTRgTyC6uOpvyIkHqlUuWulxkVD5-IzZ_qhRctNci4i0dkVQPZ3Vr9G0qViXaXTIwDoBq0jsIKggB_rfHsllQaDQorUeusgq1CH6ry_1zGsfb2TeIlaLilL72Vrzkc6mhjU2Q2wQMOATHGc9aRRZsl7_0qOxd9sGeIVg";

    final response =
    await http.get(Uri.parse("http://192.168.178.155:8000/api/costomers"), headers: <String,String>{
      'Authorization' : token,
    });

    if (response.statusCode == 200) {
      print(response.headers);
      var resBody=  json.decode(response.body)['data'];

      print(resBody);
      setState(() {

        data =resBody ;
      });


    }else {
      throw Exception('Failed to load data.');}

  }

}

class Customers {
  final id, name, phone, type;

  Customers({this.id, this.name, this.phone, this.type});
  factory  Customers.fromJson(Map<String, dynamic> json){
    return Customers(
      id: json['id'],
      name:json['name'],
      phone:json['phone'],
      type:json['type'],
    );
  }
}