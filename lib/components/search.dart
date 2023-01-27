import 'package:flutter/material.dart';

typedef SearchWidgetCreator = Widget Function(String query);
typedef SuggestWidgetCreator = Widget Function(String query);

class AppSearchDelegate extends SearchDelegate {

  final SearchWidgetCreator searchResultWidgetCreator;

  AppSearchDelegate({
    required this.searchResultWidgetCreator,
    String hint = ""
  }): super(
    searchFieldLabel: hint,
    searchFieldStyle: const TextStyle(
      color: Color(0xffdddddd)
    ),
    keyboardType: TextInputType.text
  );

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context);
  }

  @override
  List<Widget> buildActions(BuildContext context) => [
    IconButton(
      icon: const Icon(Icons.clear),
      onPressed: () {
        query = '';
      },
    ),
  ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () {
      close(context, null);
    },
  );

  @override
  Widget buildResults(BuildContext context) => searchResultWidgetCreator(query);

  @override
  Widget buildSuggestions(BuildContext context) => searchResultWidgetCreator(query);
}

