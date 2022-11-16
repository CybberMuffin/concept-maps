import 'package:concept_maps/providers/app_provider.dart';
import 'package:concept_maps/providers/user_provider.dart';
import 'package:concept_maps/utils/app_colors.dart';
import 'package:concept_maps/utils/date_time_formatter.dart';
import 'package:concept_maps/views/authorization/login_screen.dart';
import 'package:concept_maps/views/widgets/texts/main_text.dart';
import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:provider/provider.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key key}) : super(key: key);

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  Map<String, int> rawStatistics = {};

  @override
  void initState() {
    rawStatistics = context.read<UserProvider>().getStatistics();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: FutureBuilder(
        future: context
            .read<AppProvider>()
            .getConceptNamesByIds(rawStatistics.keys.toList()),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final List<String> conceptNames = snapshot.data;
            final List<int> conceptTimes = rawStatistics.values.toList();
            if (conceptNames?.isEmpty ?? true) {
              return Center(child: MainText('You have no statistics yet'));
            }
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: List.generate(
                    conceptNames.length,
                    (index) => Row(
                      children: [
                        Expanded(
                          child: Text(
                            conceptNames[index],
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            DateTimeFormatter.getFormattedTime(
                              conceptTimes[index],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return Center(child: CircularProgressIndicator(color: kBreezeColor));
        },
      ),
    );
  }

  Widget appBar(BuildContext context) => NewGradientAppBar(
        title: Text('Statistics'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        gradient: LinearGradient(colors: [kPurpleColor, kBreezeColor]),
        actions: [
          IconButton(
              onPressed: () => _logOut(context), icon: Icon(Icons.exit_to_app)),
        ],
      );

  void _logOut(BuildContext context) {
    context.read<UserProvider>().logOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }
}
