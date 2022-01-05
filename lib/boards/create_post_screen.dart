import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreatePostScreen extends StatefulWidget {
  final void Function(String subject, String body) onSaved;

  const CreatePostScreen({Key? key, required this.onSaved}) : super(key: key);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _subject = TextEditingController();
  final _body = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    AppLocalizations? l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(l10n!.connect),
          backgroundColor: theme.primaryColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.email, size: IconTheme.of(context).size, color: IconTheme.of(context).color),
                  labelText: 'E-Mail...',
                  counterText: '',
                ),
                keyboardType: TextInputType.emailAddress,
                controller: _subject,
                maxLength: 70,
              )
            ],
          ),
        ));
  }
}
