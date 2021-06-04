import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'shared/data.dart';
import 'shared/login.dart';
import 'shared/pages.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  // add the login info into the tree as app state that can change over time
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<LoginInfo>(
        create: (context) => LoginInfo(),
        child: MaterialApp.router(
          routeInformationParser: _router.routeInformationParser,
          routerDelegate: _router.routerDelegate,
          title: 'Conditional Routes GoRouter Example',
        ),
      );

  late final _router = GoRouter.routes(builder: _builder, error: _error);

  // the routes when the user is logged in
  final _loggedInRoutes = [
    GoRoute(
      pattern: '/',
      builder: (context, args) => MaterialPage<FamiliesPage>(
        key: const ValueKey('FamiliesPage'),
        child: FamiliesPage(families: Families.data),
      ),
    ),
    GoRoute(
      pattern: '/family/:fid',
      builder: (context, args) {
        final family = Families.family(args['fid']!);

        return MaterialPage<FamilyPage>(
          key: ValueKey(family),
          child: FamilyPage(family: family),
        );
      },
    ),
    GoRoute(
      pattern: '/family/:fid/person/:pid',
      builder: (context, args) {
        final family = Families.family(args['fid']!);
        final person = family.person(args['pid']!);

        return MaterialPage<PersonPage>(
          key: ValueKey(person),
          child: PersonPage(family: family, person: person),
        );
      },
    ),
  ];

  // the routes when the user is not logged in
  final _loggedOutRoutes = [
    GoRoute(
      pattern: '/',
      builder: (context, args) => const MaterialPage<LoginPage>(
        key: ValueKey('LoginPage'),
        child: LoginPage(),
      ),
    ),
  ];

  // changes in the login info will rebuild the stack of routes
  List<GoRoute> _builder(BuildContext context, String location) =>
      context.watch<LoginInfo>().loggedIn ? _loggedInRoutes : _loggedOutRoutes;

  Page<dynamic> _error(BuildContext context, String location, Exception ex) => MaterialPage<Four04Page>(
        key: const ValueKey('ErrorPage'),
        child: Four04Page(message: ex.toString()),
      );
}