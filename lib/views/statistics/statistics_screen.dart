import 'package:concept_maps/models/graph_entities/node.dart';
import 'package:concept_maps/providers/user_provider.dart';
import 'package:concept_maps/utils/app_colors.dart';
import 'package:concept_maps/utils/date_time_formatter.dart';
import 'package:concept_maps/views/widgets/cards/statistics_tile.dart';
import 'package:concept_maps/views/widgets/texts/main_text.dart';
import 'package:fl_chart/fl_chart.dart';
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
  Map<Node, int> topFiveStatistics = {};
  List<Node> concepts = [];
  List<int> conceptTimes = [];
  UserProvider _userProvider;
  ScrollController scrollController = ScrollController();
  bool isTop = false;
  bool showFab = true;
  int touchedIndex = -1;
  int allTimeOnMapInSeconds = 0;

  @override
  void initState() {
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    statistics = _userProvider.getStatistics(widget.currentMapConcepts);
    topFiveStatistics = _userProvider.getTopFiveStatistics(statistics);
    concepts = statistics.keys.toList();
    conceptTimes = statistics.values.toList();
    conceptTimes.forEach((time) {
      allTimeOnMapInSeconds += time;
    });
    scrollController.addListener(scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: topFiveStatistics.length > 4
          ? Visibility(
              visible: showFab,
              child: TopFiveButton(
                isTop: isTop,
                onPressed: () {
                  setState(() {
                    isTop = !isTop;
                  });
                },
              ),
            )
          : const SizedBox(),
      appBar: appBar(context),
      body: Builder(builder: (_) {
        return statistics.isNotEmpty
            ? !isTop
                ? Scrollbar(
                    controller: scrollController,
                    thickness: 4,
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        child: Column(
                          children: List.generate(
                            concepts.length,
                            (index) => StatisticTile(
                              concept: concepts[index],
                              time: conceptTimes[index],
                              barWidth: MediaQuery.of(context).size.width *
                                  _userProvider.getStatisticBarWidthPercentage(
                                      conceptTimes[0], conceptTimes[index]),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : topFivePieChart()
            : Center(child: MainText('You have no statistics yet'));
      }),
    );
  }

  Center topFivePieChart() {
    final List<Node> concepts = topFiveStatistics.keys.toList();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(
              text: 'Total time spent on map: ',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(
                  text:
                      '${DateTimeFormatter.getFormattedTime(allTimeOnMapInSeconds)}',
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (pieTouchResponse) {
                  setState(() {
                    if (pieTouchResponse.touchInput is FlLongPressEnd ||
                        pieTouchResponse.touchInput is FlPanEnd) {
                      touchedIndex = -1;
                    } else {
                      touchedIndex = pieTouchResponse.touchedSectionIndex;
                    }
                  });
                },
              ),
              borderData: FlBorderData(
                show: false,
              ),
              sectionsSpace: 0,
              centerSpaceRadius: 40,
              sections: showingSections(),
            ),
          ),
          FittedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Indicator(
                  color: Color(0xff0293ee),
                  text: concepts[0].title,
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Color(0xfff8b250),
                  text: concepts[1].title,
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Color(0xff845bef),
                  text: concepts[2].title,
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Color(0xff13d38e),
                  text: concepts[3].title,
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Color(0xfff46d75),
                  text: concepts[4].title,
                  isSquare: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    int maxTime = allTimeOnMapInSeconds;
    return List.generate(5, (i) {
      final isTouched = i == touchedIndex;
      final currentPercentage = (conceptTimes[i] * 100 / maxTime).round();
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: currentPercentage.toDouble(),
            title: '$currentPercentage%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: currentPercentage.toDouble(),
            title: '$currentPercentage%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff845bef),
            value: currentPercentage.toDouble(),
            title: '$currentPercentage%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xff13d38e),
            value: currentPercentage.toDouble(),
            title: '$currentPercentage%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
          );
        case 4:
          return PieChartSectionData(
            color: const Color(0xfff46d75),
            value: currentPercentage.toDouble(),
            title: '$currentPercentage%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
          );
        default:
          throw Error();
      }
    });
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

  void scrollListener() {
    if (showFab &&
        scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
      setState(() {
        showFab = false;
      });
    } else if (!showFab) {
      setState(() {
        showFab = true;
      });
    }
  }
}

class TopFiveButton extends StatelessWidget {
  const TopFiveButton({
    Key key,
    @required this.isTop,
    @required this.onPressed,
  }) : super(key: key);

  final bool isTop;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((_) {
            return kBreezeColor;
          }),
          padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry>((_) {
            return EdgeInsets.all(14);
          }),
          shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
            return RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            );
          }),
        ),
        onPressed: onPressed,
        child: Text(
          !isTop ? 'Top 5' : 'All',
          style: GoogleFonts.montserrat(
            fontSize: 18,
            color: kWhite,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key key,
    this.color,
    this.text,
    this.isSquare,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
        )
      ],
    );
  }
}
