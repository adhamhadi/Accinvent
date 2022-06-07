

class reciept_product{

  var product_id, product_name, quantity,part_id,purchase_price,wholesale_price,retail_price,supplyDate,ExpireDate,description,note;

  reciept_product(
      this.product_id,
      this.product_name,
      this.quantity,
      this.part_id,
      this.purchase_price,
      this.wholesale_price,
      this.retail_price,
      this.supplyDate,
      this.ExpireDate,
      this.description,
      this.note);

  Map<String, dynamic> tojson()=><String, dynamic>{
    "product_id":product_id.toString(),
    "quantity":quantity.toString(),
  };
  
}