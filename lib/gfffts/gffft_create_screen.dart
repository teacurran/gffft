import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/style/app_theme.dart';
import 'package:gffft/users/user_api.dart';

import 'gffft_api.dart';
import 'gffft_home_screen.dart';
import 'models/gffft_create.dart';

final getIt = GetIt.instance;

class GffftCreateScreen extends StatefulWidget {
  const GffftCreateScreen({Key? key}) : super(key: key);

  @override
  State<GffftCreateScreen> createState() => _GffftCreateScreenState();
}

class _GffftCreateScreenState extends State<GffftCreateScreen> {
  UserApi userApi = getIt<UserApi>();
  GffftApi gffftApi = getIt<GffftApi>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _handleController = TextEditingController();
  final _pageController = PageController(viewportFraction: 1);

  final _gffftFormKey = GlobalKey<FormState>();
  final _handleFormKey = GlobalKey<FormState>();
  var isSaving = false;
  var onHandlePage = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _handleController.dispose();
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
          l10n!.gffftCreateHead,
          style: theme.textTheme.headline1,
        ),
        centerTitle: true,
      ),
      backgroundColor: theme.backgroundColor,
      body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: [getCreateContent(l10n, theme), getHandleContent(l10n, theme)]),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: getFloatingActionButton(context),
    );
  }

  Widget? getFloatingActionButton(BuildContext context) {
    var l10n = AppLocalizations.of(context);

    if (isSaving) {
      return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        const FloatingActionButton.small(
            child: Icon(Icons.arrow_back), backgroundColor: Color(0xFFFABB59), onPressed: null),
        const Padding(padding: EdgeInsets.all(3)),
        FloatingActionButton.extended(
          label: Row(children: [
            const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(color: Colors.black)),
            Padding(padding: const EdgeInsets.fromLTRB(5, 0, 0, 0), child: Text(l10n!.gffftCreateCreateButton))
          ]),
          backgroundColor: const Color(0xFFFABB59),
          onPressed: () {},
        )
      ]);
    }

    if (onHandlePage) {
      return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        FloatingActionButton.small(
            child: const Icon(Icons.arrow_back),
            backgroundColor: const Color(0xFFFABB59),
            onPressed: () {
              setState(() {
                onHandlePage = false;
              });
              _pageController.previousPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
            }),
        const Padding(padding: EdgeInsets.all(3)),
        FloatingActionButton.extended(
          label: Row(children: [const Icon(Icons.save, color: Colors.black), Text(l10n!.gffftCreateCreateButton)]),
          backgroundColor: const Color(0xFFFABB59),
          onPressed: () async {
            if (_handleFormKey.currentState!.validate()) {
              setState(() {
                isSaving = true;
              });
              final gffft = await gffftApi.create(GffftCreate(
                name: _titleController.text,
                description: _descController.text,
                intro: _descController.text,
                initialHandle: _handleController.text,
              ));

              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return GffftHomeScreen(uid: gffft.uid, gid: gffft.gid);
              }));
            }
          },
        )
      ]);
    }

    return FloatingActionButton.extended(
      label: Row(children: [Text(l10n!.gffftCreateNextButton), const Icon(Icons.arrow_right_alt, color: Colors.black)]),
      backgroundColor: const Color(0xFFFABB59),
      onPressed: () {
        if (_gffftFormKey.currentState!.validate()) {
          setState(() {
            onHandlePage = true;
          });
          _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
        }
      },
    );
  }

  Widget getCreateContent(AppLocalizations l10n, ThemeData theme) {
    const fieldPadding = EdgeInsets.fromLTRB(0, 0, 0, 5);
    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Form(
              key: _gffftFormKey,
              child: Card(
                  elevation: 0,
                  margin: const EdgeInsets.all(8),
                  color: Colors.transparent,
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                        SelectableText(l10n.gffftCreateIntro,
                            textAlign: TextAlign.left, style: theme.textTheme.bodyText1),
                        Padding(
                            padding: fieldPadding,
                            child: TextFormField(
                              textAlign: TextAlign.left,
                              controller: _titleController,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(labelText: l10n.gffftEditCardName),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a name';
                                }
                                return null;
                              },
                            )),
                        Padding(
                            padding: fieldPadding,
                            child: TextField(
                              decoration: InputDecoration(labelText: l10n.gffftEditCardDescription),
                              controller: _descController,
                              textInputAction: TextInputAction.newline,
                              maxLines: 2,
                            )),
                      ])),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: const BorderSide(
                        color: Color(0xFFFABB59),
                        width: 1.0,
                      ))),
            )));
  }

  Widget getHandleContent(AppLocalizations l10n, ThemeData theme) {
    return Container(
        padding: const EdgeInsets.all(10),
        child: Form(
            key: _handleFormKey,
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Row(
                children: [
                  SelectableText(
                    l10n.gffftJoinHandle,
                    style: theme.textTheme.headline3,
                  ),
                ],
              ),
              Row(
                children: [
                  Flexible(
                      child: SelectableText(
                    l10n.gffftJoinHandleHint,
                    style: theme.textTheme.bodyText1,
                  ))
                ],
              ),
              Row(
                children: [
                  Flexible(
                      child: TextFormField(
                    style: theme.textTheme.headline1,
                    textAlign: TextAlign.center,
                    controller: _handleController,
                    maxLength: 128,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ))
                ],
              ),
            ])));
  }
}
