import 'package:flutter/material.dart';
import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/widgets/products/price_tag.dart';
import 'package:flutter_app/widgets/ui_elements/title_default.dart';

import 'address_tag.dart';

class ProductCard extends StatelessWidget{
  final Product product;
final int productIndex;
 ProductCard(this.product,this.productIndex) ;
 Widget _buildPriceRow(){
   return Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TitleDefault(product.title),
                  SizedBox(width: 15),
                  PriceTag(product.price),
                ],
              ));
 }
 Widget _buildActionButton(BuildContext context){
   return ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon:Icon(Icons.info),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  Navigator.pushNamed<bool>(
                      context, '/products/' + productIndex.toString());
                },
              ),
              IconButton(
                icon:Icon(Icons.favorite_border),
                color: Colors.red,
                onPressed: () {
                  Navigator.pushNamed<bool>(
                      context, '/products/' + productIndex.toString());
                },
              )
            ],
          );
 }
  @override
  Widget build(BuildContext context) {
   
    return Card(
      elevation: 5,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(product.image),
          _buildPriceRow(),
          AddressTag("San Square Fransisco"),
          _buildActionButton(context)
        ],
      ),
    );
  }
  
}