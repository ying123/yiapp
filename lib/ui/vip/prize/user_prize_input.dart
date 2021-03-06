import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/bbs/bbs_prize.dart';
import 'package:yiapp/model/bbs/prize_master_reply.dart';
import 'package:yiapp/service/api/api-bbs-prize.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/22 上午9:44
// usage ：会员回复悬赏帖
// ------------------------------------------------------

class UserPrizeInput extends StatefulWidget {
  // 用户选择大师进行回复，大师不需要这个
  final BBSPrizeReply selectMaster;
  final BBSPrize prize;
  final VoidCallback onSend;

  UserPrizeInput({this.selectMaster, this.prize, this.onSend, Key key})
      : super(key: key);

  @override
  _UserPrizeInputState createState() => _UserPrizeInputState();
}

class _UserPrizeInputState extends State<UserPrizeInput> {
  var _replyCtrl = TextEditingController();
  var _focusNode = FocusNode();
  bool _isSending = false; // 是否正在发送

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(child: _input(), color: Colors.grey),
        ),
        _sendMsgWt(),
      ],
    );
  }

  Widget _input() {
    return LayoutBuilder(
      builder: (context, size) {
        var text = TextSpan(
          text: _replyCtrl.text,
          style: TextStyle(fontSize: S.sp(14)),
        );
        var tp = TextPainter(
          text: text,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.left,
        );
        tp.layout(maxWidth: size.maxWidth);
        final int lines = (tp.size.height / tp.preferredLineHeight).ceil();
        return TextField(
          controller: _replyCtrl,
          autofocus: false,
          focusNode: _focusNode,
          style: TextStyle(color: Colors.black, fontSize: S.sp(14)),
          maxLines: lines < 8 ? null : 8,
          decoration: InputDecoration(
            hintText: _hintText(),
            hintStyle: TextStyle(color: Colors.black, fontSize: S.sp(14)),
            contentPadding: EdgeInsets.only(left: S.w(10)),
          ),
        );
      },
    );
  }

  Widget _sendMsgWt() {
    return Container(
      color: t_yi,
      child: FlatButton(
        onPressed: _isSending ? null : _doReply,
        child: Row(
          children: <Widget>[
            if (_isSending) ...[
              SizedBox(
                height: S.h(20),
                width: S.w(20),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(width: S.w(5)),
            ],
            Text(
              "发送",
              style: TextStyle(color: Colors.black, fontSize: S.sp(14)),
            ),
          ],
        ),
        padding: EdgeInsets.all(0),
      ),
    );
  }

  /// 选择大师后，发送评论
  void _doReply() async {
    if (widget.prize.master_reply.isEmpty) {
      CusToast.toast(context, text: "请等待大师回复");
      return;
    }
    if (widget.selectMaster == null) {
      CusToast.toast(context, text: "未选择回复哪位大师");
      return;
    }
    if (_replyCtrl.text.trim().isEmpty) {
      CusToast.toast(context, text: "请输入回复内容");
      return;
    }
    var m = {
      "id": widget.prize.id,
      "to_master": widget.selectMaster.master_id,
      "text": [_replyCtrl.text.trim()],
    };
    Log.info("会员回复悬赏帖的数据：$m");
    setState(() => _isSending = true);
    try {
      bool ok = await ApiBBSPrize.bbsPrizeReply(m);
      if (ok) {
        _isSending = false;
        _replyCtrl.clear();
        _focusNode.unfocus();
        CusToast.toast(context, text: "回帖成功");
        setState(() {});
        if (widget.onSend != null) widget.onSend();
      }
    } catch (e) {
      _isSending = false;
      setState(() {});
      Log.error("会员回复悬赏帖出现异常：$e");
    }
  }

  String _hintText() {
    if (widget.prize.master_reply.isEmpty) {
      return "请等待大师回复";
    } else {
      if (widget.selectMaster == null) {
        return "选择一位大师进行回复";
      }
      return "回复：${widget.selectMaster.master_nick}";
    }
  }
}
