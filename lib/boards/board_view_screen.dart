import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/boards/board_api.dart';
import 'package:gffft/gfffts/models/gffft_minimal.dart';
import 'package:gffft/users/user_api.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'create_post_screen.dart';
import 'models/post.dart';
import 'models/thread.dart';

final getIt = GetIt.instance;

class BoardViewScreen extends StatefulWidget {
  const BoardViewScreen({Key? key, required this.gffft, required this.bid}) : super(key: key);

  final GffftMinimal gffft;
  final String bid;

  @override
  _BoardViewScreenState createState() => _BoardViewScreenState();
}

class _BoardViewScreenState extends State<BoardViewScreen> {
  UserApi userApi = getIt<UserApi>();
  static const _pageSize = 200;
  final PagingController<String?, Thread> _pagingController = PagingController(firstPageKey: null);

  var isLoading = false;

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
      final newItems = await userApi.getBoardThreads(
        widget.gffft.uid,
        widget.gffft.gid,
        widget.bid,
        pageKey,
        _pageSize,
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

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    Future _handlePost(String subject, String body) async {
      BoardApi boardApi = getIt<BoardApi>();
      print("handlePost: $subject, $body");

      setState(() {
        isLoading = true;
      });

      Post post = Post(widget.gffft.uid, widget.gffft.gid, widget.bid, body, subject: subject);
      await boardApi.createPost(post);
      print("post sent!");
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.gffft.name),
          backgroundColor: theme.primaryColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: theme.secondaryHeaderColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add, color: theme.focusColor),
            tooltip: l10n!.boardViewActionTooltip,
            backgroundColor: theme.primaryColor,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreatePostScreen(
                      gffft: widget.gffft,
                      onSaved: _handlePost,
                    ),
                  ));
            }),
        body: const Padding(padding: EdgeInsets.all(16.0), child: CustomScrollView()));
  }
}
