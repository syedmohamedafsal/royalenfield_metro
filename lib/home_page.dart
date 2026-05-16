import 'dart:math';

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:some3d/utils/image_sequence.dart';

class HomePage extends StatefulWidget {
  HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late double screenHeight, screenWidth;
  late double bikeSpecsWidth;
  late double addedScreenHeight;
  late double onDragPositionStart;
  bool isBikeSpecsVisible = false;
  late AnimationController animationController;

  List<String> bikeSpecsImages = [
    'assets/images/bike_specs_disp.png',
    'assets/images/bike_specs_type.png',
    'assets/images/bike_specs_break.png',
    'assets/images/bike_specs_cylinder.png',
    'assets/images/bike_specs_fuel.png',
    'assets/images/bike_specs_height.png',
  ];

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    addedScreenHeight = 0.2 * screenHeight;
    bikeSpecsWidth = 0.35 * screenWidth;

    super.didChangeDependencies();
  }

  void onDragStartFunction(DragStartDetails dragStartDetails) {
    // to mark starting position
    onDragPositionStart = dragStartDetails.globalPosition.dx;
  }

  void onDragUpdateFunction(DragUpdateDetails dragStartDetails) {
    var dragDistance = dragStartDetails.globalPosition.dx - onDragPositionStart;
    var dragDistanceFactor;

    if (dragDistance > 0) {
      dragDistanceFactor = dragDistance / screenWidth;
      // do nothing if the drag continues in the direction of
      // making specs visible, even though they are already visible
      if (isBikeSpecsVisible && dragDistanceFactor <= 1.0) return;
      // goto "for drag" of onDragEndFunction
      animationController.value = dragDistanceFactor;
    } else {
      dragDistanceFactor = 1 + (dragDistance / screenWidth);
      if (!isBikeSpecsVisible && dragDistanceFactor >= 0.0) return;
      animationController.value = dragDistanceFactor;
    }
  }

  void onDragEndFunction(DragEndDetails dragStartDetails) {
    // for swipe
    if (dragStartDetails.velocity.pixelsPerSecond.dx.abs() > 500) {
      if (dragStartDetails.velocity.pixelsPerSecond.dx > 0) {
        animationController.forward(from: animationController.value);
        isBikeSpecsVisible = true;
      } else {
        animationController.reverse(from: animationController.value);
        isBikeSpecsVisible = false;
      }
      return;
    }
    // for drag
    if (animationController.value > 0.5) {
      animationController.forward(from: animationController.value);
      isBikeSpecsVisible = true;
    } else {
      animationController.reverse(from: animationController.value);
      isBikeSpecsVisible = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          // Main Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Color(0xFFF5F5F5),
                  Color(0xFFE0E0E0),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),
          
          GestureDetector(
            onHorizontalDragStart: onDragStartFunction,
            onHorizontalDragUpdate: onDragUpdateFunction,
            onHorizontalDragEnd: onDragEndFunction,
            behavior: HitTestBehavior.opaque,
            child: Stack(
              children: <Widget>[
                bikeBackgroundWidget(),
                bikeWidget(),
                bikeForegroundWidget(),
                bikeSpecsWidget(),
                bikeSpecsFooterWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget bikeBackgroundWidget() {
    return Positioned.fill(
      top: -addedScreenHeight,
      bottom: -addedScreenHeight,
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, widget) => Transform.translate(
          offset: Offset(bikeSpecsWidth * animationController.value, 0),
          child: Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY((pi / 2 + 0.1) * -animationController.value),
            alignment: Alignment.centerLeft,
            child: widget,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.white70,
                Colors.white54,
                Colors.white,
              ],
            ),
          ),
          child: Stack(
            children: <Widget>[
              AnimatedBuilder(
                animation: animationController,
                builder: (_, __) => Container(
                  color: Colors.blue.withAlpha(
                    (20 * animationController.value).floor(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bikeWidget() {
    return Positioned.fill(
      left: bikeSpecsWidth - screenWidth * 0.3,
      right: screenWidth * 0.4 - bikeSpecsWidth,
      child: Container(
        child: AnimatedBuilder(
          animation: animationController,
          builder: (_, __) => ImageSequence(
            imageRelativePath: "assets/bikeImageSequence/",
            imageNameIncrement: 1,
            imageNameLength: 4,
            imageFileFormat: ".png",
            totalImages: 120,
            currentImage: (animationController.value * 120).ceil(),
          ),
        ),
      ),
    );
  }

  Widget bikeForegroundWidget() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, widget) => Opacity(
          opacity: 1 - animationController.value,
          child: Transform.translate(
            offset: Offset((bikeSpecsWidth + 50) * animationController.value, 0),
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY((pi / 2 + 0.1) * -animationController.value),
              alignment: Alignment.centerLeft,
              child: widget,
            ),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(10),
                    child: Image.asset('assets/images/royal_enfield_symbol.png'),
                  ),
                  Container(
                    height: 30,
                    child: Image.asset(
                      'assets/images/royal_enfield.png',
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.1),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/bike_model_name.png',
                    height: 60,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bikeSpecsWidget() {
    return Positioned.fill(
      top: -addedScreenHeight,
      bottom: -addedScreenHeight,
      right: screenWidth - bikeSpecsWidth,
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, widget) {
          return Transform.translate(
            offset: Offset(bikeSpecsWidth * (animationController.value - 1), 0),
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(pi * (1 - animationController.value) / 2),
              alignment: Alignment.centerRight,
              child: widget,
            ),
          );
        },
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.4),
                border: Border(
                  right: BorderSide(
                    color: Colors.black.withOpacity(0.05),
                    width: 0.5,
                  ),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.white.withOpacity(0.6),
                    Colors.white.withOpacity(0.2),
                  ],
                ),
              ),
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    top: addedScreenHeight,
                    bottom: addedScreenHeight,
                    child: Container(
                      width: bikeSpecsWidth,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Image.asset(
                                'assets/images/bike_logo.png',
                                height: 50,
                              ),
                            ),
                            for (var specsIndex = 0;
                                specsIndex <= bikeSpecsImages.length - 1;
                                specsIndex++)
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child:
                                      Image.asset(bikeSpecsImages[specsIndex]),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Subtle highlight
                  AnimatedBuilder(
                    animation: animationController,
                    builder: (_, __) => Container(
                      width: bikeSpecsWidth,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.blue.withOpacity(0.05 * (1 - animationController.value)),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget bikeSpecsFooterWidget() {
    return SafeArea(
      child: AnimatedBuilder(
        animation: animationController,
        builder: (_, __) {
          return Transform.translate(
            offset: Offset(screenWidth * (1 - animationController.value), 0),
            child: Opacity(
              opacity: animationController.value,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.05),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: SizedBox(
                      height: 200,
                      width: 250,
                      child: Image.asset(
                        'assets/images/bike_info.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
