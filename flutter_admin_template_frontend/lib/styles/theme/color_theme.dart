import "dart:ui";

class ColorTheme {
  ColorTheme();

  static List<BaseTheme> choices = [
    _Theme1(),
    _Theme2(),
    _Theme3(),
    _Theme4(),
    _Theme5(),
    _Theme6(),
    _Theme7()
  ];

  List<Color> baseColors = choices.map((e) => e.$0).toList();

  Color get0(int index) {
    return choices[index].$0;
  }

  Color get1(int index) {
    return choices[index].$1;
  }

  Color get2(int index) {
    return choices[index].$2;
  }

  Color get3(int index) {
    return choices[index].$3;
  }

  Color get4(int index) {
    return choices[index].$4;
  }
}

abstract class BaseTheme {
  Color get $0;
  Color get $1;
  Color get $2;
  Color get $3;
  Color get $4;
}

class _Theme1 extends BaseTheme {
  static const Color baseColor = Color.fromARGB(255, 0, 0, 0);
  static const Color baseColorLighter1 = Color.fromARGB(255, 51, 51, 51);
  static const Color baseColorLighter2 = Color.fromARGB(255, 102, 102, 102);
  static const Color baseColorLighter3 = Color.fromARGB(255, 153, 153, 153);
  static const Color baseColorLighter4 = Color.fromARGB(255, 187, 187, 187);

  @override
  Color get $0 => baseColor;

  @override
  Color get $1 => baseColorLighter1;

  @override
  Color get $2 => baseColorLighter2;

  @override
  Color get $3 => baseColorLighter3;

  @override
  Color get $4 => baseColorLighter4;
}

class _Theme2 extends BaseTheme {
  static const Color baseColor = Color.fromARGB(255, 217, 217, 217);
  static const Color baseColorLighter1 = Color.fromARGB(255, 222, 222, 222);
  static const Color baseColorLighter2 = Color.fromARGB(255, 239, 239, 237);
  static const Color baseColorLighter3 = Color.fromARGB(255, 248, 248, 248);
  static const Color baseColorLighter4 = Color.fromARGB(255, 255, 255, 255);

  @override
  Color get $0 => baseColor;

  @override
  Color get $1 => baseColorLighter1;

  @override
  Color get $2 => baseColorLighter2;

  @override
  Color get $3 => baseColorLighter3;

  @override
  Color get $4 => baseColorLighter4;
}

class _Theme3 extends BaseTheme {
  static const Color baseColor = Color.fromARGB(255, 45, 131, 218);
  static const Color baseColorLighter1 = Color.fromARGB(255, 64, 158, 254);
  static const Color baseColorLighter2 = Color.fromARGB(255, 122, 185, 250);
  static const Color baseColorLighter3 = Color.fromARGB(255, 179, 216, 255);
  static const Color baseColorLighter4 = Color.fromARGB(255, 235, 245, 255);

  @override
  Color get $0 => baseColor;

  @override
  Color get $1 => baseColorLighter1;

  @override
  Color get $2 => baseColorLighter2;

  @override
  Color get $3 => baseColorLighter3;

  @override
  Color get $4 => baseColorLighter4;
}

class _Theme4 extends BaseTheme {
  static const Color baseColor = Color.fromARGB(255, 211, 86, 85);
  static const Color baseColorLighter1 = Color.fromARGB(255, 245, 108, 109);
  static const Color baseColorLighter2 = Color.fromARGB(255, 244, 142, 142);
  static const Color baseColorLighter3 = Color.fromARGB(255, 253, 226, 226);
  static const Color baseColorLighter4 = Color.fromARGB(255, 254, 240, 240);

  @override
  Color get $0 => baseColor;

  @override
  Color get $1 => baseColorLighter1;

  @override
  Color get $2 => baseColorLighter2;

  @override
  Color get $3 => baseColorLighter3;

  @override
  Color get $4 => baseColorLighter4;
}

class _Theme5 extends BaseTheme {
  static const Color baseColor = Color.fromARGB(255, 208, 142, 41);
  static const Color baseColorLighter1 = Color.fromARGB(255, 230, 163, 60);
  static const Color baseColorLighter2 = Color.fromARGB(255, 242, 197, 126);
  static const Color baseColorLighter3 = Color.fromARGB(255, 245, 218, 177);
  static const Color baseColorLighter4 = Color.fromARGB(255, 253, 246, 237);

  @override
  Color get $0 => baseColor;

  @override
  Color get $1 => baseColorLighter1;

  @override
  Color get $2 => baseColorLighter2;

  @override
  Color get $3 => baseColorLighter3;

  @override
  Color get $4 => baseColorLighter4;
}

class _Theme6 extends BaseTheme {
  static const Color baseColor = Color.fromARGB(255, 76, 157, 34);
  static const Color baseColorLighter1 = Color.fromARGB(255, 103, 194, 59);
  static const Color baseColorLighter2 = Color.fromARGB(255, 146, 213, 113);
  static const Color baseColorLighter3 = Color.fromARGB(255, 195, 231, 176);
  static const Color baseColorLighter4 = Color.fromARGB(255, 240, 249, 234);

  @override
  Color get $0 => baseColor;

  @override
  Color get $1 => baseColorLighter1;

  @override
  Color get $2 => baseColorLighter2;

  @override
  Color get $3 => baseColorLighter3;

  @override
  Color get $4 => baseColorLighter4;
}

class _Theme7 extends BaseTheme {
  static const Color baseColor = Color.fromARGB(255, 115, 118, 122);
  static const Color baseColorLighter1 = Color.fromARGB(255, 177, 179, 184);
  static const Color baseColorLighter2 = Color.fromARGB(255, 200, 201, 204);
  static const Color baseColorLighter3 = Color.fromARGB(255, 222, 223, 224);
  static const Color baseColorLighter4 = Color.fromARGB(255, 233, 233, 235);

  @override
  Color get $0 => baseColor;

  @override
  Color get $1 => baseColorLighter1;

  @override
  Color get $2 => baseColorLighter2;

  @override
  Color get $3 => baseColorLighter3;

  @override
  Color get $4 => baseColorLighter4;
}
