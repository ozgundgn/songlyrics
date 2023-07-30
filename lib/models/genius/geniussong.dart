class GeniusSong {
  final SongDetail result;
  final String type;
  final String index;

  GeniusSong(this.result, this.type, this.index);

  GeniusSong.fromJson(json)
      : result = SongDetail.fromJson(json['result']),
        type = json['type'],
        index = json['index'];

  Map<String, dynamic> toJson() =>
      {'result': result.toJson(), 'type': type, 'index': index};
}

class SongDetail {
  final String artistName;
  final String headerImage;
  final int id;
  final String language;
  final String title;
  final String songUrl;

  SongDetail(this.artistName, this.headerImage, this.id, this.language,
      this.title, this.songUrl);

  SongDetail.fromJson(json)
      : artistName = json['artist_names'],
        headerImage = json['header_image_url'],
        id = json['id'],
        language = json['en'],
        title = json['title'],
        songUrl = json['url'];

  Map<String, dynamic> toJson() => {
        'artist_names': artistName,
        'header_image_url': headerImage,
        'id': id,
        'language': language,
        'title': title
      };
}

class LyricsInfoModel {
  String? singer;
  String? song;
  String? lyrics;
  String? url;
  LyricsInfoModel(this.singer, this.song, this.lyrics, this.url);
}
