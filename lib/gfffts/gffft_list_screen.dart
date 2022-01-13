import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/components/search_input_sliver.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:velocity_x/velocity_x.dart';

import 'gffft_api.dart';
import 'models/gffft_minimal.dart';

final getIt = GetIt.instance;

class GffftListScreen extends StatefulWidget {
  const GffftListScreen({Key? key}) : super(key: key);

  static const String webPath = '/gfffts';

  @override
  _GffftListScreenState createState() => _GffftListScreenState();
}

class _GffftListScreenState extends State<GffftListScreen> {
  GffftApi gffftApi = getIt<GffftApi>();

  static const _pageSize = 20;
  String? _searchTerm;

  final PagingController<String?, GffftMinimal> _pagingController = PagingController(firstPageKey: null);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });

    _pagingController.addStatusListener((status) {
      if (status == PagingStatus.subsequentPageError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Something went wrong while fetching a new page.',
            ),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () => _pagingController.retryLastFailedRequest(),
            ),
          ),
        );
      }
    });

    super.initState();
  }

  Future<void> _fetchPage(pageKey) async {
    try {
      final newItems = await gffftApi.getGfffts(
        pageKey,
        _pageSize,
        _searchTerm,
      );

      final isLastPage = newItems.count < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems.items);
      } else {
        _pagingController.appendPage(newItems.items, newItems.items.last.gid);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  void _updateSearchTerm(String searchTerm) {
    _searchTerm = searchTerm;
    _pagingController.refresh();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          l10n!.connect,
          style: theme.textTheme.headline1,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.primaryColor),
          onPressed: () => VxNavigator.of(context).pop(),
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SearchInputSliver(onChanged: (searchTerm) => _updateSearchTerm(searchTerm), label: l10n.gffftListSearchHint),
          PagedSliverList<String?, GffftMinimal>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<GffftMinimal>(
              animateTransitions: true,
              itemBuilder: (context, item, index) => ListTile(
                  title: Text(item.name),
                  subtitle: Text(item.description ?? "unknown"),
                  onTap: () {
                    VxNavigator.of(context).push(Uri(pathSegments: ["users", item.uid, "gfffts", item.gid]));
                  },
                  trailing: Icon(Icons.chevron_right, color: theme.primaryColor)),
            ),
          ),
        ],
      ),
    );
  }
}