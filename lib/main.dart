import 'package:concept_maps/providers/app_provider.dart';
import 'package:concept_maps/providers/user_provider.dart';
import 'package:concept_maps/utils/app_colors.dart';
import 'package:concept_maps/views/authorization/navigate_when_ready_load_screen.dart';
import 'package:concept_maps/views/authorization/login_screen.dart';
import 'package:concept_maps/views/course_main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppProvider>(create: (_) => AppProvider()),
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedItemColor: kBreezeColor,
            unselectedItemColor: kDeepSeaGreyColor,
          ),
          bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: Colors.black54.withOpacity(0)),
          textTheme: GoogleFonts.montserratTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: NavigateWhenReadyLoadScreen(
            callWhenReady: navigateAfterSilentAuthorization),
      ),
    );
  }

  Future<void> navigateAfterSilentAuthorization(BuildContext context) async {
    final result = await context.read<UserProvider>().authorizeSilently();
    await context.read<AppProvider>().getMarkViewedConceptsFlagFromPrefs();
    await context.read<UserProvider>().fetchUserLogs();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => result ? CourseMain() : LoginScreen()),
    );
  }
}
