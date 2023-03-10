

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:holybible/models/verse.dart';
import 'package:holybible/reducers/app_state.dart';
import 'package:holybible/repository/verse_repository.dart';
import 'package:holybible/screens/bible/verselist_screen.dart';
import 'package:redux/redux.dart';


class VerseBookmarkList extends StatelessWidget {
  final BuildContext appContext;

  const VerseBookmarkList(this.appContext, {super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _VerseBookmarkListViewModel>(
      converter: _VerseBookmarkListViewModel.fromStore,
      builder: (BuildContext context, _VerseBookmarkListViewModel vm) {
        return _VerseBookmarkListWidget(
          appContext,
          vm.vcode,
          vm.fontSize
        );
      }
    );
  }
}

class _VerseBookmarkListViewModel {
  final String vcode;
  final double fontSize;
  _VerseBookmarkListViewModel(this.vcode, this.fontSize);

  static _VerseBookmarkListViewModel fromStore(Store<AppState> store) {
    return _VerseBookmarkListViewModel(
      store.state.selectedVersionCode,
      store.state.fontSize
    );
  }
}


class _VerseBookmarkListWidget extends StatefulWidget {
  final BuildContext appContext;
  final String vcode;
  final double fontSize;
  const _VerseBookmarkListWidget(this.appContext, this.vcode, this.fontSize);

  @override
  State<StatefulWidget> createState() => _VerseBookmarkListState();
}

class _VerseBookmarkListState extends State<_VerseBookmarkListWidget> {
  bool initialized = false;
  late List<SearchVerse> verses;

  @override
  void initState() {
    super.initState();
    _loadBookmarkVerses();
  }

  void _loadBookmarkVerses() {
    VerseRepository()
      .findByBookmark(widget.vcode)
      .then((loadedVerses) {
        setState(() {
          initialized = true;
          verses = loadedVerses;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    if (!initialized) {
      return Container(
        alignment: Alignment.topCenter,
        margin: const EdgeInsets.only(top: 50.0),
        child: const CircularProgressIndicator()
      );
    }

    if (verses.isEmpty) {
      return Container(
        alignment: Alignment.topCenter,
        margin: const EdgeInsets.only(top: 50.0),
        child: const Text("???????????? ????????? ????????????.")
      );
    }

    return ListView.builder(
      itemBuilder: (context, index) {
        var verse = verses[index];
        return ListTile(
          title: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 5.0
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${verse.bibleName} ${verse.cnum} : ${verse.vnum}',
                  style: TextStyle(
                    fontSize: widget.fontSize - 4.0,
                    fontWeight: FontWeight.bold
                  )
                ),
                Text(
                  verse.content,
                  style: TextStyle(
                    fontSize: widget.fontSize,
                  )
                )
              ],
            ),
          ),
          onTap: () {
            Navigator.pushNamed(
              widget.appContext,
              VerseListScreen.routeName,
              arguments: VerseListScreenArguments(
                bcode: verse.bcode,
                cnum: verse.cnum
              )
            );
          },
        );
      },
      itemCount: verses.length,
    );
  }
}

