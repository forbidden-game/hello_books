import 'dart:async';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:hellobooks/constant/constants.dart';
import 'package:hellobooks/model/data.dart';
import 'package:hellobooks/widgets/toast.dart';

/// 产品详情页：以展示一张大图为主页面
class ProductDetailArguments {
  final List<String> pictureList;
  final int index;
  final Product product;

  ProductDetailArguments({
    this.pictureList,
    this.index,
    this.product,
  });
}

/// 图片预览页(理论上支持多张照片左右滑动)
class ProductDetailPage extends StatefulWidget {
  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with TickerProviderStateMixin {
  ProductDetailArguments args;
  int currentIndex;
  int initialIndex; // 初始index
  final double minScale = 1.0;
  final double maxScale = 2.0;
  var rebuildIndex = StreamController<int>.broadcast();
  var rebuildSwiper = StreamController<bool>.broadcast();
  AnimationController animationController;
  Animation<double> animation;
  Function() animationListener = () {};

  @override
  void initState() {
    currentIndex = 0;
    initialIndex = 0;
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    animation = animationController
        .drive(Tween<double>(begin: minScale, end: maxScale));
    super.initState();
  }

  @override
  void dispose() {
    rebuildIndex.close();
    rebuildSwiper.close();
    animationController?.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments;
    Widget result = Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.black,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              ExtendedImageGesturePageView.builder(
                itemBuilder: (context, index) {
                  return ExtendedImage.network(
                    args.pictureList[index],
                    fit: BoxFit.contain,
                    retries: 0,
                    enableSlideOutPage: true,
                    mode: ExtendedImageMode.gesture,
                    initGestureConfigHandler: (state) {
                      return GestureConfig(
                        inPageView: true,
                        initialScale: 1.0,
                        minScale: minScale,
                        animationMinScale: minScale / 2,
                        maxScale: maxScale,
                        animationMaxScale: maxScale * 2,
                        cacheGesture: false,
                      );
                    },
                    loadStateChanged: (state) {
                      switch (state.extendedImageLoadState) {
                        case LoadState.loading:
                          rebuildSwiper.add(false);
                          return _buildLoading();
                        case LoadState.completed:
                          rebuildSwiper.add(true);
                          return state.completedWidget;
                        case LoadState.failed:
                          rebuildSwiper.add(false);
                          return _buildError();
                        default:
                          return _buildLoading();
                      }
                    },
                    onDoubleTap: _handleDoubleTap,
                  );
                },
                itemCount: args.pictureList.length,
                onPageChanged: (int index) {
                  currentIndex = index;
                  rebuildIndex.add(index);
                },
                controller: PageController(
                  initialPage: currentIndex,
                ),
                scrollDirection: Axis.horizontal,
              ),
              StreamBuilder<bool>(
                builder: (context, snapshot) {
                  if (snapshot.data == null || !snapshot.data) {
                    return Container();
                  } else {
                    return BottomBarWidget(
                      args.pictureList,
                      args.product,
                      currentIndex,
                      rebuildIndex,
                    );
                  }
                },
                initialData: false,
                stream: rebuildSwiper.stream,
              ),
            ],
          ),
        ),
      ),
    );
    return result;
  }

  Widget _buildLoading() {
    return Image.asset("res/images/img_loading.gif");
  }

  Widget _buildError() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image.asset("res/images/icon_img_load_error.png", scale: 3),
        Padding(
          padding: const EdgeInsets.only(top: 19.0),
          child: Text(
            "图片加载失败",
            style: TextStyle(fontSize: 15, color: Color(0xFF999999)),
          ),
        ),
      ],
    );
  }

  /// 双击动画效果
  void _handleDoubleTap(ExtendedImageGestureState state) {
    var pointerDownPosition = state.pointerDownPosition;
    double begin = state.gestureDetails.totalScale;
    double end;
    animation?.removeListener(animationListener);
    animationController.stop();
    animationController.reset();
    end = begin == minScale ? maxScale : minScale;
    animationListener = () {
      state.handleDoubleTap(
        scale: animation.value,
        doubleTapPosition: pointerDownPosition,
      );
    };
    animation =
        animationController.drive(Tween<double>(begin: begin, end: end));
    animation.addListener(animationListener);
    animationController.forward();
  }
}

/// 底部一栏
class BottomBarWidget extends StatefulWidget {
  final List<String> pictures;
  final Product product;
  final int index;
  final StreamController<int> reBuild;

  BottomBarWidget(
    this.pictures,
    this.product,
    this.index,
    this.reBuild,
  );

  @override
  _BottomBarWidgetState createState() => _BottomBarWidgetState();
}

class _BottomBarWidgetState extends State<BottomBarWidget> {
  /// TODO 用户收藏状态还没有同步到服务器
  bool favorite = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      builder: (BuildContext context, data) {
        return Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18.0,
                  vertical: 28.0,
                ),
                child: IconButton(
                  icon: Icon(Icons.favorite),
                  iconSize: 30.0,
                  color:
                      favorite ? BookColors.alertColor : BookColors.hintColor,
                  highlightColor: BookColors.alertColor,
                  onPressed: () {
                    setState(() {
                      favorite = !favorite;
                    });
                    BookToast.toast(favorite ? "已收藏" : "已取消收藏");
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                      NetworkImage(widget.product.user.avatar.url ?? ""),
                  backgroundColor: Colors.grey,
                  radius: 20.0,
                ),
                title: Text(
                  widget.product.user.username ?? "",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: BookColors.alertColor),
                ),
                subtitle: Text(
                  widget.product.book.desc ?? "",
                  style: Theme.of(context).textTheme.body2,
                ),
                trailing: RaisedButton(
                  padding: EdgeInsets.all(8.0),
                  child: Text("立即" + widget.product.getTypeLabel(),
                      style: TextStyle(fontSize: 16.0)),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  onPressed: () {
                    BookToast.toast(
                        "模拟" + widget.product.getTypeLabel() + "完成");
                  },
                ),
              ),
            ),
          ],
        );
      },
      initialData: widget.index,
      stream: widget.reBuild.stream,
    );
  }
}
