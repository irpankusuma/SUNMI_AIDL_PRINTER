import 'package:flutter/material.dart';

class ItemPriceList
{
  final int idxItem;
  final String itemDesc;
  final double itemPrice;
  final int itemValue;

  const ItemPriceList({ this.idxItem, this.itemDesc, this.itemPrice, this.itemValue=0 });
  factory ItemPriceList.fromJson(Map<String, dynamic> parsedJson) {
    return ItemPriceList(
      idxItem: parsedJson['IDX_IN_M_Item'],
      itemDesc: parsedJson['ItemDesc'],
      itemPrice: parsedJson['SellingPrice']
    );
  }
}

class Menu {
  final Icon icon;
  final Text text;
  final VoidCallback onPressed;

  const Menu({ this.icon, this.text, this.onPressed });
}


class MenuCaraBayar {
  final String imageURL;
  final Text text;
  final VoidCallback onPressed;

  const MenuCaraBayar({ this.imageURL, this.text, this.onPressed });
}


