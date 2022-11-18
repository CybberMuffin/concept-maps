import 'package:concept_maps/models/graph_entities/node.dart';
import 'package:concept_maps/models/graph_entities/vertice.dart';
import 'package:concept_maps/providers/app_provider.dart';
import 'package:concept_maps/providers/user_provider.dart';
import 'package:concept_maps/utils/app_colors.dart';
import 'package:concept_maps/utils/date_time_formatter.dart';
import 'package:concept_maps/views/widgets/cards/statistics_tile.dart';
import 'package:concept_maps/views/widgets/texts/main_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:provider/provider.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key key, @required this.currentMapConcepts})
      : super(key: key);

  final List<Node> currentMapConcepts;

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  Map<Node, int> statistics = {};
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
        final List<Node> concepts = statistics.keys.toList();
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
                        concepts.length,
                        (index) => StatisticTile(
                          concept: concepts[index],
                          time: conceptTimes[index],
                          barWidthPercentage:
                              _userProvider.getStatisticBarWidthPercentage(
                                  conceptTimes[0], conceptTimes[index]),
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
}
