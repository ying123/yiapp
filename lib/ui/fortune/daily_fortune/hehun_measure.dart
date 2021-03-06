import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/model/complex/master_order_data.dart';
import 'package:yiapp/model/complex/yi_date_time.dart';
import 'package:yiapp/service/storage_util/prefs/kv_storage.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/util/time_util.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/cus_time_picker/picker_mode.dart';
import 'package:yiapp/widget/cus_time_picker/time_picker.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_text.dart';
import 'package:yiapp/model/orders/hehun_res.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/flutter/rect_field.dart';
import 'package:yiapp/widget/master/masters_page.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/23 10:55
// usage ：合婚测算
// ------------------------------------------------------

class HeHunMeasure extends StatefulWidget {
  HeHunMeasure({Key key}) : super(key: key);

  @override
  _HeHunMeasureState createState() => _HeHunMeasureState();
}

class _HeHunMeasureState extends State<HeHunMeasure> {
  String _err; // 错误提示信息
  bool _isLunarMale = false; // 男生是否选择了阴历
  bool _isLunarFemale = false; // 女生是否选择了阴历
  YiDateTime _maleYiDate; // 男生出生日期
  YiDateTime _femaleYiDate; // 女生出生日期
  var _maleNameCtrl = TextEditingController(); // 男生姓名
  var _femaleNameCtrl = TextEditingController(); // 女生姓名
  var _commentCtrl = TextEditingController(); // 内容输入框

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "合婚测算", backData: "清理kv_yiorder"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 15),
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 15),
            child: CusText("找一个爱你懂你的人", t_primary, 32),
          ),
          _inputChild(_maleNameCtrl, "男方姓名"),
          _dateChild(_maleYiDate, true),
          SizedBox(height: S.h(15)),
          _inputChild(_femaleNameCtrl, "女方姓名"),
          _dateChild(_femaleYiDate, false),
          SizedBox(height: S.h(10)),
          CusRectField(
            controller: _commentCtrl,
            hintText: "请详细描述你的问题",
            maxLines: 10,
            autofocus: false,
          ),
          SizedBox(height: S.h(25)),
          // 大师亲测
          CusRaisedButton(child: Text("大师亲测"), onPressed: _doSelectMaster),
        ],
      ),
    );
  }

  /// 跳往选择大师页面
  void _doSelectMaster() async {
    setState(() {
      _err = null;
      if (_maleNameCtrl.text.isEmpty || _femaleNameCtrl.text.isEmpty) {
        _err = "未完全填写姓名";
      } else if (_maleYiDate == null || _femaleYiDate == null) {
        _err = "未完全选择出生日期";
      } else if (_commentCtrl.text.isEmpty) {
        _err = "描述问题不能为空";
      }
    });
    if (_err != null) {
      CusToast.toast(context, text: _err);
      return;
    }
    var heHun = HeHunRes(
      name_male: _maleNameCtrl.text.trim(),
      is_solar_male: !_isLunarMale,
      name_female: _femaleNameCtrl.text.trim(),
      is_solar_female: !_isLunarFemale,
    );
    heHun.ymdhm(_maleYiDate.toDateTime(), _femaleYiDate.toDateTime());
    var data = MasterOrderData(comment: _commentCtrl.text.trim(), heHun: heHun);
    Log.info("当前提交合婚的信息：${data.toJson()}");
    // 清除上次数据
    if (await KV.getStr(kv_order) != null) await KV.remove(kv_order);
    // 存储大师订单数据
    bool ok = await KV.setStr(kv_order, json.encode(data.toJson()));
    if (ok) CusRoute.push(context, MastersPage(showLeading: true));
  }

  /// 男/女 姓名输入框
  Widget _inputChild(TextEditingController ctrl, String text) {
    return Container(
      height: Adapt.px(90),
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 0.5),
      ),
      child: Row(
        children: <Widget>[
          CusText(text, t_gray, 30),
          Expanded(
            child: TextField(
              controller: ctrl,
              style: TextStyle(fontSize: Adapt.px(30), color: t_gray),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15),
                hintText: "请输入名字(必须汉字)",
                hintStyle:
                    TextStyle(fontSize: Adapt.px(30), color: Colors.grey),
              ),
              inputFormatters: [
                WhitelistingTextInputFormatter(RegExp(r"[\u4e00-\u9fa5]")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 男/女 选择出生日期组件
  Widget _dateChild(YiDateTime yi, bool isMale) {
    String time;
    if (yi == null) {
      time = "请选择出生日期";
    } else {
      bool isSolar = isMale ? !_isLunarMale : !_isLunarFemale;
      YiDateTime date = isMale ? _maleYiDate : _femaleYiDate;
      time = TimeUtil.YMDHM(
        isSolar: isSolar,
        date: isSolar ? date : date.toSolar(),
      );
    }
    return InkWell(
      child: Container(
        height: Adapt.px(90),
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 0.5),
        ),
        child: Row(
          children: <Widget>[
            CusText("出生日期", t_gray, 30),
            SizedBox(width: S.w(15)),
            Text(time, style: TextStyle(color: t_gray, fontSize: S.sp(15))),
            Spacer(),
            Icon(FontAwesomeIcons.calendarAlt, color: Color(0xFFC85356)),
          ],
        ),
      ),
      onTap: () => TimePicker(
        context,
        pickMode: PickerMode.full,
        showLunar: true,
        isLunar: (val) {
          isMale ? _isLunarMale = val : _isLunarFemale = val;
          setState(() {});
        },
        onConfirm: (yiDate) {
          isMale ? _maleYiDate = yiDate : _femaleYiDate = yiDate;
          setState(() {});
        },
      ),
    );
  }

  @override
  void dispose() {
    _maleNameCtrl.dispose();
    _femaleNameCtrl.dispose();
    _commentCtrl.dispose();
    super.dispose();
  }
}
