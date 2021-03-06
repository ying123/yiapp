import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/flutter/under_field.dart';
import 'package:yiapp/ui/login/login_page.dart';
import 'package:yiapp/service/api/api_user.dart';
import 'package:yiapp/service/storage_util/sqlite/login_dao.dart';
import 'package:yiapp/service/storage_util/sqlite/sqlite_init.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/10 16:43
// usage ：修改登录密码页面
// ------------------------------------------------------

class ChPwdPage extends StatefulWidget {
  ChPwdPage({Key key}) : super(key: key);

  @override
  _ChPwdPageState createState() => _ChPwdPageState();
}

class _ChPwdPageState extends State<ChPwdPage> {
  final _oldCtrl = TextEditingController(); // 旧密码
  final _newCtrl = TextEditingController(); // 新密码
  String _oldErr; // 旧密码错误提示信息
  String _newErr; // 新密码错误提示信息

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "修改登录密码"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: Adapt.px(80)),
      children: <Widget>[
        SizedBox(height: Adapt.px(100)),
        CusUnderField(
          controller: _oldCtrl,
          hintText: "请输入当前登录密码",
          errorText: _oldErr,
        ),
        CusUnderField(
          controller: _newCtrl,
          hintText: "请输入新密码",
          errorText: _newErr,
        ),
        SizedBox(height: Adapt.px(50)),
        CusRaisedButton(
          child: Text(
            "确定修改",
            style: TextStyle(color: t_gray, fontSize: S.sp(15)),
          ),
          onPressed: _doChPwd,
          backgroundColor: Colors.blueGrey,
        ),
      ],
    );
  }

  /// 修改密码
  void _doChPwd() async {
    setState(() {
      _oldErr = _newErr = null;
      _oldErr = _oldCtrl.text.isEmpty ? "当前登录密码不能为空" : null;
      if (_oldErr != null) return;
      _newErr = _newCtrl.text.isEmpty ? "新密码不能为空" : null;
      if (_newErr != null) return;
    });
    // 符合要求，请求修改密码
    if (_oldErr == null && _newErr == null) {
      try {
        bool ok = await ApiUser.chUserPwd(_oldCtrl.text, _newCtrl.text);
        if (ok) {
          CusToast.toast(context, text: "修改密码成功，请重新登录", milliseconds: 1300);
          bool update = await LoginDao(glbDB).updatePwd(_newCtrl.text);
          if (update) {
            CusRoute.push(context, LoginPage());
          }
        }
        Log.info("修改用户密码结果：$ok");
      } catch (e) {
        _oldErr = "当前登录密码输入错误";
        setState(() {});
        Log.error("修改用户密码异常：$e");
      }
    }
  }
}
