import 'package:flutter/material.dart';
import 'package:barcode_scanner/screens/main_menu.dart';
import 'package:barcode_scanner/theme_helper/themes.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddNewCustomer extends StatefulWidget {
  @override
  _AddNewCustomerState createState() => _AddNewCustomerState();
}

class _AddNewCustomerState extends State<AddNewCustomer> {
  late SharedPreferences sharedPreferences;
  var CustomerNameController= TextEditingController();
  var phoneController= TextEditingController();
  var TypeController= TextEditingController();
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
        child: const Text("إضافة زبون جديد",textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 25),),
      ),

          TextFormField(
            controller:CustomerNameController,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.start,

            decoration: ThemeHelper().textInputDecoration( 'اسم الزبون', 'ادخل اسم الزبون الجديد'),
          ),
          const SizedBox(height: 30.0,),
          TextFormField(
            controller:phoneController,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.start,
            keyboardType: TextInputType.number,
            maxLength: 14,
            decoration: ThemeHelper().textInputDecoration( 'رقم الهاتف', 'أدخل رقم الهاتف',),
          ),
          const SizedBox(height: 30.0,),
          TextFormField(
            controller:TypeController,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.start,
            autofocus: true,

            decoration: ThemeHelper().textInputDecoration( 'نوع الزبون ', 'جملة/مفرق'),
          ),
          const SizedBox(height: 60.0,),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.white54),
                elevation: MaterialStateProperty.all(4),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),

                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 10),
                child: Text('رجوع'.toUpperCase(), style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),),
              ),
              onPressed: () async{

                Navigator.push(context,  MaterialPageRoute(builder: (context)=>menuPage()));
              }
          ),
          ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.white54),
                elevation: MaterialStateProperty.all(4),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),

                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 10),
                child: Text('إضافة'.toUpperCase(), style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),),
              ),
              onPressed: () {
               addCustomer();

              }
          ),
          ]
          ),
        ],

      ),
      ),

    );
  }

  Future<void> addCustomer() async{

   sharedPreferences=await SharedPreferences.getInstance();
  var token=sharedPreferences.getString('token').toString();
    if(phoneController.text.isNotEmpty && CustomerNameController.text.isNotEmpty&&TypeController.text.isNotEmpty){
      var response= await http.post(Uri.parse("http://192.168.43.110:8888/api/customers/store"), headers: <String,String>{
      'Authorization' :token },body:{
        'name':CustomerNameController.text.toString(),
        'phone':phoneController.text.toString(),
        'type':TypeController.text.toString()});

      if(response.statusCode==201){
        print("jjjjjjjjjjjjjjjjjjjjjjjjjj");
        // var token =json.decode(response.body)['data'];
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("customer has been added Successfully!"),));
        Navigator.push(context,  MaterialPageRoute(builder: (context)=>menuPage()));

      } else {
        print(response.body);
      }
    } else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Black field not allowed"),));
    }

  }
}
