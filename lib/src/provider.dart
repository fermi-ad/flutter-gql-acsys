import 'package:flutter/material.dart';
import 'package:dart_gql_acsys/dart_gql_acsys.dart';
import 'package:flutter_controls_auth/flutter_controls_auth.dart';

/// A widget that provides access to the ACSys Service API. This doesn't
/// exist in the widget, nor does it do anything but provide access to the
/// API using the coolly named `ACSys.api()` method.

final class ACSys {
  /// Returns an object supporting the ACSys API.
  ///
  /// Any widget that uses this to retrieve the ACSys service object will
  /// get registered if the [ACSysProvider] gets rebuilt.

  static ACSysServiceAPI api(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_ACSysProviderIW>()!.service;
}

/// Provides the ACSys API to the application.
///
/// If an application wishes to use the ACSys API, it should place an instance
/// of this widget near the top of its tree so it doesn't get rebuilt. With
/// this in the tree, other widgets can use the API by calling [ACSys.api()]
/// to get an [ACSysServiceAPI] object which implements the API.
final class ACSysProvider extends StatelessWidget {
  final Widget child;
  final ACSysServiceAPI? service;
  final int? port;

  /// A factory function that creates a [ACSysProvider] widget.
  ///
  /// This function returns a function that can be added to the list passed to
  /// the `providers` parameter of the [StandardApp] widget.
  ///
  /// - [service] is an optional object which implements the [ACSysServiceAPI]
  ///   interface. If this option is omitted, the widget will use communicate
  ///   with the official GraphQL service.
  /// - [key] is an optional identifier for the widget.

  static ACSysProvider Function({required Widget child}) factory({
    ACSysServiceAPI? service,
    Key? key,
  }) =>
      ({required Widget child}) =>
          ACSysProvider._(service: service, key: key, child: child);

  /// A factory function that creates a [ACSysProvider] widget.
  ///
  /// This function returns a function that can be added to the list passed to
  /// the `providers` parameter of the [StandardApp] widget.
  ///
  /// - [port] is the port number to use to communite with the GraphQL service.
  /// - [key] is an optional identifier for the widget.

  static ACSysProvider Function({required Widget child}) factoryUsingPort({
    required int port,
    Key? key,
  }) =>
      ({required Widget child}) =>
          ACSysProvider._(port: port, key: key, child: child);

  // Creates the widget.
  //
  // - [child] is the widget subtree that gets added to the tree below this
  //   widget.
  // - [key] is an optional identifier for the widget.
  // - [port] is an optional port number to use. If omitted, the official,
  //   production service will be used. This parameter is only used if the
  //   [service] parameter is omitted.
  // - [service] is an optional obect which implements the [ACSysServiceAPI]
  //   interface. If this option is omitted, the widget will use an
  //   implementation that communicates over the network to the offcial
  //   control system API. This option is mainly to mock-up a service to
  //   use in unit tests.
  const ACSysProvider._({
    this.service,
    this.port,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) => _ACSysProviderIW(
    service: service ?? ACSysService(jwt: AuthService.getJwt(context)),
    child: child,
  );
}

// The inherited widget that provides the ACSys API to the application. This
// is a private class which holds a spot in the widget tree where the service
// object is stored. Inherited Widgets provide registration so that widgets
// can be rapidly rebuilt when the service object changes.

final class _ACSysProviderIW extends InheritedWidget {
  final ACSysServiceAPI service;

  const _ACSysProviderIW({required this.service, required super.child});

  @override
  bool updateShouldNotify(covariant _ACSysProviderIW oldWidget) =>
      service != oldWidget.service;
}
