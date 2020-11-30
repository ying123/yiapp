// ------------------------------------------------------
// author：suxing
// date  ：2020/11/30 下午7:06
// usage ：正则表达式
// ------------------------------------------------------

class Reg {
  /// 精准验证18位身份证号码
  static final String IdCard =
      "^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9Xx])\$";

  /// 验证邮箱
  static final String Email =
      "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$";

  /// 验证 url
  static final String Url = "[a-zA-Z]+://[^\\s]*";

  /// 验证汉字
  static final String Zh = "[\\u4e00-\\u9fa5]";

  /// 精准验证手机号
  // 中国移动: 134(0-8), 135, 136, 137, 138, 139, 147, 150, 151,
  // 152, 157, 158, 159, 178, 182, 183, 184, 187, 188, 198
  // 中国联通: 130, 131, 132, 145, 155, 156, 166, 171, 175, 176, 185, 186
  // 中国电信: 133, 153, 173, 177, 180, 181, 189, 191，199
  // 卫星通信: 1349
  // 虚拟运营商: 170
  static final String mobile =
      "^((13[0-9])|(14[5,7])|(15[0-3,5-9])|(16[6])|(17[0,1,3,5-8])|(18[0-9])|(19[1,8,9]))\\d{8}\$";

  /// 验证电话号码
  static final String tel = "^0\\d{2,3}[- ]?\\d{7,8}";

  /// 验证 IP 地址
  static final String ip =
      "((2[0-4]\\d|25[0-5]|[01]?\\d\\d?)\\.){3}(2[0-4]\\d|25[0-5]|[01]?\\d\\d?)";
}
