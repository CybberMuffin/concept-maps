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
  bool noSons;
  var arrow;

  checkSons(){
    print(sons[0]);
    if (sons[0].toString() == "Container") {
      noSons = true;
    } else {
      noSons = false;
    }
    return noSons;
  }

  arrowIcon(){
    if (rollUp == true) {
      arrow = Icons.arrow_right;
    } else if (rollUp == false && noSons == true) {
      arrow = Icons.arrow_left;
    } else if (rollUp == false){
      arrow = Icons.arrow_drop_down;
    }
    return arrow;
  }

  @override
  void initState(){
    super.initState();
    rollUp = false;
    noSons = checkSons();
    print(noSons);
    //arrow = arrowIcon();
  }


  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      //margin: EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(left: BorderSide(color:Colors.grey[400])),
      ),
      child: InkWell(
        onTap: (){
          setState(() {
            rollUp = !rollUp;
          });
        },
        child: Column(
          children: [

            Row(
                children:[
                  (rollUp == false && noSons == true) ? Container(margin: EdgeInsets.only(left: 35, bottom: 40),) : Icon((rollUp == true) ? Icons.arrow_right : Icons.arrow_drop_down,
                      size: 35)
                  ,
                  Flexible(
                    child: Text(title, style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
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

          ],
        ),
      ),
    );
  }

}