import 'package:flutter/material.dart';
import 'package:holybible/components/bible_search_list.dart';
import 'package:holybible/components/hymn_search_list.dart';
import 'package:holybible/components/search.dart';
import 'package:holybible/components/setting.dart';
import 'package:holybible/components/verse/bookmark_list.dart';

class BibleExpandedAppBar extends _ExpandedAppBar {
  BibleExpandedAppBar(String title)
    : super(title, [
        const SearchButton(),
        const BookmarkButton(),
        const SettingButton()
      ]);
}

class HymnExpandedAppBar extends _ExpandedAppBar {
  HymnExpandedAppBar(String title)
    : super(title, [
        const SearchHymnButton(),
        const SettingButton()
      ]);
}

class _ExpandedAppBar extends StatelessWidget {
  final String _title;
  final List<Widget> _actions;

  const _ExpandedAppBar(this._title, this._actions);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: false,
      pinned: true,
      snap: false,
      expandedHeight: 100.0,
      flexibleSpace: FlexibleSpaceBar(
          title: Text(_title),
          centerTitle: true
      ),
      actions: _actions,
    );
  }
}

class SearchHymnButton extends StatelessWidget {
  const SearchHymnButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.search),
      onPressed: () {
        showSearch(
          context: context,
          delegate: AppSearchDelegate(
            hint: "찬송가",
            searchResultWidgetCreator: (String query) => HymnSearchList(query),
          )
        );
      },
    );
  }
}

class BookmarkButton extends StatelessWidget {
  const BookmarkButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.bookmark_border),
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) {
            return SimpleDialog(
              title: const Text('즐겨찾기'),
              elevation: 4.0,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: VerseBookmarkList(context),
                )
              ],
            );
          }
        );
      },
    );
  }
}

class SearchButton extends StatelessWidget {
  const SearchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.search),
      onPressed: () {
        showSearch(
          context: context,
          delegate: AppSearchDelegate(
            hint: "성경",
            searchResultWidgetCreator: (String query) => BibleSearchList(query),
          )
        );
      },
    );
  }
}

class SettingButton extends StatelessWidget {
  const SettingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.tune),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return const SimpleDialog(
              title: Text('설정'),
              elevation: 4.0,
              children: [
                AppSettings()
              ],
            );
          }
        );
      },
    );
  }
}

