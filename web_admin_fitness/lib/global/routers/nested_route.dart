import 'package:auto_route/auto_route.dart';

class NestedRoute<T> extends CustomRoute<T> {
  const NestedRoute({
    bool initial = false,
    bool fullscreenDialog = false,
    bool maintainState = true,
    String? name,
    String? path,
    bool fullMatch = false,
    required Type page,
    List<Type>? guards,
    bool usesPathAsKey = false,
    List<AutoRoute>? children,
    Map<String, dynamic> meta = const {},
    bool? deferredLoading,
    Function? customRouteBuilder,
  }) : super(
          initial: initial,
          fullscreenDialog: fullscreenDialog,
          maintainState: maintainState,
          usesPathAsKey: usesPathAsKey,
          path: path,
          name: name,
          fullMatch: fullMatch,
          page: page,
          guards: guards,
          durationInMilliseconds: 200,
          reverseDurationInMilliseconds: 200,
          transitionsBuilder: TransitionsBuilders.slideLeft,
          children: children,
          meta: meta,
          deferredLoading: deferredLoading,
          customRouteBuilder: customRouteBuilder,
        );
}
