
import 'package:flutter/material.dart';
import 'package:barcode_scanner/screens/widget/header_widget.dart';


import '../../models/sale_Invoice_model.dart';
import '../main_menu.dart';


class readInvoice extends StatelessWidget{
  final int value1=10123456789;
  late sale_Invoice_model sale_invoice_model;

  readInvoice(this.sale_invoice_model);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      body:SingleChildScrollView(child:

      Column(
        children:[
          Container(
            height: 90,
            child: HeaderWidget(90,false,Icons.message_sharp),
          ),


          Text(' : فاتورة بيع لـ'+'\n'+sale_invoice_model.customer.getname,style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.black),textAlign: TextAlign.center,),


          Container(
            padding: EdgeInsets.all(30),
            margin: const EdgeInsets.all(6.0),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black,width: 2.0)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(sale_invoice_model.total_price.toString()+' :  قيمة الفاتورة',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
                Divider(),
                SizedBox(height: 7.0,),
                Text(sale_invoice_model.dept_value.toString()+'  :  قيمة الديون',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
                Divider(),
                SizedBox(height: 7.0,),
                Text((sale_invoice_model.total_price+sale_invoice_model.dept_value).toString()+': المبلغ المستحق',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
                Divider(),
                SizedBox(height: 40.0,),

              ],
            ),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                ElevatedButton(
                    style:  ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white70),
                      elevation: MaterialStateProperty.all(4),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),

                        ),
                      ),
                    ),
                    child:Padding(
                      padding: EdgeInsets.all(10),
                      child:Text('تم'.toUpperCase(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
                    ),
                    onPressed:() {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => menuPage()
                          ),
                          ModalRoute.withName("/Home"));
                    }
                ),
                //  SizedBox(width: 7.0,),

              ]
          ),

        ],
      ),
      ),
    );
  }
}