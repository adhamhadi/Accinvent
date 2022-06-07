import 'package:barcode_scanner/screens/widget/Sale_invoice.dart';
import 'package:barcode_scanner/screens/widget/add_buy_invoice.dart';
import 'package:barcode_scanner/screens/widget/add_new_user.dart';
import 'package:barcode_scanner/screens/widget/choose_supplier.dart';
import 'package:barcode_scanner/screens/widget/quantityCheck.dart';
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
    return WillPopScope(
        onWillPop: () => Future.value(false),
        child: Scaffold(
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
                            child: HeaderWidget(_headerHeight, true, Icons.home),
                          ),
                          Column(children: [
                            const SizedBox(
                              height: 10.0,
                            ),
                            ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.white70),
                                  //shadowColor: MaterialStateProperty.all(Colors.black),
                                  elevation: MaterialStateProperty.all(4),
                                  shape:
                                  MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(40, 15, 40, 7),
                                  child: Text(
                                    'إنشاء فاتورة بيع جديدة'.toUpperCase(),
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ChooseCustomer()));
                                }),
                            const SizedBox(
                              height: 22,
                            ),
                            Visibility(
                              visible: Role=='Admin',
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                    MaterialStateProperty.all<Color>(Colors.white70),
                                    //shadowColor: MaterialStateProperty.all(Colors.black),
                                    elevation: MaterialStateProperty.all(4),
                                    shape:
                                    MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30.0),
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(40, 15, 40, 7),
                                    child: Text(
                                      'إضـافـة فـاتورة شـراء'.toUpperCase(),
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => chooseSupplier()));
                                  }
                              ),
                            ),
                            Visibility(
                              visible: Role=='Admin',
                              child: const SizedBox(
                                height: 22,
                              ),),
                            ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.white70),
                                  // shadowColor: MaterialStateProperty.all(Colors.black),
                                  elevation: MaterialStateProperty.all(4),
                                  shape:
                                  MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(40, 15, 40, 7),
                                  child: Text(
                                    'إضافـة  زبـون  جـديـد'.toUpperCase(),
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AddNewCustomer()));
                                }),
                            const SizedBox(
                              height: 22,
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white70,
                                  // shadowColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  elevation: 4,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(40, 15, 40, 7),
                                  child: Text(
                                    ' تعديل بيانات زبـون'.toUpperCase(),
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditCustomerInfo()));
                                }
                                ),
                            const SizedBox(
                              height: 22,
                            ),
                            ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.white70),
                                  //shadowColor: MaterialStateProperty.all(Colors.black),
                                  elevation: MaterialStateProperty.all(4),
                                  shape:
                                  MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(40, 15, 40, 7),
                                  child: Text(
                                    'جـرد  الـمـخــــــزون'.toUpperCase(),
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => checkQuantity()));
                                }),
                            const SizedBox(
                              height: 22,
                            ),
                            Visibility(
                              visible: Role=='Admin',
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                    MaterialStateProperty.all<Color>(Colors.white70),
                                    //shadowColor: MaterialStateProperty.all(Colors.black),
                                    elevation: MaterialStateProperty.all(4),
                                    shape:
                                    MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30.0),
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(40, 15, 40, 7),
                                    child: Text(
                                      'إضـافـة مسـتخـدم'.toUpperCase(),
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AddNewUser()));

                                  }
                              ),
                            ),

                          ]),
                          const SizedBox(
                            height: 75.0,
                          ),

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
