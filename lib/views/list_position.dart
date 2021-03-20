import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:concept_maps/models/graph_entities/node.dart';

class ListPosition extends StatefulWidget {

  ListPosition({this.sons, this.title});

  List<Widget> sons;
  String title;

  @override
  _ListPositionState createState() => _ListPositionState(sons: this.sons, title: this.title);
}

class _ListPositionState extends State<ListPosition> {

  _ListPositionState({this.sons, this.title});

  bool rollUp;
  List<Widget> sons;
  String title;

  @override
  void initState(){
    super.initState();
    rollUp = false;
  }


  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        setState(() {
          rollUp = !rollUp;
        });
      },
      child: Column(
        children: [
          Row(
            children:[
              Icon((rollUp == true) ? Icons.arrow_right : Icons.arrow_drop_down,
                size: 35,),
              Flexible(
                child: Text(title, style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: (rollUp == true) ? FontWeight.w500 : FontWeight.w700,
            )),
              ),
          ]),
         Container(
           margin: EdgeInsets.only(left: 25),
           child: (rollUp == false) ? Column(
             children: sons.map((Widget son)
             {
               return son;
             }
             ).toList(),
           ) : Container(),
         ),
         /* ...sons.map((Widget son)
          {
            return son;
          }
          ).toList(), */
        ],
      ),
    );
  }

}