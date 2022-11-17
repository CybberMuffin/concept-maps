import 'package:concept_maps/models/graph_entities/vertice.dart';
import 'package:concept_maps/providers/app_provider.dart';
import 'package:concept_maps/providers/user_provider.dart';
import 'package:concept_maps/utils/app_colors.dart';
import 'package:concept_maps/utils/date_time_formatter.dart';
import 'package:concept_maps/views/widgets/texts/main_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:provider/provider.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key key, @required this.currentMapConcepts})
      : super(key: key);

  final List<Vertice> currentMapConcepts;

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  Map<String, int> statistics = {};
  UserProvider _userProvider;

  @override
  void initState() {
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    statistics = _userProvider.getStatistics(widget.currentMapConcepts);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Builder(builder: (_) {
        final List<String> conceptNames = statistics.keys.toList();
        final List<int> conceptTimes = statistics.values.toList();
        return statistics.isNotEmpty
            ? Scrollbar(
                thickness: 4,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    child: Column(
                      children: List.generate(
                        conceptNames.length,
                        (index) => statisticsTile(
                          conceptNames[index],
                          conceptTimes[index],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : Center(child: MainText('You have no statistics yet'));
      }),
    );
  }

  Widget appBar(BuildContext context) => NewGradientAppBar(
        title: Text('Statistics'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        gradient: LinearGradient(colors: [kPurpleColor, kBreezeColor]),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      );

  Widget statisticsTile(String title, int time) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.3),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              DateTimeFormatter.getFormattedTime(
                time,
                true,
              ),
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
