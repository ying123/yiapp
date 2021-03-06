// ------------------------------------------------------
// author：suxing
// date  ：2021/1/7 下午2:48
// usage ：大师月度对账单结果
// ------------------------------------------------------

class MasterMonthRes {
  num amt_bbs_prize; // 悬赏帖总额
  num amt_bbs_vie; // 闪断帖总额
  num amt_draw_money; // 总提现
  num amt_yi_order; // 大师订单总额
  num amt_yi_order_r; // 大师订单总退款额，带 r 的代表退款
  int id; // 对账单所处的ID，诸如 1 2 3等
  String icon;
  int month; // 查询哪一月
  String nick;
  num profit_bbs_prize; // 悬赏帖订单利润
  num profit_bbs_vie; // 闪断帖订单利润
  num profit_yi_order; // 大师订单利润
  int qty_bbs_prize; // 悬赏帖总订单数量
  int qty_bbs_vie; // 闪断帖总个数
  int qty_draw_money; // 提现总个数
  int qty_yi_order; // 大师订单总个数
  int qty_yi_order_r; // 大师订单退款总个数
  int uid;
  int year; // 查询哪一年

  MasterMonthRes({
    this.amt_bbs_prize,
    this.amt_bbs_vie,
    this.amt_draw_money,
    this.amt_yi_order,
    this.amt_yi_order_r,
    this.id,
    this.icon,
    this.month,
    this.nick,
    this.profit_bbs_prize,
    this.profit_bbs_vie,
    this.profit_yi_order,
    this.qty_bbs_prize,
    this.qty_bbs_vie,
    this.qty_draw_money,
    this.qty_yi_order,
    this.qty_yi_order_r,
    this.uid,
    this.year,
  });

  factory MasterMonthRes.fromJson(Map<String, dynamic> json) {
    return MasterMonthRes(
      amt_bbs_prize: json['amt_bbs_prize'],
      amt_bbs_vie: json['amt_bbs_vie'],
      amt_draw_money: json['amt_draw_money'],
      amt_yi_order: json['amt_yi_order'],
      amt_yi_order_r: json['amt_yi_order_r'],
      id: json['ID'],
      icon: json['icon'],
      month: json['month'],
      nick: json['nick'],
      profit_bbs_prize: json['profit_bbs_prize'],
      profit_bbs_vie: json['profit_bbs_vie'],
      profit_yi_order: json['profit_yi_order'],
      qty_bbs_prize: json['qty_bbs_prize'],
      qty_bbs_vie: json['qty_bbs_vie'],
      qty_draw_money: json['qty_draw_money'],
      qty_yi_order: json['qty_yi_order'],
      qty_yi_order_r: json['qty_yi_order_r'],
      uid: json['uid'],
      year: json['year'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['amt_bbs_prize'] = this.amt_bbs_prize;
    data['amt_bbs_vie'] = this.amt_bbs_vie;
    data['amt_draw_money'] = this.amt_draw_money;
    data['amt_yi_order'] = this.amt_yi_order;
    data['amt_yi_order_r'] = this.amt_yi_order_r;
    data['ID'] = this.id;
    data['icon'] = this.icon;
    data['month'] = this.month;
    data['nick'] = this.nick;
    data['profit_bbs_prize'] = this.profit_bbs_prize;
    data['profit_bbs_vie'] = this.profit_bbs_vie;
    data['profit_yi_order'] = this.profit_yi_order;
    data['qty_bbs_prize'] = this.qty_bbs_prize;
    data['qty_bbs_vie'] = this.qty_bbs_vie;
    data['qty_draw_money'] = this.qty_draw_money;
    data['qty_yi_order'] = this.qty_yi_order;
    data['qty_yi_order_r'] = this.qty_yi_order_r;
    data['uid'] = this.uid;
    data['year'] = this.year;
    return data;
  }
}
