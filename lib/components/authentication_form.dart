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
//     List<Drill> drillAdd = [
//       Drill(
//         name: 'Waltz 2 feet',
//         level: Level.L2,
//         duration: '01:30',
//         id: 2,
//         imageLink:
//             'https://www.googleapis.com/drive/v3/files/1WTquweJ8W8m8CXHw_zGxrn3uLDNcDDyY?alt=media&key=AIzaSyA0Tl505CBLuuK2goq6rGKCatWwkd_uSQM',
//         role: Role.Both,
//         shortVideoURL: 'https://vimeo.com/566655660/dcedfb952c',
//         videoURL: 'https://vimeo.com/542405490/efcbdf8c76',
//         partner: Partner.Solo,
//         partneringSkill: false,
//         personalSkill: true,
//         musicality: false,
//         styling: false,
//         technique: false,
//       ),
//       Drill(
//         name: 'Waltz 1 foot',
//         level: Level.L3,
//         duration: '01:30',
//         id: 3,
//         imageLink:
//             'https://www.googleapis.com/drive/v3/files/1FDoubDvkoXtcq8zv3TRCuexnaIrq1u26?alt=media&key=AIzaSyA0Tl505CBLuuK2goq6rGKCatWwkd_uSQM',
//         role: Role.Both,
//         shortVideoURL: 'https://vimeo.com/566655688/7effdf2d31',
//         videoURL: 'https://vimeo.com/542405528/0ee9b5a6ad',
//         partner: Partner.Solo,
//         partneringSkill: false,
//         personalSkill: true,
//         musicality: false,
//         styling: false,
//         technique: false,
//       ),
//       Drill(
//         name: 'Fountain',
//         level: Level.Fundamentals,
//         duration: '01:30',
//         id: 6,
//         imageLink:
//             'https://www.googleapis.com/drive/v3/files/1krzf5PnGtvLk_lQJKo62YFF4em6IOyjU?alt=media&key=AIzaSyA0Tl505CBLuuK2goq6rGKCatWwkd_uSQM',
//         role: Role.Both,
//         shortVideoURL: 'https://vimeo.com/566655709/487afe4f31',
//         videoURL: 'https://vimeo.com/542405610/d6d4459bc1',
//         partner: Partner.Solo,
//         partneringSkill: false,
//         personalSkill: true,
//         musicality: false,
//         styling: false,
//         technique: false,
//       ),
//     ];
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
  InputDecoration _inputDecorationTextFormField(String hintText) {
    return InputDecoration(
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
              decoration: _inputDecorationTextFormField('First Name'),
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
                  return 'Please enter your Name';
                }
                return null;
              },
              style: inputTextStyle,
              decoration: _inputDecorationTextFormField('Last Name'),
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
            decoration: _inputDecorationTextFormField('Email address'),
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
                if (value!.isEmpty || value.length < 6) {
                  return 'Password must be at least 6 characters long.';
                }
                return null;
              },
              obscureText: _obscuredPwd,
              style: inputTextStyle,
              decoration: InputDecoration(
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
          if (widget.isLoading) const CircularProgressIndicator(),
          if (!widget.isLoading)
            ElevatedButton(
              child: Text(_isLogin
                  ? (_resetPassword ? 'Reset Password' : 'Login')
                  : 'Sign up'),
              onPressed: _trySubmit,
            ),
          if (_isLogin)
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
                      fontSize: 17,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
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
