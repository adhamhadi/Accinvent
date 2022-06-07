import 'package:flutter/material.dart';
import 'package:barcode_scanner/screens/main_menu.dart';
import 'package:barcode_scanner/theme_helper/themes.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddNewUser extends StatefulWidget {
  @override
  _AddNewUserState createState() => _AddNewUserState();
}

class _AddNewUserState extends State<AddNewUser> {
  late SharedPreferences sharedPreferences;
  var nameController=TextEditingController(); //
  var UserNameController= TextEditingController(); //
  var passwordController= TextEditingController(); //
  var confirmpasswordController= TextEditingController(); //
  var phoneController= TextEditingController(); //
  var adresscontroller= TextEditingController(); //
  var roleController= TextEditingController(); //
  var salaryController= TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(child:
      Column(

        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(40.0),
            margin: const EdgeInsets.fromLTRB(50, 20, 50, 0),
            child: const Text("إضافة مستخدم جديد",textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 22),),
          ),

          TextFormField(
            controller:nameController,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.start,

            decoration: ThemeHelper().textInputDecoration( 'اسم الموظف', 'أدخل اسم الموظف الكامل'),
          ),
          const SizedBox(height: 45.0,),
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
            controller:roleController,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.start,
            autofocus: true,

            decoration: ThemeHelper().textInputDecoration( 'نوع المسـتخدم ', 'مدير/موظف'),
          ),
          const SizedBox(height: 45.0,),
          TextFormField(
            controller:UserNameController,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.start,
            autofocus: true,

            decoration: ThemeHelper().textInputDecoration( 'اسم المسـتخدم', 'ادخل اسـم المسـتخدم'),
          ),
          const SizedBox(height: 45.0,),
          TextFormField(
            controller:passwordController,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.start,
            autofocus: true,

            decoration: ThemeHelper().textInputDecoration( 'كلمة المرور', 'كلمة المرور'),
          ),
          const SizedBox(height: 45.0,),
          TextFormField(
            controller:confirmpasswordController,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.start,
            autofocus: true,
            decoration: ThemeHelper().textInputDecoration( 'تأكيد كلمة المرور', 'تأكيد كلمة المرور'),
          ),
          const SizedBox(height: 45.0,),
          TextFormField(
            controller:adresscontroller,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.start,
            autofocus: true,

            decoration: ThemeHelper().textInputDecoration( 'العنوان', 'أدخل عنوان الموظف'),
          ),
          const SizedBox(height: 30.0,),
          TextFormField(
            controller:salaryController,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.start,
            autofocus: true,

            decoration: ThemeHelper().textInputDecoration( 'الراتب', 'أدخل راتب الموظف'),
          ),
          const SizedBox(height: 30.0,),
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
    if(phoneController.text.isNotEmpty && UserNameController.text.isNotEmpty&&nameController.text.isNotEmpty&&adresscontroller.text.isNotEmpty&&roleController.text.isNotEmpty&&salaryController.text.isNotEmpty&&passwordController.text.isNotEmpty&&confirmpasswordController.text.isNotEmpty){
      if(passwordController.text==confirmpasswordController.text) {
        var response = await http.post(
            Uri.parse("http://192.168.43.110:8888/api/register"),
            headers: <String, String>{
              'Authorization': token}, body: {
          'name': nameController.text.toString(),
          'email': UserNameController.text.toString(),
          'password': passwordController.text.toString(),
          // 'phone': phoneController.text.toString(),
          // 'address': adresscontroller.text.toString(),
          // 'salary': salaryController.text.toString(),
          'Role': roleController.text.toString()
        });
        if (response.statusCode == 201) {
          print(token);
          // var token =json.decode(response.body)['data'];
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("تمت إضافة المستخدم بنجاح"),));
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => menuPage()));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("كلمة المرور خاطئة"),));
      }

      }
     else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("يجب ملء كافة الحقول"),));
    }

  }
}
