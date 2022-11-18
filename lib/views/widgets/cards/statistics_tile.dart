import 'package:concept_maps/models/graph_entities/node.dart';
import 'package:concept_maps/utils/date_time_formatter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatisticTile extends StatelessWidget {
  const StatisticTile({
    Key key,
    @required this.concept,
    @required this.time,
    @required this.barWidthPercentage,
  }) : super(key: key);

  final Node concept;
  final int time;
  final double barWidthPercentage;

  @override
  Widget build(BuildContext context) {
    print(barWidthPercentage);
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
                    concept.title,
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
          ),
          Container(
            width: MediaQuery.of(context).size.width * barWidthPercentage,
            height: 40,
            decoration: BoxDecoration(
              color: concept.defaultMainColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ],
      ),
    );
  }
}
