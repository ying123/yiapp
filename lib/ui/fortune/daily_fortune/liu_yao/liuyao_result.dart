import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/complex/cus_liuyao_data.dart';
import 'package:yiapp/model/complex/master_order_data.dart';
import 'package:yiapp/model/complex/yi_date_time.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/model/login/userInfo.dart';
import 'package:yiapp/model/orders/liuyao_res.dart';
import 'package:yiapp/ui/provider/user_state.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/cus/cus_role.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/util/temp/yi_tool.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_button.dart';
import 'package:yiapp/widget/flutter/cus_divider.dart';
import 'package:yiapp/model/liuyaos/liuyao_result.dart';
import 'package:yiapp/model/liuyaos/liuyao_riqi.dart';
import 'package:yiapp/service/storage_util/prefs/kv_storage.dart';
import 'package:yiapp/ui/fortune/daily_fortune/liu_yao/liuyao_symbol_res.dart';
import 'package:yiapp/ui/question/ask_question/ask_main_page.dart';
import 'package:yiapp/widget/master/masters_page.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/5 11:55
// usage ：六爻排盘结果页面
// ------------------------------------------------------

class LiuYaoResPage extends StatefulWidget {
  final LiuYaoResult res;
  final List<int> l; // 六爻编码
  final YiDateTime guaTime;

  LiuYaoResPage({this.res, this.l, this.guaTime, Key key}) : super(key: key);

  @override
  _LiuYaoResPageState createState() => _LiuYaoResPageState(res);
}

class _LiuYaoResPageState extends State<LiuYaoResPage> {
  LiuYaoResult _res;
  _LiuYaoResPageState(this._res);

  List<int> _codes = []; // 六爻编码
  UserInfo _user; // 卦主

  DateTime _dt;

  @override
  void initState() {
    _codes = widget.l.reversed.toList();
    LiuYaoRiqi riqi = _res.riqi;
    _dt = DateTime(riqi.year, riqi.month, riqi.day, riqi.hour, riqi.minute);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _user = context.watch<UserInfoState>()?.userInfo;
    return Scaffold(
      appBar: CusAppBar(text: "六爻排盘", backData: ""),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    LiuYaoRiqi riqi = _res.riqi;
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: S.w(15)),
            children: <Widget>[
              SizedBox(height: S.h(10)),
              _show("占类", "在线起卦"),
              _show("卦主", _user.nick),
              _show(
                  "时间",
                  "${YiTool.fullDateGong(
                    YiDateTime(
                      year: riqi.year,
                      month: riqi.month,
                      day: riqi.day,
                      hour: riqi.hour,
                      minute: riqi.minute,
                    ),
                  )}"),
              _show(
                "干支",
                "${riqi.nian_gan}${riqi.nian_zhi}  ${riqi.yue_gan}${riqi.yue_zhi}"
                    "  ${riqi.ri_gan}${riqi.ri_zhi}  ${riqi.shi_gan}${riqi.shi_zhi}",
              ),
              CusDivider(),
              // 卦象
              LiuYaoSymRes(res: _res, codes: _codes),
              CusDivider(),
            ],
          ),
        ),
        // 底部求测按钮
        _bottom(),
      ],
    );
  }

  /// 底部智能解盘、发帖求测按钮
  Widget _bottom() {
    return Row(
      children: <Widget>[
        Expanded(
          child: CusBtn(
            text: "悬赏帖求测",
            borderRadius: 0,
            backgroundColor: Color(0xFFE96C62),
            height: 45,
            onPressed: () => _doPost(false),
          ),
        ),
        Expanded(
          child: CusBtn(
            text: "闪断帖求测",
            borderRadius: 0,
            backgroundColor: Color(0xFFED9951),
            height: 45,
            onPressed: () => _doPost(true),
          ),
        ),
        Expanded(
          child: CusBtn(
            text: "大师亲测",
            borderRadius: 0,
            backgroundColor: Color(0xFFE8493E),
            height: 45,
            onPressed: _doSelectMaster,
          ),
        ),
      ],
    );
  }

  /// 跳往选择大师页面
  void _doSelectMaster() async {
    CusLiuYaoData yaoData = CusLiuYaoData(res: _res, codes: _codes);
    String str = json.encode(yaoData.toJson());
    bool ok = await KV.setStr(kv_liuyao, str);
    if (ok) Log.info("已存储 kv_liuyao");
    String code = "";
    widget.l.forEach((e) => code += e.toString());
    var liuYao =
        LiuYaoRes(yao_code: code, is_male: _user.sex == 1 ? true : false);
    liuYao.ymdhm(_dt);
    var data = MasterOrderData(comment: "", liuYao: liuYao);
    Log.info("当前提交六爻的信息：${data.toJson()}");
    // 清除上次数据
    if (await KV.getStr(kv_order) != null) await KV.remove(kv_order);
    // 存储大师订单数据
    bool success = await KV.setStr(kv_order, json.encode(data.toJson()));
    if (success) CusRoute.push(context, MastersPage(showLeading: true));
  }

  /// 求测悬赏帖还是闪断帖
  void _doPost(bool isFlash) async {
    CusRole.isVie = isFlash;
    CusRoute.push(
      context,
      AskQuestionPage(
        content_type: submit_liuyao,
        res: widget.res,
        l: widget.l,
        guaTime: widget.guaTime,
        user_nick: _user.nick,
      ),
    ).then((value) => Navigator.of(context).pop(""));
  }

  /// 显示占类、卦主、时间
  Widget _show(String title, subtitle) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Adapt.px(5)),
      child: Row(
        children: <Widget>[
          Text(
            "$title:",
            style: TextStyle(color: t_gray, fontSize: Adapt.px(30)),
          ),
          SizedBox(width: Adapt.px(30)),
          Text(
            "$subtitle",
            style: TextStyle(color: t_gray, fontSize: Adapt.px(30)),
          ),
        ],
      ),
    );
  }
}
