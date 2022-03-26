import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/gfffts/gffft_list_screen.dart';
import 'package:gffft/style/app_theme.dart';
import 'package:gffft/users/user_api.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:velocity_x/velocity_x.dart';

import 'models/bookmark.dart';

final getIt = GetIt.instance;

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({Key? key}) : super(key: key);

  static const String webPath = '/bookmarks';

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  UserApi userApi = getIt<UserApi>();

  static const _pageSize = 200;
  String? _searchTerm;

  final PagingController<String?, Bookmark> _pagingController = PagingController(firstPageKey: null);

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
      final newItems = await userApi.getBookmarks(
        pageKey,
        _pageSize,
        _searchTerm,
      );

      final isLastPage = newItems.count < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems.items);
      } else {
        _pagingController.appendPage(newItems.items, newItems.items.last.id);
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
    final theme = context.appTheme.materialTheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          l10n!.bookmarks,
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
          SliverToBoxAdapter(
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                  child: TextButton(
                    style: ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFFFFDC56))),
                    onPressed: () {
                      VxNavigator.of(context).push(Uri(path: GffftListScreen.webPath));
                    },
                    child: Text(l10n.search),
                  ))
            ]),
          ),
          PagedSliverList<String?, Bookmark>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<Bookmark>(
              animateTransitions: true,
              itemBuilder: (context, item, index) => ListTile(
                  title: Text(item.name),
                  subtitle: Text(item.name),
                  onTap: () {
                    if (item.gffft != null) {
                      VxNavigator.of(context)
                          .push(Uri(pathSegments: ["users", item.gffft!.uid, "gfffts", item.gffft!.gid]));
                    }
                  },
                  trailing: Icon(Icons.chevron_right, color: theme.primaryColor)),
            ),
          ),
        ],
      ),
    );
  }
}
