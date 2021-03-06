import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/model/bo/broker_cate_res.dart';
import 'package:yiapp/model/bo/broker_master_cate.dart';
import 'package:yiapp/model/bo/broker_master_res.dart';
import 'package:yiapp/model/bo/broker_product_res.dart';
import 'package:yiapp/model/bo/price_level_res.dart';
import 'api_base.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/11/20 10:52
// usage ：bo 路由
// ------------------------------------------------------

class ApiBo {
  /// 用户获取，运营商悬赏帖收费标准
  static Future<List<PriceLevelRes>> brokerPriceLevelPrizeUserList() async {
    var url = w_yi_user + "BrokerPriceLevelPrizeUserList";
    var data = Map<String, dynamic>();
    return await ApiBase.postList(
        url, data, (l) => l.map((x) => PriceLevelRes.fromJson(x)).toList(),
        enableJwt: true);
  }

  /// 用户获取，运营商闪断帖收费标准
  static Future<List<PriceLevelRes>> brokerPriceLevelVieUserList() async {
    var url = w_yi_user + "BrokerPriceLevelVieUserList";
    var data = Map<String, dynamic>();
    return await ApiBase.postList(
        url, data, (l) => l.map((x) => PriceLevelRes.fromJson(x)).toList(),
        enableJwt: true);
  }

  /// 用户获取，运营商商品分类中的商品
  static brokerProductUserPage(Map<String, dynamic> pb) async {
    var url = w_yi_user + "BrokerProductUserPage";
    return await ApiBase.postPage(url, pb, (m) => BrokerProductRes.fromJson(m));
  }

  /// 运营商商品类别信息
  static Future<List<BrokerCateRes>> brokerCateList() async {
    var url = w_yi_user + "BrokerCateList";
    var data = {"broker_id": 0};
    return await ApiBase.postList(
        url, data, (l) => l.map((x) => BrokerCateRes.fromJson(x)).toList(),
        enableJwt: true);
  }

  /// U+B+S，查看运营商下面的大师
  static bMasterPage(Map<String, dynamic> pb) async {
    var url = w_yi_user + "BMasterPage";
    return await ApiBase.postPage(url, pb, (m) {
      return BrokerMasterRes.fromJson(m);
    }, enableJwt: true);
  }

  /// 用户获取运营商某个大师的服务项目列表
  static Future<List<BrokerMasterCate>> bmiPriceUserList(
      Map<String, dynamic> m) async {
    var url = w_yi_user + "BMIPriceUserList";
    return await ApiBase.postList(
        url, m, (l) => l.map((x) => BrokerMasterCate.fromJson(x)).toList(),
        enableJwt: true);
  }
}
