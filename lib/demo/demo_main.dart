import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/demo/demo_clear_data/clear_data_main.dart';
import 'package:yiapp/demo/demo_effect/effect_main.dart';
import 'package:yiapp/demo/demo_plugin/plugin_main.dart';
import 'package:yiapp/demo/demo_simulate/simulate_main.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/small/cus_box.dart';
import 'demo_get_data/get_data_main.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/13 13:27
// usage ：测试的入口
// ------------------------------------------------------

class CusDemoMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "测试"),
      body: _lv(context),
      backgroundColor: primary,
    );
  }

  Widget _lv(context) {
    return ListView(
      children: [
        SizedBox(height: Adapt.px(10)),
        NormalBox(
          title: "01 效果演示预览",
          onTap: () => CusRoute.push(context, DemoEffect()),
        ),
        NormalBox(
          title: "02 虚拟场景预览",
          onTap: () => CusRoute.push(context, DemoSimulate()),
        ),
        NormalBox(
          title: "03 清除数据相关",
          onTap: () => CusRoute.push(context, DemoClearData()),
        ),
        NormalBox(
          title: "04 获取数据相关",
          onTap: () => CusRoute.push(context, DemoGetData()),
        ),
        NormalBox(
          title: "05 第三方插件",
          onTap: () => CusRoute.push(context, DemoPlugin()),
        ),
        NormalBox(
          title: "浏览器下载app",
          onTap: _doDownload,
        ),
      ],
    );
  }

  void _doDownload() async {
    try {
      final url = "https://hy3699.com/download/hy.apk";
      if (await canLaunch(url)) {
        Log.info("可以链接");
        bool ok = await launch(url, forceSafariVC: false);
        Log.info("ok:$ok");
      }
    } catch (e) {
      Log.error("下载apk出现异常：$e");
    }
  }
}
