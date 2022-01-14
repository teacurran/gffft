import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/users/user_api.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:velocity_x/velocity_x.dart';

import 'models/thread.dart';

final getIt = GetIt.instance;

class BoardViewScreen extends StatefulWidget {
  const BoardViewScreen({Key? key, required this.uid, required this.gid, required this.bid}) : super(key: key);

  final String uid;
  final String gid;
  final String bid;

  @override
  _BoardViewScreenState createState() => _BoardViewScreenState();
}

class _BoardViewScreenState extends State<BoardViewScreen> {
  UserApi userApi = getIt<UserApi>();
  static const _pageSize = 200;
  final PagingController<String?, Thread> _pagingController = PagingController(firstPageKey: null);

  var isLoading = false;

  final _subject = TextEditingController();
  final _body = TextEditingController();

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
        widget.uid,
        widget.gid,
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
    _subject.dispose();
    _body.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.gid,
            style: theme.textTheme.headline1,
          ),
          backgroundColor: theme.backgroundColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: theme.secondaryHeaderColor),
            onPressed: () => VxNavigator.of(context).pop(),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add, color: theme.focusColor),
            tooltip: l10n!.boardViewActionTooltip,
            backgroundColor: theme.primaryColor,
            onPressed: () {
              VxNavigator.of(context)
                  .waitAndPush(
                      Uri(pathSegments: ["users", widget.uid, "gfffts", widget.gid, "boards", widget.bid, "post"]))
                  .then((value) {
                _pagingController.refresh();
              });

              // showModalBottomSheet<void>(
              //     context: context,
              //     builder: (BuildContext context) {
              //       return Container(
              //         height: 500,
              //         color: Colors.amber,
              //         child: Form(
              //             key: _formKey,
              //             child: CardSettings(showMaterialonIOS: true, children: [
              //               CardSettingsSection(
              //                   header: CardSettingsHeader(
              //                     label: l10n.boardCreatePostTitle,
              //                     color: theme.primaryColor,
              //                   ),
              //                   children: [
              //                     CardSettingsText(
              //                       label: l10n.boardCreatePostSubject,
              //                       validator: (value) {
              //                         if (value == null || value.isEmpty)
              //                           return l10n.validateFieldIsRequired(l10n.editName);
              //                       },
              //                       contentPadding: const EdgeInsets.all(8),
              //                       contentOnNewLine: true,
              //                       maxLength: 128,
              //                       showCounter: true,
              //                       controller: _subject,
              //                     ),
              //                     CardSettingsParagraph(
              //                       label: l10n.boardCreatePostBody,
              //                       contentOnNewLine: true,
              //                       maxLength: 1024,
              //                       controller: _body,
              //                     ),
              //                     CardSettingsButton(
              //                         backgroundColor: theme.backgroundColor,
              //                         label: l10n.boardCreatePostPost,
              //                         showMaterialonIOS: true,
              //                         onPressed: _handlePost),
              //                   ]),
              //             ])),
              //       );
              //     });
            }),
        body: CustomScrollView(slivers: <Widget>[
          PagedSliverList<String?, Thread>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<Thread>(
                animateTransitions: true,
                itemBuilder: (context, item, index) => ListTile(
                      title: Text("Poster Name"),
                      subtitle: Text(item.subject),
                    )),
          )
        ]));
  }
}
