import 'package:yiapp/const/con_string.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/1 下午5:13
// usage ：运势页面列表数据
// ------------------------------------------------------

class LuckList {
  ///  本地资源轮播
  static final List<String> loops = [
    "loop_1.jpg",
    "loop_2.png",
    "loop_3.jpg",
    "loop_4.jpg",
  ];

  /// 付费测算
  static final List<Map> pay = [
    {
      "text": "四柱测算",
      "icon": 0xeb00,
      "color": 0xFFEEA988,
      "route": r_sizhu,
    },
    {
      "text": "六爻排盘",
      "icon": 0xe633,
      "color": 0xFFA18CF7,
      "route": r_liu_yao,
    },
    {
      "text": "姻缘测算",
      "icon": 0xe606,
      "color": 0xFFE86E66,
      "route": r_he_hun,
    },
  ];

  /// 免费测算
  static final List<Map> free = [
    // 热门配对
    {
      "text": "星座配对",
      "icon": 0xe69e,
      "color": 0xFFF0D15F,
      "route": r_con_pair,
    },
    {
      "text": "生肖配对",
      "icon": 0xe6b1,
      "color": 0xFF78BA3B,
      "route": r_zodiac_pair
    },
    {
      "text": "血型配对",
      "icon": 0xe656,
      "color": 0xFFDE524B,
      "route": r_blood_pair
    },
    {
      "text": "生日配对",
      "icon": 0xe728,
      "color": 0xFF74C1FA,
      "route": r_birth_pair
    },
    // 热门灵签
    {
      "text": "观音灵签",
      "icon": 0xe601,
      "color": 0xFFB991DB,
      "route": r_com_draw,
    },
    {
      "text": "月老灵签",
      "icon": 0xe606,
      "color": 0xFFE1567C,
      "route": r_com_draw,
    },
    {
      "text": "关公灵签",
      "icon": 0xe627,
      "color": 0xFFEB7949,
      "route": r_com_draw,
    },
    {
      "text": "大仙灵签",
      "icon": 0xe600,
      "color": 0xFF67C76C,
      "route": r_com_draw,
    },
    {
      "text": "妈祖灵签",
      "icon": 0xe668,
      "color": 0xFFEDBF4F,
      "route": r_com_draw,
    },
    {
      "text": "吕祖灵签",
      "icon": 0xebcd,
      "color": 0xFF81D755,
      "route": r_com_draw,
    },
    {
      "text": "车公灵签",
      "icon": 0xe604,
      "color": 0xFF75C1E9,
      "route": r_com_draw,
    },
    // 个性推荐
    {
      "text": "精选文章",
      "icon": 0xe6b5,
      "color": 0xFFB991DB,
      "route": r_article,
    },
    {
      "text": "周公解梦",
      "icon": 0xe6ce,
      "color": 0xFFDE524B,
      "route": r_zhou_gong,
    },
  ];
}
