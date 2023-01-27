
class Version {
  String vcode;
  String name;

  Version({
    required this.vcode,
    required this.name
  });

  static fromMap(Map<String, dynamic> item) {
    return Version(
      vcode: item['vcode'].toString(),
      name: item['name'].toString()
    );
  }
}