
class Verse {
  String vcode;
  int bcode;
  int cnum;
  int vnum;
  String content;
  bool bookmarked;

  Verse({
    required this.vcode,
    required this.bcode,
    required this.cnum,
    required this.vnum,
    required this.content,
    required this.bookmarked
  });

  static Verse fromMap(Map<String, dynamic> item) => Verse(
    vcode: item['vcode'],
    bcode: item['bcode'],
    cnum: item['cnum'],
    vnum: item['vnum'],
    content: item['content'],
    bookmarked: item['bookmarked'] == 1
  );

  static Verse from(Verse verse) => Verse(
    vcode: verse.vcode,
    bcode: verse.bcode,
    cnum: verse.cnum,
    vnum: verse.vnum,
    content: verse.content,
    bookmarked: verse.bookmarked
  );
}

class SearchVerse extends Verse {
  String bibleName;

  SearchVerse({
    vcode,
    bcode,
    cnum,
    vnum,
    content,
    bookmarked,
    required this.bibleName
  }): super(
        vcode: vcode,
        bcode: bcode,
        cnum: cnum,
        vnum: vnum,
        content: content,
        bookmarked: bookmarked
      );


  static SearchVerse fromMap(Map<String, dynamic> item) {
    return SearchVerse(
      vcode: item['vcode'],
      bcode: item['bcode'],
      cnum: item['cnum'],
      vnum: item['vnum'],
      content: item['content'],
      bookmarked: item['bookmarked'] == 1,
      bibleName: item['bibleName']
    );
  }
}