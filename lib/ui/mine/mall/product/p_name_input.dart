import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/flutter/rect_field.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/7 17:13
// usage ：商品名称
// ------------------------------------------------------

class ProductNameInput extends StatefulWidget {
  final TextEditingController controller;

  ProductNameInput({this.controller, Key key}) : super(key: key);

  @override
  _ProductNameInputState createState() => _ProductNameInputState();
}

class _ProductNameInputState extends State<ProductNameInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: Adapt.px(30)),
      margin: EdgeInsets.symmetric(vertical: Adapt.px(10)),
      decoration: BoxDecoration(
          color: fif_primary, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: <Widget>[
          CusText("商品名称", t_yi, 30),
          Expanded(
            child: CusRectField(
              controller: widget.controller,
              hintText: "请输入商品名称",
              autofocus: false,
              hideBorder: true,
            ),
          ),
        ],
      ),
    );
  }
}
