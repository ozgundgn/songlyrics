class SpotifyToken {
  final String accessToken;
  final String tokenType;
  DateTime expireDate;

  SpotifyToken(this.accessToken, this.tokenType, this.expireDate);
}
