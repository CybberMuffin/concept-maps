import 'package:concept_maps/models/graph_entities/node.dart';
import 'package:concept_maps/utils/date_time_formatter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatisticTile extends StatefulWidget {
  const StatisticTile({
    Key key,
    @required this.concept,
    @required this.time,
    @required this.barWidth,
  }) : super(key: key);

  final Node concept;
  final int time;
  final double barWidth;

  @override
  State<StatisticTile> createState() => _StatisticTileState();
}

class _StatisticTileState extends State<StatisticTile>
    with TickerProviderStateMixin {
  Animation animation;
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animation = Tween(begin: 0.0, end: widget.barWidth).animate(
        CurvedAnimation(curve: Curves.easeOut, parent: animationController));
    animationController.addListener(() {
      setState(() {});
    });
    if (widget.barWidth != 0) {
      animationController.forward();
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.concept.title,
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
                      widget.time,
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
          ),
          Container(
            width: animation.value,
            height: 40,
            decoration: BoxDecoration(
              color: widget.concept.defaultMainColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ],
      ),
    );
  }
}
