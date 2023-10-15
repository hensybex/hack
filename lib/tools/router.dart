import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hack/screens/map_screen.dart';
import 'package:hack/screens/not_found.dart';
import 'package:hack/screens/office_screen.dart';
import 'package:hack/screens/pin_list.dart';
import 'package:hack/screens/route_screen.dart';
import 'package:hack/screens/talons_screen.dart';

final routes = [
  GoRoute(path: '/', builder: (context, state) => const MapScreen()),
  GoRoute(
      path: '/pin_list', builder: (context, state) => const PinListScreen()),
  GoRoute(
    path: '/office/:office_id',
    builder: (context, state) {
      final officeId = int.parse(state.pathParameters['office_id']!);
      return OfficeScreen(officeId: officeId);
    },
  ),
  GoRoute(
    path: '/talons/:office_id',
    builder: (context, state) {
      final officeId = int.parse(state.pathParameters['office_id']!);
      return TalonsScreen(officeId: officeId.toString());
    },
  ),
  GoRoute(
    path: '/route/:office_id',
    builder: (context, state) {
      final officeId = int.parse(state.pathParameters['office_id']!);
      return RouteScreen(officeId: officeId);
    },
  ),
  GoRoute(
    path: '/404',
    pageBuilder: (context, state) {
      return MaterialPage(child: NotFoundScreen());
    },
  ),
];

final goRouter = GoRouter(
  routes: routes,
  initialLocation: '/',
);
