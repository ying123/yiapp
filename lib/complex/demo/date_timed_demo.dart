import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/model/yi_date_time.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/yi_tool.dart';
import 'package:yiapp/complex/widgets/cus_time_picker/picker_mode.dart';
import 'package:yiapp/complex/widgets/cus_time_picker/time_picker.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/12 10:50
// usage ：自定义日历测试
// ------------------------------------------------------

class CusTimePickerDemo extends StatefulWidget {
  CusTimePickerDemo({Key key}) : super(key: key);

  @override
  _DateState createState() => _DateState();
}

class _DateState extends State<CusTimePickerDemo> {
  final List<Map> _l = [
    {"text": "年", "pickMode": PickerMode.year, "showLunar": false},
    {"text": "年月", "pickMode": PickerMode.year_month, "showLunar": false},
    {"text": "月日", "pickMode": PickerMode.month_day, "showLunar": true},
    {"text": "年月日", "pickMode": PickerMode.date, "showLunar": true},
    {"text": "时分", "pickMode": PickerMode.hour_minute, "showLunar": false},
    {"text": "年月日时分", "pickMode": PickerMode.full, "showLunar": true},
    {"text": "周易", "pickMode": PickerMode.yi, "showLunar": true},
  ];

  YiDateTime _yiDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "自定义日历测试"),
      body: _bodyCtr(context),
      backgroundColor: primary,
    );
  }

  Widget _bodyCtr(context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      children: List.generate(_l.length, (i) {
        var e = _l[i];
        return _yiBtn(e['text'], e['pickMode'], e['showLunar']);
      }),
    );
  }

  Widget _yiBtn(String text, PickerMode pickMode, bool showLunar) {
    return CusRaisedBtn(
      backgroundColor: Colors.blueGrey,
      text: text,
      onPressed: () {
        TimePicker(
          context,
          pickMode: pickMode,
          showLunar: showLunar,
          onConfirm: (yiDate) {
            print(">>>$text 日历结果：${yiDate.toJson()}");
            _yiDate = yiDate;
            setState(() {});
          },
        );
      },
    );
  }
}