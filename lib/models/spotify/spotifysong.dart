class SpotifySong {
  final String songName;
  final String artistName;
  final String url;

  SpotifySong(this.songName, this.artistName, this.url);

  SpotifySong.fromJson(json)
      : songName = json['name'],
        artistName = json['artists'][0]['name'],
        url = json["external_urls"]["spotify"];
}
