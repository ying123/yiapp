import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/complex/cus_liuyao_data.dart';
import 'package:yiapp/model/liuyaos/liuyao_result.dart';
import 'package:yiapp/model/orders/liuyao_res.dart';
import 'package:yiapp/service/api/api_yi.dart';
import 'package:yiapp/service/storage_util/prefs/kv_storage.dart';
import 'package:yiapp/ui/fortune/daily_fortune/liu_yao/liuyao_symbol_res.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/util/time_util.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/29 下午6:59
// usage ：如果是六爻，显示的内容（提交大师订单及查看订单可用）
// ------------------------------------------------------

class MasterOrder extends StatefulWidget {
  final LiuYaoRes liuYao;

  MasterOrder({this.liuYao, Key key}) : super(key: key);

  @override
  _MasterOrderState createState() => _MasterOrderState();
}

class _MasterOrderState extends State<MasterOrder> {
  var _future;
  var _data = CusLiuYaoData();
  var _yaoData = LiuYaoResult();
  List<int> _codes = []; // 六爻编码
  String _res;

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  _fetch() async {
    try {
      _res = await KV.getStr(kv_liuyao);
      // 本地获取到的六爻数据
      if (_res != null) {
        Log.info("读取本地数据");
        _data = CusLiuYaoData.fromJson(json.decode(_res));
        Log.info("——dta:${_data.toJson()}");
      }
      // 有六爻数据，重新起卦
      else {
        Log.info("读取后台数据");
        await _fetchLiuYao();
      }
    } catch (e) {
      Log.error("获取本地存储的六爻数据出现异常：$e");
    }
  }

  /// 获取六爻数据
  _fetchLiuYao() async {
    var r = widget.liuYao;
    var m = {
      "year": r.year,
      "month": r.month,
      "day": r.day,
      "hour": r.hour,
      "minute": r.minute,
      "code": r.yao_code,
      "male": r.is_male ? male : female,
    };
    Log.info("大师订单提交六爻起卦数据:$m");
    try {
      var res = await ApiYi.liuYaoQiGua(m);
      if (res != null) {
        _yaoData = res;
        // 六爻编码转换，显示的话应该倒序
        var l = r.yao_code.split("").reversed.toList();
        _codes = l.map((e) => int.parse(e)).toList();
        Log.info("转换后的六爻编码：$_codes");
      }
    } catch (e) {
      Log.error("大师订单六爻起卦出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }
        return Column(
          children: <Widget>[
            _comRow("性别：", widget.liuYao.is_male ? "男" : "女"),
            _comRow("摇卦时间：", _birthDate()),
            SizedBox(height: S.h(10)),
            _liuYaoSymRes(), //  显示六爻符号
          ],
        );
      },
    );
  }

  /// 显示六爻符号
  Widget _liuYaoSymRes() {
    if (_res == null) {
      return LiuYaoSymRes(res: _yaoData, codes: _codes);
    } else {
      return LiuYaoSymRes(res: _data.res, codes: _data.codes);
    }
  }

  /// 出生日期
  String _birthDate() {
    DateTime time = widget.liuYao.dateTime(); // 选择的年月日转换为DateTime
    return TimeUtil.YMDHM(date: time);
  }

  /// 通用的 Row
  Widget _comRow(String title, String subtitle) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: S.h(2)),
      child: Row(
        children: <Widget>[
          Text(title, style: TextStyle(color: t_primary, fontSize: S.sp(15))),
          Text(subtitle, style: TextStyle(color: t_gray, fontSize: S.sp(15))),
        ],
      ),
    );
  }
}
