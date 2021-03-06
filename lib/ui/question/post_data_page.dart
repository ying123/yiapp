import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_role.dart';
import 'package:yiapp/model/bbs/bbs_vie.dart';
import 'package:yiapp/model/complex/post_trans.dart';
import 'package:yiapp/service/api/api-bbs-vie.dart';
import 'package:yiapp/ui/question/post_cover.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/model/bbs/bbs_prize.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-bbs-prize.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/10 上午 9:28
// usage ：显示悬赏帖、闪断帖
// ------------------------------------------------------

class PostDataPage extends StatefulWidget {
  final bool is_vie;
  // 是否从问命页面查看的悬赏帖和闪断帖，在问命页面用的是bbsPrizePage2，该路由含有
  // 已支付但未被抢的，以及已经被打赏过的两种情况
  // 除从问命页面进来的，其它的用的是bbsPrizePage路由
  final bool isQue;

  PostDataPage({this.is_vie: false, this.isQue: false, Key key})
      : super(key: key);

  @override
  _PostDataPageState createState() => _PostDataPageState();
}

class _PostDataPageState extends State<PostDataPage>
    with AutomaticKeepAliveClientMixin {
  var _future;
  int _pageNo = 0;
  int _rowsCount = 0;
  final int _rowsPerPage = 10; // 默认每页查询个数
  List _l = [];

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 分页查询悬赏帖中已付款的帖子，闪断帖中已付款但未被抢的单子
  _fetch() async {
    if (_pageNo * _rowsPerPage > _rowsCount) return;
    _pageNo++;
    // 问命页面查看的是已支付但未被抢的，以及已经被打赏过的
    Map<String, dynamic> queWhere = {
      "stat": {"\$gte": bbs_paid},
    };
    Map<String, dynamic> otherWhere = {"stat": bbs_paid};
    // 大师查看所有的帖子，会员只查看运营商下大师的帖子
    if (CusRole.is_vip) {
      widget.isQue
          ? queWhere.addAll({"broker_id": CusRole.broker_id})
          : otherWhere.addAll({"broker_id": CusRole.broker_id});
    }
    var m = {
      "page_no": _pageNo,
      "rows_per_page": _rowsPerPage,
      "where": widget.isQue ? queWhere : otherWhere,
      "sort": {"create_date_int": -1}, // 按时间倒序排列
    };
    widget.is_vie ? await _fetchVie(m) : await _fetchPrize(m);
  }

  /// 获取悬赏帖
  _fetchPrize(Map<String, dynamic> m) async {
    try {
      PageBean pb = await ApiBBSPrize.bbsPrizePage2(m);
      if (pb != null) {
        if (_rowsCount == 0) _rowsCount = pb.rowsCount ?? 0;
        Log.info("悬赏帖总条数：$_rowsCount");
        var l = pb.data.map((e) => e as BBSPrize).toList();
        l.forEach((src) {
          var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
          if (dst == null) _l.add(src);
        });
        Log.info("当前已查询多少条悬赏帖：${_l.length}");
        setState(() {});
      }
    } catch (e) {
      Log.error("分页查询悬赏帖出现异常：$e");
    }
  }

  /// 获取闪断帖
  _fetchVie(Map<String, dynamic> m) async {
    try {
      PageBean pb = await ApiBBSVie.bbsViePage2(m);
      if (pb != null) {
        if (_rowsCount == 0) _rowsCount = pb.rowsCount ?? 0;
        Log.info("闪断帖总条数：$_rowsCount");
        var l = pb.data.map((e) => e as BBSVie).toList();
        l.forEach((src) {
          var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
          if (dst == null) _l.add(src);
        });
        Log.info("当前已查询多少条闪断帖：${_l.length}");
        setState(() {});
      }
    } catch (e) {
      Log.error("分页查询闪断帖出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: FutureBuilder(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          return _lv();
        },
      ),
    );
  }

  Widget _lv() {
    return EasyRefresh(
      header: CusHeader(),
      footer: CusFooter(),
      onLoad: () async => _fetch(),
      onRefresh: () async => _refresh(),
      child: ListView(
        // 显示帖子
        children: <Widget>[
          if (_l.isEmpty) _noData(),
          ..._l.map(
            (e) => PostCover(
              post: Post(
                data: e,
                is_vie: widget.is_vie,
//                is_ing: widget.isQue ? e.stat == bbs_paid : false,
//                is_his: widget.isQue ? e.stat == bbs_ok : false,
//                is_ing: e.stat == bbs_paid,
//                is_his: e.stat == bbs_ok,
              ),
              onChanged: _refresh,
            ),
          ),
        ],
      ),
    );
  }

  /// 显示没有帖子
  Widget _noData() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: S.screenH() / 4),
      child: Text(
        "暂无帖子",
        style: TextStyle(color: t_gray, fontSize: S.sp(15)),
      ),
    );
  }

  void _refresh() async {
    _pageNo = _rowsCount = 0;
    _l.clear();
    setState(() {});
    await _fetch();
  }

  @override
  bool get wantKeepAlive => true;
}
