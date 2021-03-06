import "package:app/settings/settings.dart";
import "package:app/ui/routes.dart" as routes;
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class App extends StatefulWidget {
  const App();

  @override
  State createState() => new _AppState();
}

class _AppState extends State<App> {
  SettingsState _settings;

  void _invalidate() {
    setState(() {});
  }

  Route _router(RouteSettings route) {
    return route.name == "/" ? routes.home() : null;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _settings = Settings.of(context);
    _settings.primarySwatchChanges.addListener(_invalidate);
    _settings.accentColorChanges.addListener(_invalidate);
    _settings.brightnessChanges.addListener(_invalidate);
    _settings.amoledChanges.addListener(_invalidate);
  }

  @override
  void deactivate() {
    _settings.primarySwatchChanges.removeListener(_invalidate);
    _settings.accentColorChanges.removeListener(_invalidate);
    _settings.brightnessChanges.removeListener(_invalidate);
    _settings.amoledChanges.removeListener(_invalidate);
    _settings = null;
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final platform = defaultTargetPlatform;
    final iOS = TargetPlatform.iOS;
    final amoled = _settings.brightness == Brightness.dark && _settings.amoled;

    return new MaterialApp(
      title: "Microcosm",
      theme: new ThemeData(
        primarySwatch: _settings.primarySwatch,
        accentColor: _settings.accentColor,
        brightness: _settings.brightness,
        canvasColor: amoled ? Colors.black : null,
        fontFamily: platform != iOS ? "Open Sans" : null,
      ),
      onGenerateRoute: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
