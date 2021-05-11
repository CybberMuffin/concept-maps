import 'package:concept_maps/models/general_entities/thesis.dart';
import 'package:concept_maps/providers/app_provider.dart';
import 'package:concept_maps/views/text_templates/definition.dart';
import 'package:concept_maps/views/text_templates/democode.dart';
import 'package:concept_maps/views/text_templates/denotation.dart';
import 'package:concept_maps/views/text_templates/essence.dart';
import 'package:concept_maps/views/text_templates/note.dart';
import 'package:concept_maps/views/text_templates/tag.dart';
import 'package:concept_maps/views/text_templates/theses_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BottomPannel extends StatefulWidget {
  @override
  _BottomPannelState createState() => _BottomPannelState();
}

class _BottomPannelState extends State<BottomPannel> {
  Widget build(BuildContext context) {
    final provider = context.read<AppProvider>();

    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.only(left: 15, right: 15),
                margin: EdgeInsets.only(top: 5),
                child: Text(
                  provider.focusNode.title,
                  style: GoogleFonts.montserrat(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 15, right: 15),
              margin: EdgeInsets.only(bottom: 5),
              child: Divider(
                color: Colors.black,
                height: 20,
                thickness: 4.3,
                endIndent: 275,
              ),
            ),
            FutureBuilder<List<Thesis>>(
                future: provider.fetchThesesByConcept(
                  int.parse(provider.focusNode.id.toString()),
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final theses = snapshot.data;
                    return Column(
                      children: theses
                          .map<Widget>(
                            (thesis) => ThesisViewBuilder(
                              thesis: thesis,
                            ),
                          )
                          .toList(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Text(
                      snapshot.error.toString(),
                      style: TextStyle(color: Colors.red),
                    );
                  }

                  return CircularProgressIndicator();
                }),
          ],
        ),
      ),
    );
  }
}
