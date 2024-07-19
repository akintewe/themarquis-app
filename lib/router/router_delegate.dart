import 'dart:async';

import 'package:marquis_v2/models/app_state.dart';
import 'package:marquis_v2/models/user.dart';
import 'package:marquis_v2/providers/user.dart';
import 'package:marquis_v2/router/app_shell.dart';
import 'package:marquis_v2/providers/app_state.dart';
import 'package:marquis_v2/router/fade_animation.dart';
import 'package:marquis_v2/router/route_path.dart';
import 'package:marquis_v2/screens/achievements_screen.dart';
import 'package:marquis_v2/screens/auth_screen.dart';
import 'package:marquis_v2/screens/game_screen.dart';
import 'package:marquis_v2/screens/home_screen.dart';
import 'package:marquis_v2/screens/page_not_found_screen.dart';
import 'package:marquis_v2/screens/profile_screen.dart';
import 'package:marquis_v2/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final routerDelegateProvider =
    Provider<AppRouterDelegate>((ref) => AppRouterDelegate(ref));

final innerRouterDelegateProvider =
    Provider<InnerRouterDelegate>((ref) => InnerRouterDelegate(ref));

class AppRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  bool? _showPageNotFound;
  bool _isSignUp = false;
  final ProviderRef ref;
  late AppStateData _appState;
  late UserData? _user;

  AppRouterDelegate(this.ref) : navigatorKey = GlobalKey<NavigatorState>() {
    _appState = ref.read(appStateProvider);
    _user = ref.read(userProvider);
    ref.listen(appStateProvider, (previous, next) {
      _appState = next;
      notifyListeners();
    });
    ref.listen(userProvider, (previous, next) {
      _user = next;
      notifyListeners();
    });
  }

  @override
  AppRoutePath? get currentConfiguration {
    if (_showPageNotFound == true) {
      return PageNotFoundPath();
    }
    if (_appState.isAuth) {
      if (_appState.selectedGame != null) {
        return GamePath(_appState.selectedGame!);
      }
      switch (_appState.navigatorIndex) {
        case 0:
          return HomePath();
        case 1:
          return AchievementsPath();
        case 2:
          return ProfilePath();
        default:
          break;
      }
    } else {
      // if (_isSignUp) {
      //   return SignUpPath();
      // }
      return AuthPath();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    List<Page> stack;
    if (_showPageNotFound == true) {
      stack = [
        const FadeAnimationPage(
          key: ValueKey('PageNotFoundPage'),
          child: PageNotFoundScreen(),
        )
      ];
    } else if (_appState.isAuth) {
      if (_appState.autoLoginResult == null || _user == null) {
        stack = [
          const FadeAnimationPage(
            key: ValueKey('SplashPage'),
            child: SplashScreen(
                // goToCreateBusiness: () {
                //   _isSignUp = true;
                //   notifyListeners();
                // },
                ),
          ),
          // if (_isSignUp)
          //   const FadeAnimationPage(
          //     child: CreateBusinessScreen(),
          //     key: ValueKey('CreateBusinessPage'),
          //   ),
        ];
      } else {
        stack = [
          const FadeAnimationPage(
            child: AppShell(),
            key: ValueKey('AppShell'),
          ),
        ];
      }
    } else {
      stack = [
        const FadeAnimationPage(
          key: ValueKey('LoginPage'),
          child: AuthScreen(),
        ),
        // if (_isSignUp)
        //   FadeAnimationPage(
        //     key: const ValueKey('SignUpPage'),
        //     child: MainSignUpScreen(
        //       email: _email,
        //       token: _idToken,
        //       signUpMode: _signUpMode,
        //     ),
        //   ),
      ];
    }

    return Navigator(
      key: navigatorKey,
      pages: stack,
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;
        if (_isSignUp) {
          _isSignUp = false;
        }
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) async {
    if (configuration is PageNotFoundPath) {
      _showPageNotFound = true;
      return;
    } else {
      _showPageNotFound = false;
    }

    if (configuration is HomePath) {
      ref.read(appStateProvider.notifier).changeNavigatorIndex(0);
    }

    if (configuration is AchievementsPath) {
      ref.read(appStateProvider.notifier).changeNavigatorIndex(1);
    }

    if (configuration is ProfilePath) {
      ref.read(appStateProvider.notifier).changeNavigatorIndex(2);
    }

    if (configuration is GamePath) {
      ref.read(appStateProvider.notifier).selectGame(configuration.id);
    }
  }
}

class InnerRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final ProviderRef ref;
  late AppStateData _appState;

  InnerRouterDelegate(this.ref) {
    _appState = ref.read(appStateProvider);
    ref.listen(appStateProvider, (previous, next) {
      _appState = next;
      notifyListeners();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        ...switch (_appState.navigatorIndex) {
          0 => [
              const FadeAnimationPage(
                key: ValueKey('HomePage'),
                child: HomeScreen(),
              ),
            ],
          1 => [
              const FadeAnimationPage(
                key: ValueKey('AchievementsPage'),
                child: AchievementsScreen(),
              ),
            ],
          2 => [
              const FadeAnimationPage(
                key: ValueKey('ProfilePage'),
                child: ProfileScreen(),
              ),
            ],
          _ => [],
        },
        if (_appState.selectedGame != null)
          FadeAnimationPage(
            key: ValueKey('Game${_appState.selectedGame}Page'),
            child: GameScreen(
              id: _appState.selectedGame!,
            ),
          ),
      ],
      onPopPage: (route, result) {
        if (_appState.selectedGame != null) {
          ref.read(appStateProvider.notifier).selectGame(null);
        }
        return route.didPop(result);
      },
    );
  }

  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) async {
    // This is not required for inner router delegate because it does not
    // parse route
    assert(false);
  }
}
