class EventModel {
  EventModel(
      {this.communityName,
      this.communityId,
      this.participants,
      this.city,
      this.image,
      this.title,
      this.description,
      this.address,
      this.date,
      this.fee,
      this.id});

  final String? image;
  final String? title;
  final String? communityName;
  final String? communityId;
  final String? description;
  final String? address;
  final String? date;
  final String? fee;
  final String? id;
  final String? city;
  final List? participants;
}
