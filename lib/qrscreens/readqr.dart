import 'dart:convert';
//import 'package:barcode_widget/barcode_widget.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:barcode_scanner/models/sale_Invoice_model.dart';
import 'package:barcode_scanner/models/soled_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:barcode_scanner/screens/main_menu.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/widget/Sale_invoice.dart';
import '../screens/widget/choose_supplier.dart';
import '../theme_helper/themes.dart';

class ScanScreen extends StatefulWidget {
  final sale_Invoice_model sale_invoice_model;
  const ScanScreen( {
    Key? key,
    required this.sale_invoice_model,
}):super(key: key);


  @override
  _ScanScreenState createState() => _ScanScreenState();
}


class _ScanScreenState extends State<ScanScreen> {

  late SharedPreferences sharedPreferences;
  final _flashOnController = TextEditingController(text: 'Flash on');
  final _flashOffController = TextEditingController(text: 'Flash off');
  final _cancelController = TextEditingController(text: 'Cancel');
  var productNameController= TextEditingController();
  var productQuantityController= TextEditingController();
  var outproduct='';
  var _aspectTolerance = 0.00;
  var _numberOfCameras = 0;
  var _selectedCamera = -1;
  var _useAutoFocus = true;
  var _autoEnableFlash = false;

  ScanResult? scanResult;

  static final _possibleFormats = BarcodeFormat.values.toList()
    ..removeWhere((e) => e == BarcodeFormat.unknown);

  List<BarcodeFormat> selectedFormats = [..._possibleFormats];

  var qrstr ='';
  String product = 'اختر منتج ';

  var height, width,dept;

  String errorText = '';
  bool errorValidate = false;
  var items = [
    'سائل جلي نورا',
    'دوا غسيل',
  ];
  int singlePrice =1;
  Products _product=Products();
 final  Map<String,String>allproduct=Map<String,String>();
  int value3=0;
  int value2=0;
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
    late var scanResult = this.scanResult;
    height = MediaQuery
        .of(context)
        .size
        .height;
    width = MediaQuery
        .of(context)
        .size
        .width;

    //_products = (data).map<Products>((item) => Products.fromJson(item)).toList();
    String _chosenValue='choose customer';

    //if(productQuantityController.text.isNotEmpty) {
      ////
      // if ( int.parse(productQuantityController.text) < 100) {
      //   value3 = int.parse(productQuantityController.text);
      //   value2 = value2 * value3;
      //  } else {
      //    value3 = 0;
      //    value2 = value2 * value3;
      //  }
   // }
       if (scanResult!=null){
         qrstr=scanResult.rawContent;

       }

    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children:[
          const SizedBox(height: 50, width: 100,),

        ElevatedButton(
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
        const Text(
          '[ ||||| ]', style:  TextStyle(color: Colors.black, fontSize: 30),),
        ),

        Text(qrstr, style: const TextStyle(color: Colors.blue, fontSize: 25),),

        const SizedBox(height: 40, width: 100,),
          Text(outproduct, style: const TextStyle(
            fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),),
            const SizedBox(height: 30.0,),
            TextField(
              controller:productNameController,
              //readOnly: true,
              decoration: ThemeHelper().textInputDecoration(
                  'الاسم', 'اسم المنتج'),
            ),

        // DropdownButton(
        //   focusColor: Colors.white38,
        //   elevation: 4,
        //   style: const TextStyle(
        //       color: Colors.black, fontWeight: FontWeight.bold),
        //   iconEnabledColor: Colors.black,
        //   items: _products.map((Products items) {
        //     return DropdownMenuItem(
        //       value: items.ProductName.toString(),
        //       child: Text(items.ProductName.toString()),
        //     );
        //   }).toList(),
        //   hint: Text(product.toString()),
        //   onChanged: (String? value) {
        //     setState(() {
        //       product = value!;
        //       final index=_products.indexWhere((element) => element.ProductName==product);
        //       value1=int.parse(_products[index].getproductPrice);
        //       current_product = _products[index];
        //       print(current_product.toString());
        //     });
        //   },
        // ),
        const SizedBox(height: 30.0,),


        TextField(
            controller:productQuantityController,
            onChanged: (productQuantityController)=>setState(() {
              if(productQuantityController.isNotEmpty) {
                if (int.parse(productQuantityController) >
                    _product.getquantity) {
                  setState(() {
                    errorText = 'الكمية المتوفرة هي ${_product.getquantity}';
                    errorValidate = true;
                  });
                } else if (int.parse(productQuantityController) <= 0) {
                  setState(() {
                    errorText = 'لا يمكنك اختيار كمية سالبة';
                    errorValidate = true;
                  });
                } else {
                  setState(() {
                    value3 = int.parse(productQuantityController);
                    errorText = '';
                    value2 = value3 * singlePrice;
                    print(value2);
                    errorValidate = false;
                  });
                }
              } else {
                value2 = 0;
                print(value2);
              }
            }),
            keyboardType: TextInputType.number,
          decoration: ThemeHelper().textInputDecoration(
              'الكمية', 'أدخل الكمية'),
        ),
            Visibility(
              visible: errorValidate,
              child: Text(errorText,style: const TextStyle(
                fontSize: 10, fontWeight: FontWeight.bold, color: Colors.red,),),

            ),
        const SizedBox(height: 40.0,),
        Text( '$singlePrice:  السعر الإفرادي', style: const TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black,),),
        const Divider(color: Colors.black,),
        const SizedBox(height: 7.0,),

        Text(value2.toString()+' : السعر الإجمالي', style: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),),
        const Divider(color: Colors.black,),

            Text(('$dept')+ ': الدين السابق', style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),),
            const SizedBox(height: 20, width: 100,),

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
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Text('متابعة'.toUpperCase(), style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),),
                ),

                onPressed: () {
                    soled_product _current_product;
                    errorValidate? null: {
                       _current_product = soled_product(_product.getproductid, _product.getProductName, productQuantityController.text.toString(), singlePrice),
                      widget.sale_invoice_model.products.add(_current_product),
                     // print(widget.sale_invoice_model.toString()),
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) =>
                              SaleInvoice(widget.sale_invoice_model)))
                    };
                }
            ),
            //  SizedBox(width: 7.0,),
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
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Text('رجوع'.toUpperCase(), style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),),
                ),
                onPressed: ()  {
                  Navigator.push(context,  MaterialPageRoute(builder: (context)=>menuPage()));
                }
            ),
            ]
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
           print('jjjjjjjjjjjjjjjjjjj'),
           productNameController.text=_product.getProductName.toString(),
          if(widget.sale_invoice_model.products.length>0){
           for(int i = 0; i <
               widget.sale_invoice_model.products.length; i++){
             if(widget.sale_invoice_model.products[i].product_id ==
                 _product.getproductid){
               productQuantityController.text = widget.sale_invoice_model.products[i].quantity.text.toString(),

               widget.sale_invoice_model.products.remove(
                   widget.sale_invoice_model.products[i]),
             }
           }
         },
        // widget.sale_invoice_model.soled_products.forEach((element) {
        // if(element.product_id == _product.getproductid){
        // productQuantityController.text=element.quantity.toString();
        // widget.sale_invoice_model.soled_products.remove(element);
        // }
        // }),

        if(widget.sale_invoice_model.customer.getType=='جملة'){
        singlePrice=_product.getWholesalePrice,

        } else {
        singlePrice=_product.getproductretailePrice,

        }
      });
         });
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
          _product.WholeSalePrice = resBody['Wholesale_price'];
          _product.RetailSalePrice = resBody['retail_price'];
          _product.Quantity = resBody['quantity'];
        });



    }else {
      throw Exception('Failed to load data.');}

  }

}


class Products{
   var productid,ProductName,categoryid,PurchasingPrice,WholeSalePrice,RetailSalePrice,Quantity,DateOfSupply,expireDate,description;

  Products({
     this.productid,
      this.ProductName,
      this.categoryid,
      this.PurchasingPrice,
      this.WholeSalePrice,
      this.RetailSalePrice,
      this.Quantity,
      this.DateOfSupply,
      this.expireDate,
      this.description});
  factory  Products.fromJson(Map<String, dynamic> json){
    return Products(
      productid:json['id'],
      ProductName: json['name'],
      categoryid:json['category_id'],
      PurchasingPrice:json['Purchasing_price'],
      WholeSalePrice:json['Wholesale_price'],
      RetailSalePrice:json['retail_price'],
      Quantity:json['quantity'],
      DateOfSupply:json['date_of_supply'],
      expireDate:json['Expiry_date'],
      description:json['description'],
    );

  }
  Map<String, dynamic> tojson()=>{
    'quantity':Quantity,
    'id': productid,
    'retail_price':RetailSalePrice,
    'category_id':categoryid,
    'Wholesale_price':WholeSalePrice,
    'product_name':ProductName,
  };
  int get getproductid=>productid;
  int get getproductretailePrice=>RetailSalePrice;
  int get getproductcatid=>categoryid;
  int get getWholesalePrice=>WholeSalePrice;
  String get getProductName=>ProductName;
  int get getquantity=>Quantity;

   @override
   String toString() {
     return 'Products{productid: $productid, ProductName: $ProductName, categoryid: $categoryid, PurchasingPrice: $PurchasingPrice, WholeSalePrice: $WholeSalePrice, RetailSalePrice: $RetailSalePrice, Quantity: $Quantity, DateOfSupply: $DateOfSupply, expireDate: $expireDate, description: $description}';
   }
// Map<String, Products> findById(String productId) {
  //   return items.map((key, value) => value.id == productId).toList(); //this is where the error is
  // }


}
