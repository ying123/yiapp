import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/complex/post_trans.dart';
import 'package:yiapp/ui/question/post_cover.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/model/bbs/bbs_prize.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-bbs-prize.dart';
import 'package:yiapp/service/api/api_base.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/21 上午10:18
// usage ：会员悬赏帖待付款订单
// ------------------------------------------------------

class UserPrizeUnpaidPage extends StatefulWidget {
  UserPrizeUnpaidPage({Key key}) : super(key: key);

  @override
  _UserPrizeUnpaidPageState createState() => _UserPrizeUnpaidPageState();
}

class _UserPrizeUnpaidPageState extends State<UserPrizeUnpaidPage>
    with AutomaticKeepAliveClientMixin {
  var _future;
  int _pageNo = 0;
  int _rowsCount = 0;
  final int _rowsPerPage = 10; // 默认每页查询个数
  List<BBSPrize> _l = []; // 悬赏帖待付款列表

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 会员分页查询悬赏帖待付款订单
  _fetch() async {
    if (_pageNo * _rowsPerPage > _rowsCount) return;
    _pageNo++;
    var m = {
      "page_no": _pageNo,
      "rows_per_page": _rowsPerPage,
      "where": {"stat": bbs_unpaid, "uid": ApiBase.uid},
      "sort": {"create_date": -1},
    };
    try {
      PageBean pb = await ApiBBSPrize.bbsPrizePage(m);
      if (pb != null) {
        if (_rowsCount == 0) _rowsCount = pb.rowsCount ?? 0;
        Log.info("总的悬赏帖个数：$_rowsCount");
        var l = pb.data.map((e) => e as BBSPrize).toList();
        l.forEach((src) {
          var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
          if (dst == null) _l.add(src);
        });
        Log.info("当前已查询待付款悬赏帖多少条： ${_l.length}");
        setState(() {});
      }
    } catch (e) {
      Log.error("分页查询待付款的悬赏帖出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }
        return _lv();
      },
    );
  }

  Widget _lv() {
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: EasyRefresh(
        header: CusHeader(),
        footer: CusFooter(),
        onLoad: () async => await _fetch(),
        onRefresh: () async => await _refresh(),
        child: ListView(
          children: <Widget>[
            if (_l.isEmpty)
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: S.screenH() / 4),
                child: Text(
                  "暂无订单",
                  style: TextStyle(color: t_gray, fontSize: S.sp(15)),
                ),
              ),
            if (_l.isNotEmpty)
              ..._l.map(
                (e) => PostCover(post: Post(data: e), onChanged: _refresh),
              ),
          ],
        ),
      ),
    );
  }

  /// 刷新数据
  _refresh() async {
    _pageNo = _rowsCount = 0;
    _l.clear();
    setState(() {});
    await _fetch();
  }

  @override
  bool get wantKeepAlive => true;
}