import 'package:barcode_scanner/screens/widget/Sale_invoice.dart';
import 'package:barcode_scanner/screens/widget/add_buy_invoice.dart';
import 'package:barcode_scanner/screens/widget/add_new_user.dart';
import 'package:barcode_scanner/screens/widget/choose_supplier.dart';
import 'package:barcode_scanner/screens/widget/quantityCheck.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scanner/qrscreens/readqr.dart';
import 'package:barcode_scanner/screens/login_page.dart';
import 'package:barcode_scanner/screens/widget/add_new_customer.dart';
import 'package:barcode_scanner/screens/widget/choose_customer.dart';
import 'package:barcode_scanner/screens/widget/edit_customer_info.dart';
import 'package:barcode_scanner/screens/widget/header_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class menuPage extends StatefulWidget {
  @override
  _menuPageState createState() => _menuPageState();
}

class _menuPageState extends State<menuPage> {
  late SharedPreferences sharedPreferences;
  final double _headerHeight = 250;
  var Role;

  @override
  void initState() {

    super.initState();
  }
  Future<String> get_role() async {
    sharedPreferences =
    await SharedPreferences.getInstance();
   Role= sharedPreferences.getString('Role');
    return Role;

  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    int value = 22500;
    return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text('Home', style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),),
              backgroundColor: Colors.white,
              toolbarHeight: 40.0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(25),
                    bottomLeft: Radius.circular(25)),
              ),
            ),
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child:
            FutureBuilder<String>(
              future: get_role(),
              builder: (BuildContext context,AsyncSnapshot<String>snapshot){
                switch(snapshot.connectionState){
                  case ConnectionState.waiting:
                    return  Center(child: const CircularProgressIndicator(),);
                  case ConnectionState.none:
                    return Center(child:Text('Error:${snapshot.error}'),);
                  default:

                      return  Column(
                        children: <Widget>[
                          Container(
                            height: _headerHeight,
                            child: Card(
                              semanticContainer: true,
                              child: Image.asset('assets/images/1.jpg',fit: BoxFit.fill,),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                              elevation: 5,
                              margin: EdgeInsets.all(8),                            ),
                          ),
                          Column(children: [
                            const SizedBox(
                              height: 20.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 0.0,horizontal: 20.0),
                              child: Card(
                                elevation: 4,
                                shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                shadowColor: Colors.lightBlue,
                                child: ListTile(
                                title:Text('إنشاء فاتورة بيع'.toUpperCase(),
                                style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                                  ),

                                leading: const CircleAvatar(

                                  radius: 27,
                                  backgroundImage: AssetImage("assets/images/5.jpg",),
                                ),
                                subtitle: Text('إنشاء فاتورة بيع جديدة'.toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.black),
                                ),
                                trailing: Icon(Icons.arrow_forward_ios),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ChooseCustomer()));
                                }
                              ),
                              ),
                            ),
                            SizedBox(height: 20,),
                            Visibility(
                              visible: Role=='Admin',
                              child:
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 20.0),
                                child: Card(
                                  elevation: 4,
                                  shape: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  shadowColor: Colors.lightBlue,
                                  child: ListTile(
                                      title:Text('إنشاء فاتورة شراء'.toUpperCase(),
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),

                                      leading: const CircleAvatar(

                                        radius: 27,
                                        backgroundImage: AssetImage("assets/images/5.jpg",),
                                      ),
                                      subtitle: Text('إنشاء فاتورة شراء جديدة'.toUpperCase(),
                                        style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.black),
                                      ),
                                      trailing: Icon(Icons.arrow_forward_ios),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    chooseSupplier()));
                                      }
                                  ),
                                ),
                              ),
                              // ElevatedButton(
                              //     style: ButtonStyle(
                              //       backgroundColor:
                              //       MaterialStateProperty.all<Color>(Colors.white70),
                              //       //shadowColor: MaterialStateProperty.all(Colors.black),
                              //       elevation: MaterialStateProperty.all(4),
                              //       shape:
                              //       MaterialStateProperty.all<RoundedRectangleBorder>(
                              //         RoundedRectangleBorder(
                              //           borderRadius: BorderRadius.circular(30.0),
                              //         ),
                              //       ),
                              //     ),
                              //     child: Padding(
                              //       padding: const EdgeInsets.fromLTRB(40, 15, 40, 7),
                              //       child: Text(
                              //         'إضـافـة فـاتورة شـراء'.toUpperCase(),
                              //         style: const TextStyle(
                              //             fontSize: 20,
                              //             fontWeight: FontWeight.bold,
                              //             color: Colors.black),
                              //       ),
                              //     ),
                              //     onPressed: () {
                              //       Navigator.push(
                              //           context,
                              //           MaterialPageRoute(
                              //               builder: (context) => chooseSupplier()));
                              //     }
                              // ),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
                              child: Card(

                                elevation: 4,
                                shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                shadowColor: Colors.lightBlue,
                                child: ListTile(
                                    title:Text('إضافـة  زبـون '.toUpperCase(),
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),

                                    leading: const CircleAvatar(
                                      radius: 26,
                                      backgroundImage: AssetImage("assets/images/7.jpg"),
                                    ),
                                    subtitle: Text('إضافـة  زبـون  جـديـد'.toUpperCase(),
                                      style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,),
                                      textAlign: TextAlign.start,
                                    ),
                                    trailing: Icon(Icons.arrow_forward_ios),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddNewCustomer()));
                                    }
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 20.0),
                              child: Card(

                                elevation: 4,
                                shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                shadowColor: Colors.lightBlue,
                                child: ListTile(
                                    title:Text(' تعديل بيانات '.toUpperCase(),
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),

                                    leading: const CircleAvatar(
                                      radius: 26,
                                      backgroundImage: AssetImage("assets/images/9.png"),
                                    ),
                                    subtitle: Text(' تعديل بيانات زبـون'.toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,),
                                      textAlign: TextAlign.start,
                                    ),
                                    trailing: Icon(Icons.arrow_forward_ios),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditCustomerInfo()));
                                    }
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
                              child: Card(

                                elevation: 4,
                                shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                shadowColor: Colors.lightBlue,
                                child: ListTile(
                                    title:Text('  الـمـخــــــزون '.toUpperCase(),
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),

                                    leading: const CircleAvatar(
                                      radius: 26,
                                      backgroundImage: AssetImage("assets/images/4.png"),
                                       ),
                                    subtitle: Text('جـرد  الـمـخــــــزون'.toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,),
                                      textAlign: TextAlign.start,
                                    ),
                                    trailing: Icon(Icons.arrow_forward_ios),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  checkQuantity()));
                                    }
                                ),
                              ),
                            ),

                            Visibility(
                              visible: Role=='Admin',
                              child:Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 20.0),
                                child: Card(

                                  elevation: 4,
                                  shape: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  shadowColor: Colors.lightBlue,
                                  child: ListTile(
                                      title:Text('إضافـة  مورد '.toUpperCase(),
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),

                                      leading: const CircleAvatar(
                                        radius: 26,
                                        backgroundImage: AssetImage("assets/images/7.jpg"),
                                      ),
                                      subtitle: Text('إضافـة   مورد  جـديـد'.toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,),
                                        textAlign: TextAlign.start,
                                      ),
                                      trailing: Icon(Icons.arrow_forward_ios),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AddNewCustomer()));
                                      }
                                  ),
                                ),
                              ),
                              // ElevatedButton(
                              //     style: ButtonStyle(
                              //       backgroundColor:
                              //       MaterialStateProperty.all<Color>(Colors.white70),
                              //       //shadowColor: MaterialStateProperty.all(Colors.black),
                              //       elevation: MaterialStateProperty.all(4),
                              //       shape:
                              //       MaterialStateProperty.all<RoundedRectangleBorder>(
                              //         RoundedRectangleBorder(
                              //           borderRadius: BorderRadius.circular(30.0),
                              //         ),
                              //       ),
                              //     ),
                              //     child: Padding(
                              //       padding: const EdgeInsets.fromLTRB(40, 15, 40, 7),
                              //       child: Text(
                              //         'إضـافـة مسـتخـدم'.toUpperCase(),
                              //         style: const TextStyle(
                              //             fontSize: 20,
                              //             fontWeight: FontWeight.bold,
                              //             color: Colors.black),
                              //       ),
                              //     ),
                              //     onPressed: () {
                              //       Navigator.push(
                              //           context,
                              //           MaterialPageRoute(
                              //               builder: (context) => AddNewUser()));
                              //
                              //     }
                              // ),
                            ),

                          ]),

                          Visibility(
                              visible: true,
                              child: Container(
                                alignment: Alignment.bottomRight,
                                padding: const EdgeInsets.fromLTRB(40, 10, 20, 20),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                    MaterialStateProperty.all<Color>(Colors.red),
                                    //shadowColor: MaterialStateProperty.all(Colors.black),
                                    elevation: MaterialStateProperty.all(8),
                                    shape:
                                    MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30.0),
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        right: MediaQuery.of(context).viewInsets.right),
                                    child: const Text(
                                      'تسجيل خروج',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                  onPressed: () async {
                                    sharedPreferences =
                                    await SharedPreferences.getInstance();
                                    sharedPreferences.clear();
                                    const CircularProgressIndicator();
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LoginPage()),
                                        ModalRoute.withName("/login"));
                                  },
                                ),
                              )
                          ),
                        ],

                      );
                    }
                }


            ),
            )
        );

  }

  // showLoaderDialog(BuildContext context) {
  //   AlertDialog alert = AlertDialog(
  //     content:  Row(
  //       children: [
  //         const CircularProgressIndicator(),
  //         Container(
  //             margin: const EdgeInsets.only(left: 7), child: const Text("Loading...")),
  //       ],
  //     ),
  //   );
  //   showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }
}
