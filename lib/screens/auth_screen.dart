import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_code_picker/country_codes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gffft/screens/app_screen.dart';
import 'package:gffft/src/auth_model.dart';
import 'package:gffft/src/constants.dart';
import 'package:pin_view/pin_view.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  Locale _myLocale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initDynamicLinks();
    _myLocale = Localizations.localeOf(context);

    /// We need to reflect the initial selection of the dialcode, in case the phone's selected locale
    /// matches the phone dial code, which is the majority of the cases.
    /// We do this by loading up a list of dialcodes and their respected country code, from there
    /// we find the matching dialcode for the phone's locale.
    List<CountryCode> elements = codes
        .map((s) => CountryCode(
              name: "",
              code: s['code'],
              dialCode: s['dial_code'],
              flagUri: "",
            ))
        .toList();
    String dialCode =
        elements.firstWhere((c) => c.code == _myLocale.countryCode).dialCode;

    var _auth = Provider.of<AuthModel>(context);
    _auth.changeDialCode(dialCode);
  }

  void initDynamicLinks() async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

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
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          StreamBuilder(
              stream: _auth.authStatus,
              builder: (context, snapshot) {
                switch (snapshot.data) {
                  case (AuthStatus.emailAuth):
                    return _authForm(_auth, true, context);
                    break;
                  case (AuthStatus.phoneAuth):
                    return _authForm(_auth, false, context);
                    break;
                  case (AuthStatus.emailLinkSent):
                    return Column(children: <Widget>[
                      Center(child: Text(Constants.sentEmail)),
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
                    break;
                  case (AuthStatus.smsSent):
                    return _smsCodeInputField(_auth);
                    break;
                  case (AuthStatus.isLoading):
                    return const Center(child: CircularProgressIndicator());
                    break;
                  default:
                    // By default we will show the email auth form
                    return _authForm(_auth, true, context);
                    break;
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
  Widget _emailInputField(AuthModel authModel, String error) {
    return TextField(
      onChanged: authModel.changeEmail,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(fontSize: 20),
      decoration: InputDecoration(
        hintText: Constants.enterEmail,
        errorText: error,
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
  Widget _phoneInputField(AuthModel authModel, String error) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
              child: CountryCodePicker(
                onChanged: (countryCode) =>
                    authModel.changeDialCode(countryCode.dialCode),
                initialSelection: _myLocale.countryCode,
                favorite: [_myLocale.countryCode],
                showCountryOnly: false,
                alignLeft: true,
              ),
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
                errorText: error,
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
    return Column(children: <Widget>[
      PinView(
          count: 6, // describes the field number
          margin: EdgeInsets.all(2.5), // margin between the fields
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
          submit: (String smsCode) {
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
    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      authModel.changeAuthStatus(AuthStatus.phoneAuth);
      _showSnackBar(Constants.verificationFailed);
      //TODO: show error to user.
      print(
          'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
    };

    PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      authModel
          .signInWithCredential(phoneAuthCredential)
          .then((result) => _authCompleted());
      print('Received phone auth credential: $phoneAuthCredential');
    };

    PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      authModel.changeVerificationId(verificationId);
      print(
          'Please check your phone for the verification code. $verificationId');
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      print("auto retrieval timeout");
    };

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
