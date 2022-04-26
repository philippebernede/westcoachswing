import 'package:flutter/material.dart';

class AuthenticationForm extends StatefulWidget {
  const AuthenticationForm(this.submitFn, this.isLoading, {Key? key})
      : super(key: key);

  final bool isLoading;
  final void Function(
    String email,
    String password,
    String firstName,
    String lastName,
    bool isLogin,
    bool resetPassword,
    BuildContext ctx,
  ) submitFn;

  @override
  _AuthenticationFormState createState() => _AuthenticationFormState();
}

class _AuthenticationFormState extends State<AuthenticationForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _studentEmail = '';
  String _firstName = '';
  String _lastName = '';
  String _studentPassword = '';
  bool _resetPassword = false;
  bool _obscuredPwd = true;

//  fonction pour lancer la vérification des différents champs
  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

//     // ---------------------------------------------------------------------Partie pour ajouter de nouveaux drills--------------------------------------------------------------
//     // ---------------les nouveaux drills sont à mettre ici dans la list drillAdd------------------------
//     List<Drill> drillAdd = [];
//     drillAdd.forEach(
//       (element) => FirebaseFirestore.instance
//           .collection('drill')
//           .doc(element.id.toString())
//           .set({
//         'name': element.name,
//         'role': element.role.toString(),
//         'duration': element.duration,
//         'level': element.level.toString(),
//         'shortVideoURL': element.shortVideoURL,
//         'videoURL': element.videoURL,
//         'partner': element.partner.toString(),
//         'imageLink': element.imageLink,
//         'personalSkill': element.personalSkill,
//         'partneringSkill': element.partneringSkill,
//         'technique': element.technique,
//         'musicality': element.musicality,
//         'styling': element.styling,
// //                'levels': element.levels,
//       }),
//     );

    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
          _studentEmail.trim(),
          _studentPassword.trim(),
          _firstName.trim(),
          _lastName.trim(),
          _isLogin,
          _resetPassword,
          context);
      _resetPassword = false;
    }
  }

// TextStyle for the hint and input text
  TextStyle inputTextStyle = const TextStyle(
      color: Colors.black, fontSize: 17, fontFamily: "CentraleSansRegular");

//  inputdecoration for all the textformfields
  InputDecoration _inputDecorationTextFormField(
      String hintText, IconData preIcon) {
    return InputDecoration(
      prefixIcon: Icon(preIcon),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white, width: 3)),
      hintText: hintText,
      hintStyle: inputTextStyle,
      errorStyle:
          const TextStyle(color: Colors.white, backgroundColor: Colors.teal),
    );
  }

//  fonction de vérification qu'il s'agit bien d'un courriel
  bool validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  bool validatePassword(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
// vérifie que si on est en mode login ou signUp si on est en sign up on propose l'entrée du prénom sinon rien
          if (!_isLogin)
            TextFormField(
              key: const ValueKey('First Name'),
              textCapitalization: TextCapitalization.words,
              autocorrect: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your First Name';
                }
                return null;
              },
              style: inputTextStyle,
              decoration: _inputDecorationTextFormField(
                  'First Name', Icons.account_circle),
              onSaved: (String? value) {
                _firstName = value!;
              },
            ),
//  vérifie que si on est en mode login ou signUp si on est en sign up on propose l'entrée du Nom de famille
          if (!_isLogin)
            const SizedBox(
              height: 20,
            ),
          if (!_isLogin)
            TextFormField(
              key: const ValueKey('Last Name'),
              autocorrect: true,
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your Last Name';
                }
                return null;
              },
              style: inputTextStyle,
              decoration: _inputDecorationTextFormField(
                  'Last Name', Icons.account_circle),
              onSaved: (String? value) {
                _lastName = value!;
              },
            ),
//  Ajout de l'entrée de courriel
          if (!_isLogin)
            const SizedBox(
              height: 20,
            ),
          TextFormField(
            onChanged: (value) => !validateEmail(value.toString().trim()),
            key: const ValueKey('email'),
            autocorrect: false,
            textCapitalization: TextCapitalization.none,
            validator: (value) {
              if (value!.isEmpty || !validateEmail(value.toString().trim())) {
                return 'Please enter a valid email address.';
              }
              return null;
            },
            keyboardType: TextInputType.emailAddress,
            style: inputTextStyle,
            decoration: _inputDecorationTextFormField('Email', Icons.email),
            onSaved: (String? value) {
              _studentEmail = value!;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          if (!_resetPassword)
            TextFormField(
              key: const ValueKey('password'),
              validator: (value) {
                if (_isLogin) return null;
                if (value!.isEmpty ||
                    !validatePassword(value.toString().trim())) {
                  return 'Your Password is too weak.';
                }
                return null;
              },
              obscureText: _obscuredPwd,
              style: inputTextStyle,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.remove_red_eye),
                    onPressed: () {
                      _obscuredPwd = !_obscuredPwd;
                      setState(() {});
                    },
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  errorStyle: const TextStyle(
                      color: Colors.white, backgroundColor: Colors.teal),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: Colors.white, width: 3)),
                  hintText: "Password",
                  hintStyle: inputTextStyle),
              onSaved: (String? value) {
                _studentPassword = value!;
              },
            ),
          if (!_resetPassword)
            const SizedBox(
              height: 20,
            ),
          if (_isLogin)
            const Divider(
              thickness: 1.0,
              height: 1.0,
              color: Colors.teal,
            ),
          if (_isLogin)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Center(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _obscuredPwd = true;
                        _resetPassword = !_resetPassword;
                      });
                    },
                    child: Text(
                      _resetPassword ? 'Back to sign in' : "Forgot Password?",
                      style: const TextStyle(
                          fontFamily: 'CentraleSansRegular',
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          if (widget.isLoading) const CircularProgressIndicator(),
          if (!widget.isLoading)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: Text(_isLogin
                  ? (_resetPassword ? 'Reset Password' : 'Login')
                  : 'Sign up'),
              onPressed: _trySubmit,
            ),

          if (!widget.isLoading)
            TextButton(
              // textColor: Theme.of(context).primaryColor,
              child: Text(
                _isLogin ? 'Create new account' : 'I already have an account',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              onPressed: () {
                setState(() {
                  _isLogin = !_isLogin;
                  _resetPassword = false;
                  _obscuredPwd = true;
                });
              },
            ),
          const SizedBox(
            height: 20,
          ),

// TODO peut être ajouter ces elements plus tard, mais pas pour l'instant
//          SizedBox(
//            height: 20,
//          ),
//          MaterialButton(
//            color: Colors.blueAccent,
//            minWidth: 330,
//            height: 70,
//            shape: RoundedRectangleBorder(
//                borderRadius: BorderRadius.circular(10),
//                side: BorderSide(color: Colors.white, width: 3)),
//            onPressed: () {},
//            child: Row(
//              crossAxisAlignment: CrossAxisAlignment.center,
//              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//              children: <Widget>[
//                Icon(
//                  LineAwesomeIcons.facebook_official,
//                  color: Colors.white,
//                  size: 40,
//                ),
//                Text(
//                  "Connect with Facebook",
//                  style: TextStyle(
//                      color: Colors.white,
//                      fontFamily: "CentraleSansRegular",
//                      fontSize: 18,
//                      fontWeight: FontWeight.bold),
//                ),
//              ],
//            ),
//          ),
//          SizedBox(
//            height: 20,
//          ),
//          MaterialButton(
//            minWidth: 330,
//            height: 70,
//            shape: RoundedRectangleBorder(
//                borderRadius: BorderRadius.circular(10),
//                side: BorderSide(color: Colors.grey, width: 3)),
//            onPressed: () {
//              Navigator.pushReplacement(
//                  context, MaterialPageRoute(builder: (context) => HomePage()));
//            },
//            child: Row(
//              crossAxisAlignment: CrossAxisAlignment.center,
//              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//              children: <Widget>[
//                Text(
//                  "Continue as Guest",
//                  style: TextStyle(
//                      color: Colors.white,
//                      fontFamily: "CentraleSansRegular",
//                      fontSize: 18,
//                      fontWeight: FontWeight.bold),
//                ),
        ],
      ),
    );
  }
}
