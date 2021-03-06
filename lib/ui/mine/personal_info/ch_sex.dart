import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/ui/provider/user_state.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/service/storage_util/sqlite/login_dao.dart';
import 'package:yiapp/service/storage_util/sqlite/sqlite_init.dart';
import '../../../service/api/api_user.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/8 10:33
// usage ：修改用户性别
// ------------------------------------------------------

class ChUserSex extends StatefulWidget {
  final num sex;

  ChUserSex({this.sex, Key key}) : super(key: key);

  @override
  _ChUserSexState createState() => _ChUserSexState();
}

class _ChUserSexState extends State<ChUserSex> {
  bool _isMale = false; // 是否男性

  @override
  void initState() {
    _isMale = widget.sex == male ? true : false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(
        text: '设置性别',
        actions: <Widget>[
          FlatButton(
            onPressed: _doChSex,
            child: Text(
              '完成',
              style: TextStyle(color: t_gray, fontSize: Adapt.px(30)),
            ),
          )
        ],
      ),
      body: Column(children: <Widget>[_chooseSex("男"), _chooseSex("女")]),
      backgroundColor: primary,
    );
  }

  /// 选择性别
  Widget _chooseSex(String sex) {
    Widget image =
        Image.asset('assets/images/icon_selected_20x20.png', scale: 1.8);
    return Padding(
      padding: EdgeInsets.only(bottom: Adapt.px(2)),
      child: InkWell(
        onTap: () => setState(() => _isMale = sex == "男" ? true : false),
        child: Container(
          height: Adapt.px(100),
          padding: EdgeInsets.symmetric(horizontal: Adapt.px(30)),
          color: fif_primary,
          child: Row(
            children: <Widget>[
              Text(
                sex,
                style: TextStyle(color: t_gray, fontSize: Adapt.px(30)),
              ),
              Spacer(),
              if (_isMale && sex == "男") image,
              if (!_isMale && sex == "女") image,
            ],
          ),
        ),
      ),
    );
  }

  /// 更改性别
  void _doChSex() async {
    int sex = _isMale ? male : female;
    if (sex == widget.sex) {
      Navigator.pop(context);
      return;
    }
    Log.info("当前性别：$sex");
    var m = {"sex": sex};
    try {
      bool ok = await ApiUser.ChUserInfo(m);
      Log.info("修改性别结果：$ok");
      if (ok) {
        context.read<UserInfoState>().chSex(sex);
        bool update = await LoginDao(glbDB).updateSex(sex);
        if (update) {
          CusToast.toast(context, text: "修改成功");
          Navigator.pop(context);
        }
      }
    } catch (e) {
      Log.error("修改性别出现异常：$e");
    }
  }
}
