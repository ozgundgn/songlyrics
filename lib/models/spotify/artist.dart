class Artist {
  final String name;
  Artist(this.name);
  Artist.fromJson(json) : name = json['name'];
}
