import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_double.dart';
import '../../const/const_color.dart';
import '../../tools/adapt.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/6 17:15
// usage ：自定义 AppBar
// ------------------------------------------------------

class CusAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final String text; // title 为空时，给 text 赋值则默认 title 为 Text 组件
  final Widget leading;
  final bool showLeading;
  final bool showDefault; // 是否去除默认的返回按钮，默认 true 显示
  final bool refresh; // 是否在点击返回按钮时携带参数
  final Color backGroundColor; // AppBar背景色
  final Color leadingColor; // leading 背景色
  final List<Widget> actions;
  final Widget bottom;
  final num barHeight;
  final double leadingSize;
  final IconData leadingIcon;
  @override
  final Size preferredSize;
  final VoidCallback leadingFn;

  CusAppBar({
    Key key,
    this.title,
    this.text: "",
    this.leading,
    this.showLeading: true,
    this.showDefault: false,
    this.refresh: false,
    this.backGroundColor: ter_primary,
    this.leadingColor: t_gray,
    this.actions,
    this.bottom,
    this.barHeight: appBarH,
    this.leadingSize: 32,
    this.leadingIcon: Icons.arrow_back_ios,
    this.leadingFn,
  })  : preferredSize = Size.fromHeight(barHeight),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
        title: title ??
            Text(
              text,
              style: TextStyle(color: t_gray, fontSize: Adapt.px(34)),
            ),
        elevation: 0,
        bottom: bottom,
        actions: actions,
        centerTitle: true,
        backgroundColor: backGroundColor,
        automaticallyImplyLeading: showDefault, // 去掉默认的返回按钮
        leading: showLeading
            ? leading ??
                IconButton(
                  icon: Icon(leadingIcon,
                      color: leadingColor, size: Adapt.px(leadingSize)),
                  onPressed: () {
                    leadingFn != null
                        ? leadingFn()
                        : Navigator.of(context).pop(refresh ? "" : null);
                  },
                )
            : null,
      ),
    );
  }
}
