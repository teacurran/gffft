import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/gfffts/gffft_create_screen.dart';
import 'package:gffft/style/app_theme.dart';
import 'package:gffft/users/models/bookmark.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../components/first_page_exception_indicator.dart';
import '../../gfffts/gffft_api.dart';
import '../../gfffts/gffft_home_screen.dart';
import '../../gfffts/models/gffft_minimal.dart';
import '../../users/user_api.dart';
import '../screens/login_screen.dart';
import '../users/models/user.dart';

final getIt = GetIt.instance;

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({Key? key}) : super(key: key);

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  UserApi userApi = getIt<UserApi>();
  GffftApi gffftApi = getIt<GffftApi>();
  Future<User?>? user;

  final PagingController<String?, Bookmark> _bookmarkController = PagingController(firstPageKey: null);

  static const _pageSize = 100;
  String? _searchTerm;
  bool disposed = false;
  bool isHosting = false;
  bool bookmarksLoaded = false;

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

  Future<void> _fetchBookmarkPage(pageKey) async {
    try {
      final newItems = await userApi.getBookmarks(
        pageKey,
        _pageSize,
        _searchTerm,
      );

      setState(() {
        isHosting = newItems.isHosting;
        bookmarksLoaded = true;
      });

      final isLastPage = newItems.count < _pageSize;
      if (!disposed) {
        if (isLastPage) {
          _bookmarkController.appendLastPage(newItems.items);
        } else {
          _bookmarkController.appendPage(newItems.items, newItems.items.last.id);
        }
      }
    } catch (error) {
      if (!disposed) {
        _bookmarkController.error = error;
      }
    }
  }

  Future<void> _loadData() async {
    setState(() {
      user = userApi.me();
    });
  }

  @override
  void initState() {
    super.initState();

    _bookmarkController.addPageRequestListener((pageKey) {
      _fetchBookmarkPage(pageKey);
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

    _loadData();
  }

  @override
  void dispose() {
    disposed = true;
    _bookmarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context);
    final theme = context.appTheme.materialTheme;

    return FutureBuilder(
        future: user,
        builder: (context, AsyncSnapshot<User?> snapshot) {
          Widget screenBody = const LoadingIndicator(size: 30, borderWidth: 1);

          if (snapshot.hasError) {
            // Navigator.pushReplacementNamed(context, LoginScreen.webPath);
            // Future.delayed(Duration.zero, () async {
            //   VxNavigator.of(context).clearAndPush(Uri(path: LoginScreen.webPath));
            // });
          }

          if (snapshot.connectionState == ConnectionState.done) {
            var user = snapshot.data;
            if (user != null) {
              final createGffftTitle = ListTile(
                key: const Key("createItem"),
                title: const Text("Create your own gffft."),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("click here to get start hosting your own gffft", textAlign: TextAlign.left),
                    Divider(
                      height: 20,
                      thickness: 1,
                      indent: 10,
                      endIndent: 0,
                      color: Color(0xFF9970A9),
                    )
                  ],
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const GffftCreateScreen();
                  }));
                },
                leading: const Icon(Icons.star),
                minLeadingWidth: 14,
                trailing: Icon(Icons.add, color: theme.primaryColor),
                style: ListTileStyle.list,
              );

              screenBody = RefreshIndicator(
                  onRefresh: () async {
                    _bookmarkController.refresh();
                  },
                  child: CustomScrollView(
                    slivers: <Widget>[
                      if (!isHosting && bookmarksLoaded)
                        SliverToBoxAdapter(
                          key: const Key("createItemSliver"),
                          child: createGffftTitle,
                        ),
                      PagedSliverList<String?, Bookmark>(
                        pagingController: _bookmarkController,
                        builderDelegate: PagedChildBuilderDelegate<Bookmark>(
                            animateTransitions: true,
                            itemBuilder: (context, bookmark, index) {
                              final gffft = bookmark.gffft;
                              String? handle = gffft?.membership?.handle;
                              String? membershipType = gffft?.membership?.type;
                              String? membershipLine = gffft?.membership?.type;
                              if (membershipLine != null &&
                                  membershipLine.isNotEmpty &&
                                  handle != null &&
                                  handle.isNotEmpty) {
                                membershipLine = membershipLine + " / " + handle;
                              }

                              if (gffft != null) {
                                List<Widget> children = [
                                  SelectableText(gffft.description ?? gffft.name, textAlign: TextAlign.left)
                                ];
                                if (membershipLine != null && membershipLine.isNotEmpty) {
                                  children.add(Text(
                                    membershipLine,
                                    textAlign: TextAlign.left,
                                    style: theme.textTheme.bodyText1!.copyWith(color: Colors.grey),
                                  ));
                                }
                                children.add(const Divider(
                                  height: 20,
                                  thickness: 1,
                                  indent: 10,
                                  endIndent: 0,
                                  color: Color(0xFF9970A9),
                                ));
                                return ListTile(
                                  title: Text(gffft.name),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: children,
                                  ),
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return GffftHomeScreen(uid: gffft.uid, gid: gffft.gid);
                                    }));
                                  },
                                  leading: membershipType == "owner"
                                      ? const Icon(Icons.star, size: 30)
                                      : const Icon(Icons.bookmark, size: 20),
                                  minLeadingWidth: 30,
                                  trailing: _getTrailingItems(theme, l10n, gffft),
                                  style: ListTileStyle.list,
                                );
                              }
                              return Container();
                            },
                            noItemsFoundIndicatorBuilder: (_) => BookmarkNotFound()),
                      ),
                    ],
                  ));
            } else {
              screenBody = LoginScreen(onLogin: () {
                _loadData();
                _bookmarkController.refresh();
              });
            }
          }
          return screenBody;
        });
  }
}

class BookmarkNotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const FirstPageExceptionIndicator(
        title: 'No Bookmarks Found',
        message: 'when you bookmark a gffft it will show up here',
      );
}
