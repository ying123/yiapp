import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/const/const_string.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/small/cus_box.dart';
import 'package:yiapp/ui/mine/com_pay_page.dart';
import 'package:yiapp/ui/mine/fund_account/fund_list.dart';
import 'package:yiapp/ui/mine/fund_account/bill_history.dart';
import 'package:yiapp/ui/mine/fund_account/recharge_page.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/23 18:24
// usage ：资金账号主页
// ------------------------------------------------------

class FundMain extends StatelessWidget {
  FundMain({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "资金账号管理"),
      body: _lv(context),
      backgroundColor: primary,
    );
  }

  Widget _lv(context) {
    return ListView(
      children: <Widget>[
        NormalBox(
          title: "个人支付账号",
          onTap: () => CusRoutes.push(context, FundListPage()),
        ),
        NormalBox(
          title: "对账单记录",
          onTap: () => CusRoutes.push(context, BillHistoryPage()),
        ),
        NormalBox(
          title: "充值",
//          onTap: () => CusRoutes.push(context, RechargePage()),
          onTap: () => CusRoutes.push(
            context,
//            ComPayPage(tip: "充值金额", b_type: b_recharge, appBarName: "充值"),
            RechargePage(auto: false),
          ),
        ),
      ],
    );
  }
}
