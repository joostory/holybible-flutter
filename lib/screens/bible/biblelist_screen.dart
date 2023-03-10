import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:holybible/components/app_bar.dart';
import 'package:holybible/components/list/bible_list_widget.dart';
import 'package:holybible/models/bible.dart';
import 'package:holybible/models/version.dart';
import 'package:holybible/reducers/app_state.dart';
import 'package:holybible/repository/bible_repository.dart';
import 'package:redux/redux.dart';

class BibleListScreen extends StatelessWidget {
  static String routeName = '/';

  const BibleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (BuildContext context, _ViewModel vm) {
        return _BibleListWidget(
          version: vm.selectedVersion,
          fontSize: vm.fontSize,
          fontFamily: vm.fontFamily
        );
      },
    );
  }
}


class _ViewModel {
  final Version selectedVersion;
  final double fontSize;
  final String fontFamily;
  _ViewModel({
    required this.selectedVersion,
    required this.fontSize,
    required this.fontFamily
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      selectedVersion: store.state.versions.firstWhere(
        (version) => version.vcode == store.state.selectedVersionCode
      ),
      fontSize: store.state.fontSize,
      fontFamily: store.state.fontFamily
    );
  }
}

class _BibleListWidget extends StatefulWidget {
  final Version version;
  final double fontSize;
  final String fontFamily;

  const _BibleListWidget({
    required this.version,
    required this.fontSize,
    required this.fontFamily
  });

  @override
  State<StatefulWidget> createState() => _BibleListWidgetState();
}

class _BibleListWidgetState extends State<_BibleListWidget> {
  List<Bible> bibles = [];

  _BibleListWidgetState();

  @override
  initState() {
    super.initState();
    loadBibles();
  }

  @override
  didUpdateWidget(_BibleListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.version.vcode != oldWidget.version.vcode) {
      loadBibles();
    }
  }

  loadBibles() {
    BibleRepository()
      .findByVersion(widget.version.vcode)
      .then((loadedBibles) => setState(() => bibles = loadedBibles));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          BibleExpandedAppBar(widget.version.name),
          SliverFixedExtentList(
            itemExtent: 50.0,
            delegate: SliverChildBuilderDelegate(
              (context, index) => BibleListTileWidget(
                bible: bibles[index],
                fontSize: widget.fontSize,
                fontFamily: widget.fontFamily
              ),
              childCount: bibles.length
            )
          )
        ],
      ),
      // bottomNavigationBar: AppNavigationBar(0),
    );
  }
}

