import 'dart:io';

import 'package:yiapp/complex/class/yi_date_time.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/7 10:22
// usage ：自定义回调函数
// ------------------------------------------------------

typedef FnInt = void Function(int uid);
typedef FnBool = void Function(bool value);
typedef FnString = void Function(String value);
typedef FnDynamic = void Function(dynamic value);
typedef FnDate = void Function(DateTime date);
typedef FnYiDate = void Function(YiDateTime date);
typedef FnFile = void Function(File file);
