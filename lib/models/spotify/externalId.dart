class ExternalId {
  final String isrcId;
  ExternalId(this.isrcId);
  ExternalId.fromJson(json) : isrcId = json['isrc'];
}
