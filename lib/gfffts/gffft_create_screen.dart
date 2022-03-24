import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/style/app_theme.dart';
import 'package:gffft/users/user_api.dart';

import 'gffft_api.dart';

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

  final _formKey = GlobalKey<FormState>();
  var isLoading = false;
  var isSaving = false;

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
          l10n!.gffftSettingsHead,
          style: theme.textTheme.headline1,
        ),
        centerTitle: true,
      ),
      backgroundColor: theme.backgroundColor,
      body: PageView(
          physics: const PageScrollPhysics(),
          controller: PageController(viewportFraction: 0.8),
          children: [getCreateContent(l10n, theme), getHandleContent(l10n, theme)]),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: getFloatingActionButton(context),
    );
  }

  Widget? getFloatingActionButton(BuildContext context) {
    if (isSaving) {
      return FloatingActionButton(
          child: const CircularProgressIndicator(), backgroundColor: const Color(0xFFFABB59), onPressed: () {});
    }
    return FloatingActionButton.extended(
      label: Row(children: const [Text("next"), Icon(Icons.arrow_right_alt, color: Colors.black)]),
      backgroundColor: const Color(0xFFFABB59),
      onPressed: () {},
    );
  }

  Widget getCreateContent(AppLocalizations l10n, ThemeData theme) {
    const fieldPadding = EdgeInsets.fromLTRB(0, 5, 0, 20);
    return SingleChildScrollView(
      child: Card(
          elevation: 0,
          margin: const EdgeInsets.all(8),
          color: Colors.transparent,
          child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Row(children: [
                  const Padding(padding: fieldPadding, child: Icon(Icons.settings, color: Color(0xFFFABB59))),
                  Text(
                    l10n!.gffftSettingsGeneralHead,
                    style: theme.textTheme.headline6?.copyWith(color: const Color(0xFFFABB59)),
                  )
                ]),
                Padding(
                    padding: fieldPadding,
                    child: TextField(
                      textAlign: TextAlign.left,
                      controller: _titleController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(labelText: l10n.gffftEditCardName),
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
    );
  }

  Widget getHandleContent(AppLocalizations l10n, ThemeData theme) {
    return Container(
        padding: const EdgeInsets.all(10),
        child: Form(
            key: _formKey,
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              isLoading ? const LinearProgressIndicator() : const Padding(padding: EdgeInsets.only(top: 0.0)),
              Row(
                children: [
                  SelectableText(
                    l10n.gffftJoinRules,
                    style: theme.textTheme.headline3,
                  ),
                ],
              ),
              Row(
                children: [
                  Flexible(
                      child: SelectableText(
                    "here will be some rules for this gffft.\n  *maybe bullet points\n  *like, no jerks\n  *let users configure this?",
                    style: theme.textTheme.bodyText1,
                  ))
                ],
              ),
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
              OutlinedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });

                      // await gffftApi.joinGffft(widget.uid, widget.gid, _handleController.text);
                      // todo: check for errors here (username taken, etc)

                      setState(() {
                        isLoading = false;
                      });

                      Navigator.pop(context);
                    }
                  },
                  child: Text(l10n.gffftJoinButton)),
            ])));
  }
}
