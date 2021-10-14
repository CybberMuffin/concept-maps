import 'package:concept_maps/constants/general.dart';
import 'package:concept_maps/providers/user_provider.dart';
import 'package:concept_maps/utils/app_colors.dart';
import 'package:concept_maps/utils/gradient_decorations.dart';
import 'package:concept_maps/views/course_main.dart';
import 'package:concept_maps/views/widgets/butttons/gradient_button.dart';
import 'package:concept_maps/views/widgets/textfields/semantic_textfield.dart';
import 'package:concept_maps/views/widgets/texts/gradient_text.dart';
import 'package:concept_maps/views/widgets/texts/main_text.dart';
import 'package:concept_maps/views/widgets/texts/secondary_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> _formKey = GlobalKey();
  bool _validate = false;
  bool switcherS = false;
  Widget _instructionsText;
  TextEditingController _loginController = TextEditingController();
  TextEditingController _passController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _instructionsText = SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final logoImage = SizedBox(
      width: screenWidth * 0.2,
      child: Image.asset('assets/images/roborubik_1.png'),
    );

    final title = Container(
      margin: EdgeInsets.only(
        top: screenHeight * 0.03,
      ),
      child: MainText("Semantic Portal".toUpperCase()),
    );

    final instructions = Container(
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.03,
      ),
      child: _instructionsText,
    );

    final emailField = Container(
      margin: EdgeInsets.only(
        top: screenHeight * 0.02,
      ),
      child: SemanticTextField(
        controller: _loginController,
        label: 'Login',
        keyboardType: TextInputType.emailAddress,
        validator: (value) => _validateField(value),
      ),
    );

    final pinField = Container(
      margin: EdgeInsets.only(
        top: screenHeight * 0.02,
      ),
      child: SemanticTextField(
        controller: _passController,
        label: 'Password',
        keyboardType: TextInputType.visiblePassword,
        validator: (value) => _validateField(value),
      ),
    );

    final submitButton = Container(
      margin: EdgeInsets.only(
        top: screenHeight * 0.03,
      ),
      width: double.infinity,
      child: GradientButton(
        text: 'Sign In',
        gradientDecorations: GradientDecorations.mainGradientDecoration,
        onPressed: _submitForm,
      ),
    );

    final accountAbsenceQuestion = Container(
      margin: EdgeInsets.only(
        top: screenHeight * 0.05,
      ),
      child: SecondaryText(
        "No account yet?",
        small: true,
      ),
    );

    final signUpTextButton = Container(
      margin: EdgeInsets.only(top: screenHeight * 0.01),
      child: GestureDetector(
        child: GradientText(
          "SIGN UP".toUpperCase(),
          gradient: GradientDecorations.mainGradientReversed,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        onTap: () => _launchURL(kRegisterUrl),
      ),
    );

    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Form(
          key: _formKey,
          autovalidateMode: _validate ? AutovalidateMode.always : AutovalidateMode.disabled,
          child: Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    logoImage,
                    title,
                    instructions,
                    emailField,
                    pinField,
                    submitButton,
                    accountAbsenceQuestion,
                    signUpTextButton,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _validateField(String value) {
    if (value.trim().isEmpty) {
      return "The field shouldn't be empty";
    }
    return null;
  }

  bool _confirmData() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      return true;
    } else {
      setState(() => _validate = true);
      return false;
    }
  }

  void _launchURL(String url) async => await canLaunch(url) ? await launch(url) : null;

  void _submitForm() async {
    if (_confirmData()) {
      final userProvider = context.read<UserProvider>();

      FocusScope.of(context).unfocus();
      _onLoad();
      await userProvider.authorizeUser(_loginController.text, _passController.text)
          ? _onSuccessAction()
          : _onErrorAction();
    }
  }

  void _onSuccessAction() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => CourseMain()),
    );
  }

  void _onErrorAction() {
    setState(
      () => _instructionsText = SecondaryText(
        "Wrong Credentials",
        error: true,
        small: true,
      ),
    );
  }

  void _onLoad() {
    setState(() => _instructionsText = CircularProgressIndicator(color: kBreezeColor));
  }

  // void setDefaultScreen() {
  //   FocusScope.of(context).unfocus();
  //   _formKey.currentState.reset();
  //   _emailController.clear();
  //   _pinController.clear();
  //   _instructionsText = SizedBox.shrink();
  //   setState(() => _validate = false);
  // }

  // Future _setUserSettings() async {
  //   final up = context.read<UserProvider>();
  //   final result = await up.retreiveUserDetails(withMeds: true);
  //   context.read<MedicineProvider>().userMedicine = result;

  //   context.locale = langToLocale[up.user.language];

  //   locator<NotificationService>().updateMedicineNotifications(up.user.notificationMedicine).then((_) =>
  //       (up.user.receiveNotifications ?? true)
  //           ? locator<NotificationService>().showNotification()
  //           : locator<NotificationService>().stopNotification());
  // }
}
