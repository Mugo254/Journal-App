class Event {
  final dynamic title;
  final dynamic description;
  final dynamic image;
  final String date;
  final String documentId;

  const Event(
      this.title, this.description, this.image, this.documentId, this.date);

// The toString method in Dart returns a string representation of the object. It's automatically called when you try to convert an object to a string
  @override
  String toString() =>
      'Title: $title, Description: $description, Image: $image';
}
