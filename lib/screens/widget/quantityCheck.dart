
import 'dart:convert';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;
import '../../qrscreens/readqr.dart';
import '../../theme_helper/themes.dart';

class checkQuantity extends StatefulWidget {
  @override
  _checkQuantityState createState() => _checkQuantityState();
}

class _checkQuantityState extends State<checkQuantity> {
  List<Products> products=[];
  late SharedPreferences sharedPreferences;
  var productNameController= TextEditingController();
  var quantityController= TextEditingController();
  final _flashOnController = TextEditingController(text: 'Flash on');
  final _flashOffController = TextEditingController(text: 'Flash off');
  final _cancelController = TextEditingController(text: 'Cancel');
  var _aspectTolerance = 0.00;
  var _numberOfCameras = 0;
  var _selectedCamera = -1;
  var _useAutoFocus = true;
  var _autoEnableFlash = false;
  ScanResult? scanResult;
  var qrstr='' ;
  static final _possibleFormats = BarcodeFormat.values.toList()
    ..removeWhere((e) => e == BarcodeFormat.unknown);

  List<BarcodeFormat> selectedFormats = [..._possibleFormats];
  Products _product=Products();
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      _numberOfCameras = await BarcodeScanner.numberOfCameras;
      setState(() {

      });
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var scanResult = this.scanResult;
    if (scanResult!=null){
      qrstr=scanResult.rawContent;
    }

    return Scaffold(
      backgroundColor: Colors.white,

      body:  SingleChildScrollView(
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children:[
            const SizedBox(height: 50, width: 100,),

            Center(
              child:ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.white70),
                  elevation: MaterialStateProperty.all(4),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),

                    ),
                  ),
                ),
                onPressed:_scan,
                child:
                const Text('[ ||||| ]', style:  TextStyle(color: Colors.black, fontSize: 30),),
              ),
            ),

            Text(qrstr, style: const TextStyle(color: Colors.blue, fontSize: 25),),
            const SizedBox(height: 30.0,),
            TextFormField(
              controller:productNameController,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.start,

              decoration: ThemeHelper().textInputDecoration( 'اسم المنتج', ''),
            ),
            const SizedBox(height: 30.0,),
            TextFormField(
              controller:quantityController,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.start,
              decoration: ThemeHelper().textInputDecoration( 'الكمية', ''),
            ),
            const SizedBox(height: 30.0,),
            Divider(),
            Text("المنتجات",style: TextStyle(fontSize: 18,fontWeight:FontWeight.bold),),
            Divider(),
            FutureBuilder<String>(
                future: fetchProducts(),
                builder: (BuildContext context,AsyncSnapshot<String>snapshot) {
                  switch (snapshot.connectionState)
                  {case ConnectionState.waiting:
                    return Center(child: const CircularProgressIndicator(),);
                    default:
                      return SizedBox(
                        height: 10000,
                        child: Column(
                          children: [
                            ListTile(
                              onTap: null,
                              leading: CircleAvatar(backgroundColor: Colors.transparent,),
                              title: Row(
                                textDirection: TextDirection.rtl,
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.only(right: 65),
                                    child: Text("اسم المنتج"),
                                  ),
                                  Expanded(child: Text("الكمية"),),
                                ],
                              ),

                            ),

                            Expanded(

                                child: ListView.builder(

                                  itemCount: products.length,
                                  itemBuilder: (context, index) {
                                    Widget column = Expanded(
                                      child:
                                      Row(
                                        // align the text to the left instead of centered
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          textDirection: TextDirection.rtl,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(right: 65),
                                              child: Text(products[index].getProductName),
                                            ),
                                            Spacer(),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 65),
                                              child: Text(
                                                  products[index].getquantity.toString()),
                                            ),
                                          ]
                                      ),
                                    );
                                    return Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: <Widget>[
                                            column,
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ))

                          ],
                        ),
                      );

                  }
                }
            )
          ],
        ),
      ),
    );
  }
  Future<void> _scan() async {
    try {
      final result = await BarcodeScanner.scan(
        options: ScanOptions(
          strings: {
            'cancel': _cancelController.text,
            'flash_on': _flashOnController.text,
            'flash_off': _flashOffController.text,
          },
          restrictFormat: selectedFormats,
          useCamera: _selectedCamera,
          autoEnableFlash: _autoEnableFlash,
          android: AndroidOptions(
            aspectTolerance: _aspectTolerance,
            useAutoFocus: _useAutoFocus,
          ),
        ),
      );
      setState(() {
        scanResult = result;
        fetchAllProducts().then((value) =>
        {
          productNameController.text=_product.getProductName,
          quantityController.text=_product.getquantity.toString(),
        }
        );
      }
      );

    } on PlatformException catch (e) {
      setState(() {
        scanResult = ScanResult(
          type: ResultType.Error,
          format: BarcodeFormat.unknown,
          rawContent: e.code == BarcodeScanner.cameraAccessDenied
              ? 'The user did not grant the camera permission!'
              : 'Unknown error: $e',
        );

      });
    }
  }

  Future <void> fetchAllProducts() async {
    sharedPreferences=await SharedPreferences.getInstance();
    var token=sharedPreferences.getString('token').toString();

    String? t = scanResult?.rawContent;
    final response =
    await http.get(Uri.parse("http://192.168.43.110:8888/api/products/show/$t"), headers: <String,String>{
      'Authorization' : token,
    });

    if (response.statusCode == 200) {
      print(response.headers);
      // if(json.decode(response.body)['data']!=null) {
      var resBody = json.decode(response.body)['data'];

      print(resBody);
      setState(() {
        _product.productid = resBody['id'];
        _product.ProductName = resBody['name'];
        _product.categoryid=resBody['category_id'];
        _product.PurchasingPrice=resBody['Purchasing_price'];
        _product.WholeSalePrice = resBody['Wholesale_price'];
        _product.RetailSalePrice = resBody['retail_price'];
        _product.Quantity = resBody['quantity'];
        _product.DateOfSupply=resBody['date_of_supply'];
        _product.expireDate=resBody['Expiry_date'];
      });



    }else {
      throw Exception('Failed to load data.');}

  }

  Future<String>fetchProducts() async {
    sharedPreferences=await SharedPreferences.getInstance();
    var token=sharedPreferences.getString('token').toString();

    final response =
    await http.get(Uri.parse("http://192.168.43.110:8888/api/stocktaking"), headers: <String,String>{
      'authorization' : token,
    });

    if (response.statusCode == 200) {
      // if(json.decode(response.body)['data']!=null) {
      var resBody = json.decode(response.body)['data'];

      print(resBody);
      List data =[];
      data=resBody;
      products=(data).map<Products>((item) => Products.fromJson(item)).toList();
    }else {
      throw Exception('Failed to load data.');}

    return 'done';
  }
}
