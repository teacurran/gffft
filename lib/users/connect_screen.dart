import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/components/first_page_exception_indicator.dart';
import 'package:gffft/components/search_input_sliver.dart';
import 'package:gffft/gfffts/gffft_api.dart';
import 'package:gffft/gfffts/models/gffft_minimal.dart';
import 'package:gffft/style/app_theme.dart';
import 'package:gffft/users/user_api.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:velocity_x/velocity_x.dart';

import 'models/bookmark.dart';

final getIt = GetIt.instance;

class ConnectScreen extends StatefulWidget {
  const ConnectScreen({Key? key}) : super(key: key);

  static const String webPath = '/connect';

  @override
  State<ConnectScreen> createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {
  UserApi userApi = getIt<UserApi>();
  GffftApi gffftApi = getIt<GffftApi>();

  static const _pageSize = 100;
  String? _searchTerm;

  final PagingController<String?, Bookmark> _bookmarkController = PagingController(firstPageKey: null);
  final PagingController<String?, Bookmark> _featuredController = PagingController(firstPageKey: null);
  final PagingController<String?, GffftMinimal> _searchController = PagingController(firstPageKey: null);

  @override
  void initState() {
    _bookmarkController.addPageRequestListener((pageKey) {
      _fetchBookmarkPage(pageKey);
    });

    _featuredController.addPageRequestListener((pageKey) {
      _fetchFeaturedPage(pageKey);
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

    _featuredController.addStatusListener((status) {
      if (status == PagingStatus.subsequentPageError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Something went wrong while fetching a new page.',
            ),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () => _featuredController.retryLastFailedRequest(),
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

  Future<void> _fetchFeaturedPage(pageKey) async {
    try {
      final newItems = await userApi.getBookmarks(
        pageKey,
        _pageSize,
        _searchTerm,
      );

      final isLastPage = newItems.count < _pageSize;
      if (isLastPage) {
        _featuredController.appendLastPage(newItems.items);
      } else {
        _featuredController.appendPage(newItems.items, newItems.items.last.gid);
      }
    } catch (error) {
      _featuredController.error = error;
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
    _bookmarkController.dispose();
    _searchController.dispose();
    _featuredController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context);
    final theme = context.appTheme.materialTheme;

    return Theme(
      data: ThemeData.dark().copyWith(
          appBarTheme: theme.appBarTheme,
          scaffoldBackgroundColor: theme.scaffoldBackgroundColor,
          textTheme: theme.textTheme),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.featured_video_outlined)),
                Tab(icon: Icon(Icons.bookmark)),
                Tab(icon: Icon(Icons.search)),
              ],
            ),
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: theme.primaryColor),
              onPressed: () => VxNavigator.of(context).pop(),
            ),
            title: Text(
              l10n!.connect,
              style: theme.textTheme.headline1,
            ),
            centerTitle: true,
          ),
          body: TabBarView(
            children: [
              _getFeaturedScreen(theme, l10n),
              _getBookmarkScreen(theme, l10n),
              _getSearchScreen(theme, l10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getBookmarkScreen(theme, l10n) {
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
              noItemsFoundIndicatorBuilder: (_) => NoBookmarksFound()),
        ),
      ],
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
    return Container(
        child: CustomScrollView(
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
                    VxNavigator.of(context)
                        .push(Uri(path: "/" + Uri(pathSegments: ["users", item.uid, "gfffts", item.gid]).toString()));
                  },
                  trailing: Icon(Icons.chevron_right, color: theme.primaryColor)),
              noItemsFoundIndicatorBuilder: (_) => SearchNotFound()),
        ),
      ],
    ));
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
