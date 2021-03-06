import "dart:math" as math;

import "package:app/models/chapter.dart";
import "package:app/ui/routes.dart" as routes;
import "package:app/widgets/image_view.dart";
import "package:app/widgets/recents_provider.dart";
import "package:app/widgets/settings_icon_button.dart";
import "package:flutter/material.dart";

class RecentsPage extends StatelessWidget {
  const RecentsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        leading: null,
        title: const Text("Recently Read"),
        centerTitle: false,
        actions: const <Widget>[
          const SettingsIconButton(),
        ],
      ),
      body: new CustomScrollView(
        slivers: <Widget>[
          new SliverPadding(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
            ),
            sliver: new _RecentsList(),
          ),
        ],
      ),
    );
  }
}

class _RecentsList extends StatefulWidget {
  @override
  State createState() => new _RecentsListState();
}

class _RecentsListState extends State<_RecentsList> {
  final _providerKey = new GlobalKey<RecentsProviderState>();

  var _deactivated = false;

  var _recents = <Chapter>[];

  Widget _builder(BuildContext context, int index) {
    // Empty view
    if (_recents.isEmpty) {
      return const Padding(
        padding: const EdgeInsets.only(
          top: 16.0,
        ),
        child: const Center(
          child: const Text("Nothing to see here"),
        ),
      );
    }

    return new _RecentsListEntry(_recents[index]);
  }

  @override
  void deactivate() {
    _deactivated = true;
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    // Refresh recents upon reactivation
    if (_deactivated) {
      _providerKey.currentState?.refresh();
      _deactivated = false;
    }

    return new RecentsProvider(
      key: _providerKey,
      builder: (BuildContext context, AsyncSnapshot<List<Chapter>> snapshot) {
        _recents = snapshot.data ?? _recents;

        return new SliverList(
          delegate: new SliverChildBuilderDelegate(
            _builder,
            childCount: math.max(1, _recents.length),
          ),
        );
      },
    );
  }
}

class _RecentsListEntry extends StatelessWidget {
  const _RecentsListEntry(this.chapter);

  final Chapter chapter;

  void _open(BuildContext context) {
    Navigator.of(context).push(routes.reader(url: chapter.url));
  }

  @override
  Widget build(BuildContext context) {
    final novel = chapter.novel;

    return new ListTile(
      onTap: () => _open(context),
      leading: new ImageView(
        image: novel?.posterImage,
        fit: BoxFit.cover,
      ),
      title: new Text(novel?.name ?? "Unknown"),
      subtitle: new Padding(
        padding: const EdgeInsets.only(
          top: 4.0,
        ),
        child: new Text(chapter.title ?? ""),
      ),
    );
  }
}
