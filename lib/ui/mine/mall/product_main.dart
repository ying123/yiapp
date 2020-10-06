import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/api_state.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/widgets/cus_box.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/ui/mine/mall/product_store.dart';
import 'package:yiapp/ui/mine/mall/product_type/product_type.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/5 10:09
// usage ：商城管理
// ------------------------------------------------------

class ProductMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "商城"),
      body: _lv(context),
      backgroundColor: primary,
    );
  }

  Widget _lv(context) {
    return ListView(
      children: <Widget>[
        NormalBox(
          title: "商品管理",
          onTap: () => CusRoutes.push(context, ProductStore()),
        ),
//        if (ApiState.isAdmin)
        NormalBox(
          title: "商品分类",
          onTap: () => CusRoutes.push(context, ProductType()),
        ),
        NormalBox(title: "发货", onTap: () {}),
      ],
    );
  }
}