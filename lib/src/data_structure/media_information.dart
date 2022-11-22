class MediaInformation {
  String displayUrl;
  int height;
  int width;

  MediaInformation({
    required this.displayUrl,
    required this.height,
    required this.width
  });

  factory MediaInformation.fromJson({required Map<String, dynamic> json, required String type}){
    switch (type) {
      case 'image':
        return ImageMediaInformation.fromJson(json: json);
      case 'video':
        return VideoMediaInformation.fromJson(json: json);
      default:
        return MediaInformation(displayUrl: '', height: 0, width: 0);
    }
  }
}

class ImageMediaInformation extends MediaInformation{
  ImageMediaInformation({
    required super.displayUrl,
    required super.height,
    required super.width
  });

  factory ImageMediaInformation.fromJson({required Map<String, dynamic> json}){
    return ImageMediaInformation(
      displayUrl: json['display_url'],
      height: json['height'],
      width: json['width']
    );
  }
}

class VideoMediaInformation extends MediaInformation{
  int duration;
  int frameCount;
  int frameStride;

  VideoMediaInformation({
    required super.displayUrl,
    required super.height,
    required super.width,
    required this.duration,
    required this.frameCount,
    required this.frameStride
  });

  factory VideoMediaInformation.fromJson({required Map<String, dynamic> json}){
    return VideoMediaInformation(
      displayUrl: json['display_url'],
      height: json['height'],
      width: json['width'],
      duration: json['duration'],
      frameCount: json['frame_count'],
      frameStride: json['frame_stride']
    );
  }
}