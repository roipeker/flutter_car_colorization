/**
 * code by:
 * roipeker.com
 *
 * 09-07-2019
 *
 * Demo based on the chevrolet colorized car.
 * https://www.chevrolet.com/performance/corvette-stingray-sports-car
 *
 */

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

List colors = [
  {'name': 'ARCTIC WHITE', 'color': Color(0xfff0f6f3)},
  {'name': 'LONG BEACH RED TINTCOAT†', 'color': Color(0xff932028)},
  {'name': 'CERAMIC MATRIX GRAY METALLIC', 'color': Color(0xffe5f0f8)},
  {'name': 'SEBRING ORANGE TINTCOAT†', 'color': Color(0xffef722e)},
  {'name': 'BLADE SILVER METALLIC', 'color': Color(0xffd6dee6)},
  {'name': 'ELKHART LAKE BLUE METALLIC', 'color': Color(0xff235ebe)},
  {'name': 'SHADOW GRAY METALLIC', 'color': Color(0xff4d5963)},
  {'name': 'BLACK', 'color': Color(0xff030303)},
  {'name': 'CORVETTE RACING YELLOW TINTCOAT†', 'color': Color(0xfffbe74d)},
  {'name': 'TORCH RED', 'color': Color(0xffca2a1d)},
];

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.grey, fontFamily: 'Louis'),
        home: Home());
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CarSlideshow(),
      ),
    );
  }
}

class CarSlideshow extends StatefulWidget {
  @override
  _CarSlideshowState createState() => _CarSlideshowState();
}

class _CarSlideshowState extends State<CarSlideshow> {
  int _selectedIdx = 0;
  get selected => colors[_selectedIdx];

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            "AS SHOWN: \$60,355†",
            style: TextStyle(
                fontSize: 14,
                color: Color(0xff808080),
                letterSpacing: 1,
                fontWeight: FontWeight.w100),
          ),
          _getCarImage(),
          SizedBox(height: 24),
          Text(selected['name'],
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  letterSpacing: .8,
                  color: Color(0xff262626))),
          SizedBox(height: 30),
          _colorMenu(),
        ],
      ),
    ));
  }

  _getCarImage() {
    return Stack(
      children: <Widget>[
        AnimatedColoredCar(color: selected['color']),
        // used the animated one instead.
        /*Image.asset(
          'assets/car_back.webp',
          color: selected['color'] as Color,
          colorBlendMode: BlendMode.overlay,
        ),*/
        Image.asset('assets/car_front.webp'),
      ],
    );
  }

  _colorMenu() {
    var buttons = List.generate(colors.length, (idx) {
      return ColoredDotButton(
        onTap: onItemTap,
        idx: idx,
        active: _selectedIdx == idx,
        color: colors[idx]['color'] as Color,
      );
    });
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 15,
      runSpacing: 10,
      children: buttons,
    );
  }

  onItemTap(int idx) {
    _selectedIdx = idx;
    setState(() {});
  }
}

class AnimatedColoredCar extends StatefulWidget {
  final Color color;

  const AnimatedColoredCar({Key key, this.color}) : super(key: key);

  @override
  _AnimatedColoredCarState createState() => _AnimatedColoredCarState();
}

class _AnimatedColoredCarState extends State<AnimatedColoredCar>
    with SingleTickerProviderStateMixin {
  AnimationController _controller; // new
  Animation<Color> animation;

  @override
  initState() {
    super.initState();
    print('init state!');
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    _controller.stop();
    animation =
        ColorTween(begin: animation?.value ?? Colors.white, end: widget.color)
            .animate(_controller);
    _controller.forward(from: 0);
    return AnimatedColorCarWidget(
      animation: animation,
    );
  }
}

class AnimatedColorCarWidget extends AnimatedWidget {
  AnimatedColorCarWidget({Key key, Animation<Color> animation})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<Color> animation = listenable;
    return Image.asset(
      'assets/car_back.webp',
      color: animation.value,
      colorBlendMode: BlendMode.overlay,
    );
  }
}

class ColoredDotButton extends StatelessWidget {
  final bool active;
  final Color color;
  final int idx;
  final Function onTap;

  const ColoredDotButton(
      {Key key, this.idx, this.onTap, this.active = false, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (_) => onTap(idx),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 600),
            curve: Curves.fastLinearToSlowEaseIn,
            width: active ? 40 : 30,
            height: active ? 40 : 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Color(0xffb3b3b3).withOpacity(active ? 1 : 0),
                width: active ? 2 : 0,
              ),
            ),
          ),
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  color,
                  Color.alphaBlend(
                    Colors.black.withOpacity(.12),
                    color,
                  ),
                ],
                stops: [0.35, 1],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              backgroundBlendMode: BlendMode.darken,
            ),
          ),
          SizedBox(
            width: 40,
            height: 40,
          ),

          /*AnimatedOpacity(
            duration: Duration(milliseconds: 400),
            curve: Curves.fastLinearToSlowEaseIn,
            opacity: active ? 1 : 0,
            child: Container(
              width: 80 / 2,
              height: 80 / 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Color(0xffb3b3b3), width: 2),
              ),
            ),
          ),*/
        ],
      ),
    );
  }
}
