import 'dart:math';

class AnnotationShape {
  String type;

  AnnotationShape({required this.type});

  factory AnnotationShape.fromJson({required Map<String, dynamic> json}) {
    switch (json['type']) {
      case 'RECTANGLE':
        return RectangleAnnotationShape.fromJson(json: json);
      case 'ROTATED_RECTANGLE':
        return RotatedRectangleAnnotationShape.fromJson(json: json);
      case 'ELLIPSE':
        return EllipseAnnotationShape.fromJson(json: json);
      case 'POLYGON':
        return PolygonAnnotationShape.fromJson(json: json);
      default:
        return AnnotationShape(type: 'UNKNOWN');
    }
  }

  factory AnnotationShape.copyFrom({required AnnotationShape original}) {
    switch (original.type) {
      case 'RECTANGLE':
        return RectangleAnnotationShape.copyFrom(original: original as RectangleAnnotationShape);
      case 'ROTATED_RECTANGLE':
        return RotatedRectangleAnnotationShape.copyFrom(original: original as RotatedRectangleAnnotationShape);
      case 'ELLIPSE':
        return EllipseAnnotationShape.copyFrom(original: original as EllipseAnnotationShape);
      case 'POLYGON':
        return PolygonAnnotationShape.copyFrom(original: original as PolygonAnnotationShape);
      default:
        return AnnotationShape(type: original.type);
    }
  }

  factory AnnotationShape.dummy({required String type}) {
    switch (type) {
      case 'RECTANGLE':
        return RectangleAnnotationShape.dummy();
      case 'ROTATED_RECTANGLE':
        return RotatedRectangleAnnotationShape.dummy();
      case 'ELLIPSE':
        return EllipseAnnotationShape.dummy();
      case 'POLYGON':
        return PolygonAnnotationShape.dummy();
      default:
        return AnnotationShape(type: 'UNKNOWN');
    }
  }

  bool isDummy() {
    switch (type) {
      case 'RECTANGLE':
        return (this as RectangleAnnotationShape).isDummy();
      case 'ROTATED_RECTANGLE':
        return (this as RotatedRectangleAnnotationShape).isDummy();
      case 'ELLIPSE':
        return (this as EllipseAnnotationShape).isDummy();
      case 'POLYGON':
        return (this as PolygonAnnotationShape).isDummy();
      default:
        return true;
    }
  }

  Map<String, dynamic> toJson() {
    switch (type) {
      case 'RECTANGLE':
        return (this as RectangleAnnotationShape).toJson();
      case 'ROTATED_RECTANGLE':
        return (this as RotatedRectangleAnnotationShape).toJson();
      case 'ELLIPSE':
        return (this as EllipseAnnotationShape).toJson();
      case 'POLYGON':
        return (this as PolygonAnnotationShape).toJson();
      default:
        return {};
    }
  }
}

class RectangleAnnotationShape extends AnnotationShape {
  num height;
  num width;
  num x;
  num y;

  RectangleAnnotationShape({
    required super.type,
    required this.height,
    required this.width,
    required this.x,
    required this.y
  });

  factory RectangleAnnotationShape.fromJson({required Map<String, dynamic> json}) {
    return RectangleAnnotationShape(
      type: json['type'],
      height: json['height'],
      width: json['width'],
      x: json['x'],
      y: json['y']
    );
  }

  factory RectangleAnnotationShape.copyFrom({required RectangleAnnotationShape original}) {
    return RectangleAnnotationShape(
      type: original.type,
      height: original.height,
      width: original.width,
      x: original.x,
      y: original.y
    );
  }

  factory RectangleAnnotationShape.dummy() {
    return RectangleAnnotationShape(
      type: 'RECTANGLE',
      height: 0.0,
      width: 0.0,
      x: 0.0,
      y: 0.0
    );
  }

  @override
  bool isDummy() => height == 0.0 && width == 0.0 && x == 0.0 && y == 0.0;

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'x': x,
      'y': y,
      'width': width,
      'height': height
    };
  }

  void setDimension({required num x1, required num x2, required num y1, required num y2}) {
    x = min(x1, x2);
    y = min(y1, y2);
    width = (x1 - x2).abs();
    height = (y1 - y2).abs();
  }

  bool isValid({required num imageWidth, required num imageHeight}) {
    return (0.0 <= x && x <= imageWidth) && (0.0 <= y && y <= imageHeight) && (0.0 < width && x + width <= imageWidth) && (0.0 < height && y + height <= imageHeight);
  }
}

class RotatedRectangleAnnotationShape extends RectangleAnnotationShape {
  num angle;

  RotatedRectangleAnnotationShape({required super.type, required super.height, required super.width, required super.x, required super.y, required this.angle});

  factory RotatedRectangleAnnotationShape.fromJson({required Map<String, dynamic> json}) {
    return RotatedRectangleAnnotationShape(
      type: json['type'],
      height: json['height'],
      width: json['width'],
      x: json['x'],
      y: json['y'],
      angle: json['angle']
    );
  }

  factory RotatedRectangleAnnotationShape.copyFrom({required RotatedRectangleAnnotationShape original}) {
    return RotatedRectangleAnnotationShape(
      type: original.type,
      height: original.height,
      width: original.width,
      x: original.x,
      y: original.y,
      angle: original.angle
    );
  }

  factory RotatedRectangleAnnotationShape.dummy() {
    return RotatedRectangleAnnotationShape(
      type: 'ROTATED_RECTANGLE',
      angle: 0.0,
      height: 0.0,
      width: 0.0,
      x: 0.0,
      y: 0.0
    );
  }

  @override
  bool isDummy() => height == 0.0 && width == 0.0 && x == 0.0 && y == 0.0;

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'angle': angle,
      'x': x,
      'y': y,
      'width': width,
      'height': height
    };
  }
}

class EllipseAnnotationShape extends AnnotationShape {
  num height;
  num width;
  num x;
  num y;

  EllipseAnnotationShape({
    required super.type,
    required this.height,
    required this.width,
    required this.x,
    required this.y
  });

  factory EllipseAnnotationShape.fromJson({required Map<String, dynamic> json}) {
    return EllipseAnnotationShape(
      type: json['type'],
      height: json['height'],
      width: json['width'],
      x: json['x'],
      y: json['y']
    );
  }

  factory EllipseAnnotationShape.copyFrom({required EllipseAnnotationShape original}) {
    return EllipseAnnotationShape(
      type: original.type,
      height: original.height,
      width: original.width,
      x: original.x,
      y: original.y
    );
  }

  factory EllipseAnnotationShape.dummy() {
    return EllipseAnnotationShape(
      type: 'ELLIPSE',
      height: 0.0,
      width: 0.0,
      x: 0.0,
      y: 0.0
    );
  }

  @override
  bool isDummy() => height == 0.0 && width == 0.0 && x == 0.0 && y == 0.0;

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'x': x,
      'y': y,
      'width': width,
      'height': height
    };
  }
}

class PolygonAnnotationShape extends AnnotationShape {
  List<Point> points;

  PolygonAnnotationShape({required super.type, required this.points});

  factory PolygonAnnotationShape.fromJson({required Map<String, dynamic> json}) {
    List<Point> result = <Point>[];
    for (Map<String, dynamic> item in json['points']){
      result.add(Point(item['x'], item['y']));
    }
    return PolygonAnnotationShape(
      type: json['type'],
      points: result
    );
  }

  factory PolygonAnnotationShape.copyFrom({required PolygonAnnotationShape original}) {
    return PolygonAnnotationShape(
      type: original.type,
      points: original.points.map((Point p) => Point(p.x, p.y)).toList()
    );
  }

  factory PolygonAnnotationShape.dummy() {
    return PolygonAnnotationShape(
      type: 'POLYGON',
      points: []
    );
  }

  @override
  bool isDummy() => points.isEmpty;

  @override
  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> result = [];
    for (Point p in points){
      result.add({
        'x': p.x,
        'y': p.y
      });
    }
    return {
      'type': type,
      'points': result
    };
  }
}