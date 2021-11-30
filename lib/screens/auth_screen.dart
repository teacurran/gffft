import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_code_picker/country_codes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gffft/screens/app_screen.dart';
import 'package:gffft/src/auth_model.dart';
import 'package:gffft/src/constants.dart';
import 'package:provider/provider.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:collection/collection.dart';

class AuthScreen extends StatefulWidget {
  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  late Locale _myLocale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initDynamicLinks();
    _myLocale = Localizations.localeOf(context);

    /// We need to reflect the initial selection of the dialcode, in case the phone's selected locale
    /// matches the phone dial code, which is the majority of the cases.
    /// We do this by loading up a list of dialcodes and their respected country code, from there
    /// we find the matching dialcode for the phone's locale.
    List<CountryCode> countryCodes = codes
        .map((s) => CountryCode(
              name: "",
              code: s['code'],
              dialCode: s['dial_code'],
              flagUri: "",
            ))
        .toList();
    CountryCode? countryCode = countryCodes.firstWhereOrNull(
            (c) => c.code!.toLowerCase() == _myLocale.countryCode!.toLowerCase()
    );
    String? dialCode = (countryCode != null) ? countryCode.dialCode : countryCodes.firstWhere((c) => c.code == "US").dialCode;

    var _auth = Provider.of<AuthModel>(context);
    if (dialCode != null) {
      _auth.changeDialCode(dialCode);
    }
  }

  void initDynamicLinks() async {
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      print("deep link: $deepLink");
      // try {
      //   /// Change status to a loading state, so user would not get confused even for a second.
      //   _bloc.changeAuthStatus(AuthStatus.isLoading);
      //   await _bloc
      //       .signInWIthEmailLink(await _bloc.getUserEmailFromStorage(), deepLink.toString())
      //       .catchError((e) {
      //     print("dynamic link error:$e");
      //   }).whenComplete(() => _authCompleted());
      // } catch (e) {
      //   print("dynamic link error:: ${e}");
      // }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _auth = context.watch<AuthModel>();

    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          StreamBuilder(
              stream: _auth.authStatus,
              builder: (context, snapshot) {
                switch (snapshot.data) {
                  case (AuthStatus.emailAuth):
                    return _authForm(_auth, true, context);
                  case (AuthStatus.phoneAuth):
                    return _authForm(_auth, false, context);
                  case (AuthStatus.emailLinkSent):
                    return Column(children: <Widget>[
                      const Center(child: Text(Constants.sentEmail)),
                      GestureDetector(
                          onTap: () =>
                              _auth.changeAuthStatus(AuthStatus.emailAuth),
                          child: const Text(
                            "Enter another email address",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ]);
                  case (AuthStatus.smsSent):
                    return _smsCodeInputField(_auth);
                  case (AuthStatus.isLoading):
                    return const Center(child: CircularProgressIndicator());
                  default:
                    // By default we will show the email auth form
                    return _authForm(_auth, true, context);
                }
              })
        ],
      ),
    );
  }

  /// Widget is specfied for auth method by [isEmail] value.
  /// If its false, a form for phone auth is given.
  /// This is to make it easier for the email and phone auth forms to be more similar looking.
  /// Keeping that in mind we'll try to share all the widgets to a reasonable extent.
  Widget _authForm(AuthModel authModel, bool isEmail, BuildContext context) {
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      onPrimary: Colors.black87,
      primary: Theme.of(context).highlightColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    );

    const String logoAsset = 'assets/logo.svg';

    return StreamBuilder(
        stream: isEmail ? authModel.email : authModel.phone,
        builder: (context, snapshot) {
          return Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                SvgPicture.asset(logoAsset, semanticsLabel: 'Gffft Logo', color: Theme.of(context).highlightColor),
                Flexible(
                    child: isEmail
                        ? _emailInputField(authModel, snapshot.error)
                        : _phoneInputField(authModel, snapshot.error)),
                ElevatedButton(
                  onPressed: () => snapshot.hasData
                      ? (isEmail
                          ? _authenticateUserWithEmail(authModel)
                          : _authenticateUserWithPhone(authModel))
                      : null,
                  child: Text(
                    Constants.submit.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: raisedButtonStyle,
                ),
                const Spacer(),
                Flexible(
                    fit: FlexFit.loose,
                    child: TextButton(
                        onPressed: () => authModel.changeAuthStatus(isEmail
                            ? AuthStatus.phoneAuth
                            : AuthStatus.emailAuth),
                        child: Text(
                          isEmail
                              ? Constants.usePhone.toUpperCase()
                              : Constants.useEmail.toUpperCase(),
                        ))),
              ]));
        });
  }

  /// The method takes in an [error] message from our validator.
  Widget _emailInputField(AuthModel authModel, Object? error) {
    return TextField(
      onChanged: authModel.changeEmail,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(fontSize: 20),
      decoration: InputDecoration(
        hintText: Constants.enterEmail,
        errorText: error is String ? error : null,
        labelText: Constants.labelEmail,
        labelStyle: const TextStyle(
          color: Colors.blue,
          fontSize: 16,
        ),
      ),
    );
  }

  /// Besides the user entering their phone number, we also need to know the user's country code
  /// for that we are gonna use a library CountryCodePicker.
  /// The method takes in an [error] message from our validator.
  Widget _phoneInputField(AuthModel authModel, Object? error) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
              child: CountryCodePicker(
                onChanged: (countryCode) {
                  final dialCode = countryCode.dialCode;
                  if(dialCode != null) {
                    authModel.changeDialCode(dialCode);
                  }
                },
                initialSelection: 'US',
                favorite: [],
                countryFilter: const ['US', 'CA', 'MX'],
                padding: const EdgeInsets.all(0.0),
                showCountryOnly: false,
                showDropDownButton: false,
                alignLeft: true,
                searchStyle: const TextStyle(color: Colors.black),
                closeIcon: const Icon(Icons.close, color: Colors.black),
                searchDecoration: const InputDecoration(prefixIcon: Icon(Icons.search, color: Colors.black)),
                dialogTextStyle: const TextStyle(color: Colors.black),
                dialogSize: Size(MediaQuery.of(context).size.width * 0.85, 400),
              )
            ),
          ),
          Expanded(
            flex: 2,
            child: TextField(
              onChanged: authModel.changePhone,
              keyboardType: TextInputType.phone,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                hintText: Constants.enterPhone,
                errorText: error is String ? error : null,
                labelText: Constants.labelPhone,
                labelStyle: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _smsCodeInputField(AuthModel authModel) {
    var _pinPutDecoration = BoxDecoration(
        border: Border.all(color: Colors.deepPurpleAccent),
        borderRadius: BorderRadius.circular(15.0),
    );

    return Column(children: <Widget>[
      PinPut(
          fieldsCount: 6,
          submittedFieldDecoration: _pinPutDecoration.copyWith(
            borderRadius: BorderRadius.circular(20.0),
          ),
          selectedFieldDecoration: _pinPutDecoration,
          followingFieldDecoration: _pinPutDecoration.copyWith(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
              color: Colors.deepPurpleAccent.withOpacity(.5),
            ),
          ),
          onSubmit: (String smsCode) {
            AuthCredential credential = PhoneAuthProvider.credential(
                verificationId: authModel.getVerificationId, smsCode: smsCode);
            authModel.signInWithCredential(credential).then((result) =>
                // You could potentially find out if the user is new
                // and if so, pass that info on, to maybe do a tutorial
                // if (result.additionalUserInfo.isNewUser)
                _authCompleted());
          }),
    ]);
  }

  void _authenticateUserWithEmail(AuthModel authModel) {
    authModel.sendSignInWithEmailLink().whenComplete(() => authModel
        .storeUserEmail()
        .whenComplete(
            () => authModel.changeAuthStatus(AuthStatus.emailLinkSent)));
  }

  void _authenticateUserWithPhone(AuthModel authModel) {
    verificationFailed(FirebaseAuthException authException) {
      authModel.changeAuthStatus(AuthStatus.phoneAuth);
      _showSnackBar(Constants.verificationFailed);
      //TODO: show error to user.
      print('Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
    }

    verificationCompleted(AuthCredential phoneAuthCredential) {
      authModel
          .signInWithCredential(phoneAuthCredential)
          .then((result) => _authCompleted());
      print('Received phone auth credential: $phoneAuthCredential');
    }

    codeSent(String verificationId, [int? forceResendingToken]) async {
      authModel.changeVerificationId(verificationId);
      print(
          'Please check your phone for the verification code. $verificationId');
    }

    codeAutoRetrievalTimeout(String verificationId) {
      print("auto retrieval timeout");
    }

    authModel.changeAuthStatus(AuthStatus.smsSent);
    authModel.verifyPhoneNumber(codeAutoRetrievalTimeout, codeSent,
        verificationCompleted, verificationFailed);
  }

  _showSnackBar(String error) {
    final snackBar = SnackBar(content: Text(error));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _authCompleted() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => AppScreen()));
  }
}
