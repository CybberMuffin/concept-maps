import 'package:concept_maps/providers/app_provider.dart';
import 'package:concept_maps/providers/my_courses_provider.dart';
import 'package:concept_maps/utils/app_colors.dart';
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
        ChangeNotifierProvider<MyCoursesProvider>(create: (_) => MyCoursesProvider()),
      ],
      child: MaterialApp(
        title: "My Demo Media Query",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedItemColor: kBreezeColor,
            unselectedItemColor: kDeepSeaGreyColor,
          ),
          bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.black54.withOpacity(0)),
          textTheme: GoogleFonts.montserratTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: CourseMain(),
      ),
    );
  }
}
