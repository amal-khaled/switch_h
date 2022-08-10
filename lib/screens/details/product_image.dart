import 'package:flutter/material.dart';
import 'package:sweet/constants.dart';

class ProductImageWidget extends StatefulWidget {
  final String productImage;
  const ProductImageWidget({Key key, this.productImage}) : super(key: key);

  @override
  State<ProductImageWidget> createState() => _ProductImageWidgetState();
}

class _ProductImageWidgetState extends State<ProductImageWidget>
    with SingleTickerProviderStateMixin {
  TransformationController transformationController;

  AnimationController animationController;
  TapDownDetails tapDownDetails;
  Animation<Matrix4> animation;
  @override
  void initState() {
    transformationController = TransformationController();
    animationController = AnimationController(
        vsync: this, duration: const Duration(microseconds: 200))
      ..addListener(() => transformationController.value = animation.value);
    super.initState();
  }

  @override
  void dispose() {
    transformationController.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return PreferredSize(
      preferredSize: Size(w, h),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0.0,
          iconTheme: IconThemeData(color: brandColor),
        ),
        body: GestureDetector(
          onDoubleTap: () {
            final position = tapDownDetails.localPosition;
            const double scale = 3.0;
            final x = -position.dx * (scale - 1);
            final y = -position.dy * (scale - 1);
            final zoomed = Matrix4.identity()
              ..translate(x, y)
              ..scale(scale);
            final end = transformationController.value.isIdentity()
                ? zoomed
                : Matrix4.identity();
            animation = Matrix4Tween(
              begin: transformationController.value,
              end: end,
            ).animate(
              CurveTween(curve: Curves.easeOut)
                  .animate(animationController),
            );
            animationController.forward(from: 0);
          },
          onDoubleTapDown: (details) => tapDownDetails = details,
          child: InteractiveViewer(
            clipBehavior: Clip.none,
            // maxScale: 4,
            // minScale: 1,
            panEnabled: false,
            transformationController: transformationController,
            child: Container(
              width: w,
              height: h,
              decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                    image: NetworkImage(
                      widget.productImage,
                    ),
                    fit: BoxFit.contain),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
