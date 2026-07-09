# flutter_gql_acsys

A Flutter package that provides access to the
[ACSys](https://github.com/fermi-ad/dart-gql-acsys) GraphQL API via an
inherited widget. Drop `ACSysProvider` near the top of your widget tree and
any descendant can retrieve a live `ACSysServiceAPI` instance with a single
call — no prop-drilling required.

## Features

- **`ACSysProvider`** — a `StatefulWidget` that owns the service connection
  and exposes it to the subtree via Flutter's inherited-widget mechanism.
- **`ACSys.api(context)`** — a static helper that retrieves the
  `ACSysServiceAPI` from the nearest `ACSysProvider` ancestor and registers
  the calling widget for rebuilds when the service changes.
- **`ACSysProvider.factory()`** — a convenience factory that produces a
  provider builder compatible with the `providers` parameter of
  `flutter_controls_core`'s `StandardApp` widget.
- Re-exports the full `dart_gql_acsys` public API so you only need one
  import in your application code.

## Installation

Add the package to your `pubspec.yaml` using its Git source:

```yaml
dependencies:
  flutter_gql_acsys:
    git:
      url: https://github.com/fermi-ad/flutter-gql-acsys.git
      ref: main
```

Then fetch the dependency:

```sh
flutter pub get
```

## Usage

### With `StandardApp` (recommended)

The cleanest integration is through the `providers` parameter of
`StandardApp` from the `flutter_controls_core` package. Pass
`ACSysProvider.factory()` to the list and the provider will be wired into
the widget tree automatically, sitting above your entire application.

```dart
import 'package:flutter_controls_core/flutter_controls_core.dart';
import 'package:flutter_gql_acsys/flutter_gql_acsys.dart';

void main() {
  runApp(
    StandardApp(
      providers: [
        ACSysProvider.factory(),
      ],
      home: const MyHomePage(),
    ),
  );
}
```

### Accessing the API in a widget

Once `ACSysProvider` is in the tree, call `ACSys.api(context)` from any
descendant widget to obtain the `ACSysServiceAPI` object:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_gql_acsys/flutter_gql_acsys.dart';

class DeviceReadout extends StatelessWidget {
  const DeviceReadout({super.key});

  @override
  Widget build(BuildContext context) {
    final api = ACSys.api(context);

    return StreamBuilder<Reading>(
      stream: api.monitorDevices(['M:OUTTMP']),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        return Text('${snapshot.data!.value}');
      },
    );
  }
}
```

### Injecting a mock service (unit tests)

Pass a custom `ACSysServiceAPI` implementation to `ACSysProvider.factory()`
to swap out the real network service in tests:

```dart
ACSysProvider.factory(service: MyMockACSysService()),
```

## Additional information

- **Source:** <https://github.com/fermi-ad/flutter-gql-acsys>
- **ACSys Dart client:** <https://github.com/fermi-ad/dart-gql-acsys>
- **Controls Core (StandardApp):** <https://github.com/fermi-ad/flutter-controls-core>
- Bug reports and pull requests are welcome via the GitHub issue tracker.
