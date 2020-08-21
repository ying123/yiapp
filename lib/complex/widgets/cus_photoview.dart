import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/17 11:15
// usage ：点击图片后，可左右滑动、放大缩小
// ------------------------------------------------------

class CusPhotoView extends StatefulWidget {
  final List imageList;
  final int index;

  CusPhotoView({this.imageList, this.index = 0});

  @override
  _CusPhotoViewState createState() => _CusPhotoViewState();
}

class _CusPhotoViewState extends State<CusPhotoView> {
  int curIndex = 0; // 当前选中图片的索引

  @override
  void initState() {
    curIndex = widget.index;
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // 取消默认的返回按钮
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.black),
        constraints:
            BoxConstraints.expand(height: MediaQuery.of(context).size.height),
        child: _photoBuilder(),
      ),
    );
  }

  /// 显示图片界面
  Widget _photoBuilder() {
    return InkWell(
      child: Stack(
        children: <Widget>[
          PhotoViewGallery.builder(
            onPageChanged: onPageChanged, // 根据当前选中图片的索引显示页面
            scrollDirection: Axis.horizontal, // 左右滑动
            itemCount: widget.imageList.length,
            backgroundDecoration: BoxDecoration(color: Colors.black),
            pageController: PageController(initialPage: curIndex),
            scrollPhysics: const BouncingScrollPhysics(),
            loadingBuilder: (context, event) {
              return Center(
                child: CircularProgressIndicator(),
              );
            },
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(widget.imageList[index]['path']),
                initialScale: PhotoViewComputedScale.contained * 1,
                minScale: PhotoViewComputedScale.contained * 0.3,
                maxScale: PhotoViewComputedScale.contained * 2,
              );
            },
          ),
          Align(
            alignment: Alignment(0, 0.9),
            child: Text(
              '${curIndex + 1} / ${widget.imageList.length}',
              style: TextStyle(color: Colors.white, fontSize: Adapt.px(35)),
            ),
          ),
        ],
      ),
      onTap: () => Navigator.of(context).pop(),
      onLongPress: () {
        var item = widget.imageList[curIndex];
        _showBottomSheet(item['key'], item['path']);
      },
    );
  }

  void onPageChanged(int index) {
    curIndex = index;
    setState(() {});
  }

  /// 底部弹框
  void _showBottomSheet(String key, path) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15), topRight: Radius.circular(15)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
                title: Text('收藏', textAlign: TextAlign.center),
                onTap: () async {
                  Navigator.pop(context);
//                  String res = await Cus.addFavorite(
//                      source: Favorite_SOURCE_IMAGE, key: key, path: path);
//                  if (res != null || res?.isNotEmpty) {
//                    CusToast.toast(context, text: '收藏成功');
//                  }
                }),
            Divider(height: 0, thickness: 1),
            ListTile(
              title: Text('取消', textAlign: TextAlign.center),
              onTap: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}