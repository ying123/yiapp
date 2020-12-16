import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/model/complex/post_trans.dart';
import 'package:yiapp/service/api/api-bbs-vie.dart';
import 'package:yiapp/ui/mine/my_orders/refund_add.dart';
import 'package:yiapp/ui/question/post_header.dart';
import 'package:yiapp/ui/question/post_input.dart';
import 'package:yiapp/ui/question/post_reply.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_role.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/model/bbs/bbs_reply.dart';
import 'package:yiapp/service/api/api-bbs-prize.dart';
import 'package:yiapp/service/api/api_base.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/10 上午10:56
// usage ：单条帖子详情（1、查询单条帖子、2、查询单条帖子历史）
// ------------------------------------------------------

class PostContent extends StatefulWidget {
  final Post post;

  PostContent({this.post, Key key}) : super(key: key);

  @override
  _PostContentState createState() => _PostContentState();
}

class _PostContentState extends State<PostContent> {
  var _data; // 单条帖子数据
  var _future;
  int _pageNo = 0;
  int _replyNum = 0; // 回复评论的条数
  bool _loadAll = false; // 是否加载完毕
  var _scrollCtrl = ScrollController();
  var _easyCtrl = EasyRefreshController();
  List<BBSReply> _l = []; // 帖子评论列表
  Post _p;

  @override
  void initState() {
    _p = widget.post;
    print(">>>_p:${_p.toJson()}");
    _future = _fetch();
    super.initState();
  }

  /// 获取单条帖子详情
  _fetch() async {
    _whatPost(); // 打印帖子类型
    var data;
    try {
      if (_p.is_his) {
        data = _p.is_vie
            ? await ApiBBSVie.bbsVieHisGet(_p.data.id)
            : await ApiBBSPrize.bbsPrizeHisGet(_p.data.id);
      } else {
        data = _p.is_vie
            ? await ApiBBSVie.bbsVieGet(_p.data.id)
            : await ApiBBSPrize.bbsPrizeGet(_p.data.id);
      }
      if (data != null) {
        _data = data;
        _replyNum = _data.master_reply.length;
        Log.info("帖子评论总条数：$_replyNum");
        if (_l.isEmpty) _fetchReply();
      }
      Log.info("当前查询的帖子详情：${_data.toJson()}");
    } catch (e) {
      Log.error("查询单条帖子出现异常：$e");
    }
  }

  /// 模拟分页加载评论列表
  void _fetchReply() async {
    final int count = 20; // 默认每次加载20条
    if (_pageNo * count > _replyNum) {
      setState(() => _loadAll = true);
      return;
    }
    _pageNo++;
    _l = _data.master_reply.take(_pageNo * count).toList();
    Log.info("当前已加载评论条数：${_l.length}");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // FutureBuilder在外部，因为是否显示投诉(_data.stat)需要先等_data有结果
    return FutureBuilder(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          appBar: _appBar(),
          body: _lv(),
          backgroundColor: primary,
        );
      },
    );
  }

  Widget _appBar() {
    var u = _data;
    var style = TextStyle(color: t_gray, fontSize: S.sp(15));
    String bType = _p.is_vie ? b_bbs_vie : b_bbs_prize;
    return CusAppBar(
      text: "问题详情",
      actions: <Widget>[
        // 发帖人是自己，且订单已支付，显示投诉功能
        if (u.stat == bbs_ok && u.uid == ApiBase.uid)
          FlatButton(
            child: Text("投诉", style: style),
            onPressed: () {
              CusRoute.push(context, RefundOrderAdd(data: u, b_type: bType));
            },
          )
      ],
    );
  }

  /// 回帖输入框
  Widget _postInput() {
    // 查看历史帖子时不需要显示回帖输入框
    if (!_p.is_his) {
      // 大师和发帖人可以回复
      if (CusRole.is_master || _data.uid == ApiBase.uid) {
        return PostInput(
          post: Post(data: _data, is_vie: widget.post.is_vie),
          onSend: () async {
            _refresh();
            Timer(
              Duration(milliseconds: 500),
              () => _scrollCtrl.jumpTo(_scrollCtrl.position.maxScrollExtent),
            );
          },
        );
      }
    }
    return SizedBox.shrink();
  }

  Widget _lv() {
    // 没有帖子数据时
    if (_data == null) {
      return Container(
        alignment: Alignment.center,
        child: Text(
          "帖子找不到了~",
          style: TextStyle(color: t_gray, fontSize: S.sp(15)),
        ),
        padding: EdgeInsets.only(bottom: (S.screenH() / 2)),
      );
    }
    // 有帖子数据时
    return EasyRefresh(
      header: CusHeader(),
      footer: CusFooter(),
      controller: _easyCtrl,
      child: ListView(
        controller: _scrollCtrl,
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          PostHeader(data: _data), // 帖子头部信息
          Padding(
            padding: EdgeInsets.symmetric(vertical: S.h(10)),
            child: Divider(height: 0, thickness: 0.2, color: t_gray),
          ),
          Center(
            child: Text(
              _replyNum == 0 ? "暂无评论" : "评论区",
              style: TextStyle(color: t_primary, fontSize: S.sp(16)),
            ),
          ),
          PostReply(data: _data), // 帖子评论区域
        ],
      ),
      onLoad: _loadAll
          ? null
          : () async {
              await Future.delayed(Duration(milliseconds: 100));
              _fetchReply();
            },
      onRefresh: () async => await _refresh(),
    );
  }

  Future<void> _refresh() async {
    _l.clear();
    _pageNo = _replyNum = 0;
    _loadAll = false;
    await _fetch();
    setState(() {});
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    _easyCtrl.dispose();
    super.dispose();
  }

  /// 打印帖子类型
  void _whatPost() {
    String type = widget.post.is_vie ? '闪断帖' : '悬赏帖';
    String his = widget.post.is_his ? '历史' : '';
    Log.info("------------- 查询单条$type$his的内容 -------------");
  }
}
