import 'dart:convert';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/buy_Invoice_model.dart';
import '../../qrscreens/readqr.dart';
import '../../theme_helper/themes.dart';

class BuyInvoice extends StatefulWidget {
  final buy_Invoice_model buy_invoice_model;
  const BuyInvoice( {
    Key? key,
    required this.buy_invoice_model,
  }):super(key: key);

  @override
  _BuyInvoiceState createState() => _BuyInvoiceState();
}

class _BuyInvoiceState extends State<BuyInvoice> {

  var productNameController= TextEditingController();
  var categoryController= TextEditingController();
  var purchasePriceController= TextEditingController();
  var wholeSaleController= TextEditingController();
  var retailePriceController=TextEditingController();
  var QuantityController= TextEditingController();
  var supplyDateController= TextEditingController();
  var expireDateController= TextEditingController();
  late SharedPreferences sharedPreferences;
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

      body: SingleChildScrollView(
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

                decoration: ThemeHelper().textInputDecoration( 'اسم المنتج', 'ادخل اسم المنتج الجديد'),
              ),
              const SizedBox(height: 30.0,),
              TextFormField(
                controller:categoryController,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.start,

                decoration: ThemeHelper().textInputDecoration( 'اسم القسم', 'ادخل اسم قسم المنتج'),
              ),
              const SizedBox(height: 30.0,),
              TextFormField(
                controller:purchasePriceController,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.start,

                decoration: ThemeHelper().textInputDecoration( 'سعر الشراء', 'ادخل سعر الشراء'),
              ),
              const SizedBox(height: 30.0,),
              TextFormField(
                controller:wholeSaleController,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.start,

                decoration: ThemeHelper().textInputDecoration( 'سعر مبيع الجملة', 'ادخل سعر مبيع الجملة'),
              ),
              const SizedBox(height: 30.0,),
              TextFormField(
                controller:retailePriceController,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.start,

                decoration: ThemeHelper().textInputDecoration( 'سعر المفرق', 'ادخل سعر المفرق'),
              ),
              const SizedBox(height: 30.0,),
              TextFormField(
                controller:QuantityController,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.start,

                decoration: ThemeHelper().textInputDecoration( 'الكمية', 'ادخل الكميةالجديدة'),
              ),
              const SizedBox(height: 30.0,),
              TextFormField(
                controller:supplyDateController,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.start,
                decoration: ThemeHelper().textInputDecoration( 'تاريخ الشراء', 'ادخل تاريخ الشراء'),
              ),
              const SizedBox(height: 30.0,),
              TextFormField(
                controller:expireDateController,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.start,
                decoration: ThemeHelper().textInputDecoration( 'تاريخ الانتهاء', 'ادخل تاريخ الانتهاء'),
              ),
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
        fetchProducts().then((value) =>
        {

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

  Future <void> fetchProducts() async {
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

}
