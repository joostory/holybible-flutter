
class Hymn {
  String version;
  String type;
  int number;
  String title;

  Hymn({
    required this.version,
    required this.type,
    required this.number,
    required this.title
  });

  static Hymn fromMap(Map<String, dynamic> item) {
    return Hymn(
        version: item['version'],
        type: item['type'],
        number: item['number'],
        title: item['title'],
    );
  }

  static List<Hymn> fromMapList(List<Map<String, dynamic>> items)
    => items.map((item) => Hymn.fromMap(item)).toList();
}
