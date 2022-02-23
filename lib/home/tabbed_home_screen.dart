import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/components/first_page_exception_indicator.dart';
import 'package:gffft/components/search_input_sliver.dart';
import 'package:gffft/gfffts/gffft_api.dart';
import 'package:gffft/gfffts/gffft_home_screen.dart';
import 'package:gffft/gfffts/models/gffft_minimal.dart';
import 'package:gffft/users/user_api.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:velocity_x/velocity_x.dart';

import '../users/me_screen.dart';
import '../users/models/bookmark.dart';
import '../users/models/user.dart';

final getIt = GetIt.instance;

final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();

class TabbedHomeScreen extends StatefulWidget {
  const TabbedHomeScreen({Key? key}) : super(key: key);

  static const String webPath = '/';

  @override
  State<TabbedHomeScreen> createState() => _TabbedHomeScreenState();
}

class _TabbedHomeScreenState extends State<TabbedHomeScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  UserApi userApi = getIt<UserApi>();
  GffftApi gffftApi = getIt<GffftApi>();
  Future<User?>? user;

  static const _pageSize = 100;
  String? _searchTerm;
  int _selectedIndex = 0;
  List<BuildContext?> navStack = [null, null, null]; // one buildContext for each tab to store history  of navigation
  late List<Widget> mainTabs;

  final PagingController<String?, Bookmark> _bookmarkController = PagingController(firstPageKey: null);
  final PagingController<String?, GffftMinimal> _searchController = PagingController(firstPageKey: null);

  Future<void> _loadData() async {
    user = userApi.me().onError((error, stackTrace) async {
      await fbAuth.FirebaseAuth.instance.signOut();
      if (kDebugMode) {
        print("error getting me, token expired?");
      }
      return null;
    });
    setState(() {});
  }

  @override
  void initState() {
    _bookmarkController.addPageRequestListener((pageKey) {
      _fetchBookmarkPage(pageKey);
    });

    _searchController.addPageRequestListener((pageKey) {
      _fetchSearchPage(pageKey);
    });

    _bookmarkController.addStatusListener((status) {
      if (status == PagingStatus.subsequentPageError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Something went wrong while fetching a new page.',
            ),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () => _bookmarkController.retryLastFailedRequest(),
            ),
          ),
        );
      }
    });

    _searchController.addStatusListener((status) {
      if (status == PagingStatus.subsequentPageError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Something went wrong while fetching a new page.',
            ),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () => _searchController.retryLastFailedRequest(),
            ),
          ),
        );
      }
    });

    _tabController = TabController(length: 3, vsync: this);

    mainTabs = <Widget>[
      Navigator(onGenerateRoute: (RouteSettings settings) {
        return PageRouteBuilder(pageBuilder: (context, animiX, animiY) {
          // use page PageRouteBuilder instead of 'PageRouteBuilder' to avoid material route animation
          var l10n = AppLocalizations.of(context);
          final theme = Theme.of(context);

          navStack[0] = context;
          return _getSearchScreen(theme, l10n);
        });
      }),
      Navigator(onGenerateRoute: (RouteSettings settings) {
        return PageRouteBuilder(pageBuilder: (context, animiX, animiY) {
          // use page PageRouteBuilder instead of 'PageRouteBuilder' to avoid material route animation

          navStack[1] = context;
          return GffftHomeScreen(uid: "me", gid: "default");
        });
      }),
      Navigator(onGenerateRoute: (RouteSettings settings) {
        return PageRouteBuilder(pageBuilder: (context, animiX, animiY) {
          // use page PageRouteBuilder instead of 'PageRouteBuilder' to avoid material route animation

          navStack[1] = context;
          return MeScreen();
        });
      }),
    ];

    _loadData();

    super.initState();
  }

  Future<void> _fetchBookmarkPage(pageKey) async {
    try {
      final newItems = await userApi.getBookmarks(
        pageKey,
        _pageSize,
        _searchTerm,
      );

      final isLastPage = newItems.count < _pageSize;
      if (isLastPage) {
        _bookmarkController.appendLastPage(newItems.items);
      } else {
        _bookmarkController.appendPage(newItems.items, newItems.items.last.gid);
      }
    } catch (error) {
      _bookmarkController.error = error;
    }
  }

  Future<void> _fetchSearchPage(pageKey) async {
    try {
      final newItems = await gffftApi.getGfffts(
        pageKey,
        _pageSize,
        _searchTerm,
      );

      final isLastPage = newItems.count < _pageSize;
      if (isLastPage) {
        _searchController.appendLastPage(newItems.items);
      } else {
        _searchController.appendPage(newItems.items, newItems.items.last.gid);
      }
    } catch (error) {
      _searchController.error = error;
    }
  }

  void _updateSearchTerm(String searchTerm) {
    setState(() {
      _searchTerm = searchTerm;
    });
    _searchController.refresh();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Theme(
        data: ThemeData.dark().copyWith(
            appBarTheme: theme.appBarTheme,
            scaffoldBackgroundColor: theme.scaffoldBackgroundColor,
            textTheme: theme.textTheme),
        child: WillPopScope(
          onWillPop: () async {
            var whatContext = navStack[_tabController.index] ?? context;
            if (Navigator.of(whatContext).canPop()) {
              Navigator.of(whatContext).pop();
              setState(() {
                _selectedIndex = _tabController.index;
              });
              return false;
            } else {
              if (_tabController.index == 0) {
                setState(() {
                  _selectedIndex = _tabController.index;
                });
                SystemChannels.platform.invokeMethod('SystemNavigator.pop'); // close the app
                return true;
              } else {
                _tabController.index = 0; // back to first tap if current tab history stack is empty
                setState(() {
                  _selectedIndex = _tabController.index;
                });
                return false;
              }
            }
          },
          child: Scaffold(
            appBar: AppBar(
              flexibleSpace: SafeArea(
                  child: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(icon: Icon(Icons.home)),
                  Tab(icon: Icon(IconData(0x0047, fontFamily: 'Gffft'))),
                  Tab(icon: Icon(Icons.account_box)),
                ],
              )),
              automaticallyImplyLeading: false,
            ),
            body: TabBarView(
              controller: _tabController,
              children: mainTabs,
            ),
          ),
        ));
  }

  Widget _getFeaturedScreen(theme, l10n) {
    return Container(
        child: CustomScrollView(
      slivers: <Widget>[
        PagedSliverList<String?, Bookmark>(
          pagingController: _bookmarkController,
          builderDelegate: PagedChildBuilderDelegate<Bookmark>(
              animateTransitions: true,
              itemBuilder: (context, item, index) => ListTile(
                    title: Text(item.name),
                    subtitle: Text(item.name),
                    onTap: () {
                      if (item.gffft != null) {
                        VxNavigator.of(context).push(Uri(
                            path: "/" +
                                Uri(pathSegments: ["users", item.gffft!.uid, "gfffts", item.gffft!.gid]).toString()));
                      }
                    },
                    trailing: Icon(Icons.chevron_right, color: theme.primaryColor),
                  ),
              noItemsFoundIndicatorBuilder: (_) => NoFeaturedFound()),
        ),
      ],
    ));
  }

  Widget _getSearchScreen(theme, l10n) {
    return CustomScrollView(
      slivers: <Widget>[
        SearchInputSliver(onChanged: (searchTerm) => _updateSearchTerm(searchTerm), label: l10n.gffftListSearchHint),
        PagedSliverList<String?, GffftMinimal>(
          pagingController: _searchController,
          builderDelegate: PagedChildBuilderDelegate<GffftMinimal>(
              animateTransitions: true,
              itemBuilder: (context, item, index) => ListTile(
                  title: Text(item.name),
                  subtitle: Text(item.name),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return GffftHomeScreen(uid: item.uid, gid: item.gid);
                    }));
                  },
                  trailing: Icon(Icons.chevron_right, color: theme.primaryColor)),
              noItemsFoundIndicatorBuilder: (_) => SearchNotFound()),
        ),
      ],
    );
  }
}

class SearchNotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const FirstPageExceptionIndicator(
        title: 'No Items found',
        message: 'search above',
      );
}

class NoFeaturedFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const FirstPageExceptionIndicator(
        title: 'No featured gfffts found',
        message: 'Guess nothing is featured',
      );
}

class NoBookmarksFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const FirstPageExceptionIndicator(
        title: 'No bookmarks found',
        message: 'Gfffts that you bookmark will appear here',
      );
}
