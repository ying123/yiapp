import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/6 17:15
// usage ：自定义 AppBar
// ------------------------------------------------------

class CusAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final String text; // title 为空时，r给 text 赋值则默认 title 为 Text 组件
  final Widget leading;
  final bool showLeading;
  final bool showDefault; // 是否去除默认的返回按钮，默认 true 显示
  final dynamic backData; // 点击返回按钮时，是否携带参数，默认空
  final Color textColor; // appbar 主标题文字颜色
  final Color backGroundColor; // AppBar背景色
  final Color leadingColor; // leading 背景色
  final List<Widget> actions;
  final Widget bottom;
  final double barHeight;
  final double leadingSize;
  final IconData leadingIcon;
  @override
  final Size preferredSize;
  final VoidCallback leadingFn; // 点击返回按钮时要执行的函数，默认空

  CusAppBar({
    Key key,
    this.title,
    this.text: "",
    this.leading,
    this.showLeading: true,
    this.showDefault: false,
    this.backData,
    this.textColor: t_gray,
    this.backGroundColor: ter_primary,
    this.leadingColor: t_gray,
    this.actions,
    this.bottom,
    this.barHeight: 46,
    this.leadingSize: 20,
    this.leadingIcon: Icons.arrow_back_ios,
    this.leadingFn,
  })  : preferredSize = Size.fromHeight(barHeight),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var t = title ??
        Text(
          text,
          style: TextStyle(color: textColor, fontSize: 18),
        );
    var lead = showLeading
        ? leading ??
            IconButton(
              icon: Icon(leadingIcon, color: leadingColor, size: leadingSize),
              onPressed: () {
                leadingFn != null
                    ? leadingFn()
                    : Navigator.of(context).pop(backData);
              },
            )
        : null;
    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
        title: t,
        elevation: 0,
        bottom: bottom,
        actions: actions,
        centerTitle: true,
        backgroundColor: backGroundColor,
        automaticallyImplyLeading: showDefault, // 去掉默认的返回按钮
        leading: lead,
      ),
    );
  }
}
