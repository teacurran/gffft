import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/components/search_input_sliver.dart';
import 'package:gffft/style/app_theme.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../components/first_page_exception_indicator.dart';
import '../gfffts/gffft_api.dart';
import '../gfffts/gffft_home_screen.dart';
import '../gfffts/models/gffft_minimal.dart';
import '../users/user_api.dart';

final getIt = GetIt.instance;

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  UserApi userApi = getIt<UserApi>();
  GffftApi gffftApi = getIt<GffftApi>();

  final PagingController<String?, GffftMinimal> _searchController = PagingController(firstPageKey: null);
  static const _pageSize = 100;
  String? _searchTerm;

  Widget _getTrailingItems(theme, l10n, GffftMinimal gffft) {
    var boardThreads = gffft.membership?.updateCounters?.boardThreads ?? 0;
    var boardPosts = gffft.membership?.updateCounters?.boardPosts ?? 0;
    var galleryPhotos = gffft.membership?.updateCounters?.galleryPhotos ?? 0;
    var galleryVideos = gffft.membership?.updateCounters?.galleryVideos ?? 0;
    var linkSetItems = gffft.membership?.updateCounters?.linkSetItems ?? 0;

    var hasUpdate = (boardThreads > 0) || boardPosts > 0 || galleryPhotos > 0 || galleryVideos > 0 || linkSetItems > 0;

    Widget trailiningIcon = FittedBox(
        fit: BoxFit.fill,
        child: Row(
          children: <Widget>[
            if (hasUpdate) Icon(Icons.new_releases, color: theme.primaryColor),
            Icon(Icons.chevron_right, color: theme.primaryColor),
          ],
        ));

    return trailiningIcon;
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
  void initState() {
    super.initState();

    _searchController.addPageRequestListener((pageKey) {
      _fetchSearchPage(pageKey);
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
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context);
    final theme = context.appTheme.materialTheme;

    return CustomScrollView(
      slivers: <Widget>[
        SearchInputSliver(onChanged: (searchTerm) => _updateSearchTerm(searchTerm), label: l10n!.gffftListSearchHint),
        PagedSliverList<String?, GffftMinimal>(
          pagingController: _searchController,
          builderDelegate: PagedChildBuilderDelegate<GffftMinimal>(
              animateTransitions: true,
              itemBuilder: (context, item, index) => ListTile(
                  title: Text(item.name),
                  subtitle: Text(item.description ?? item.name),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return GffftHomeScreen(uid: item.uid, gid: item.gid);
                    }));
                  },
                  trailing: _getTrailingItems(theme, l10n, item)),
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
