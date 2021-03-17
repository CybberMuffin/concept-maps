import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomPannel extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _BottomPannelState createState() => _BottomPannelState();
}

class _BottomPannelState extends State<BottomPannel> {
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.only(top: 28),
              child: Text(
                "CONCEPT_01",
                style: GoogleFonts.montserrat(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.black,
            height: 20,
            thickness: 4.3,
            endIndent: 275,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.only(top: 5),
              child: Text(
                "Lorem ipsum dolor sit amet, consecte adipiscing elit, sed do eiusmod.",
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 11, left: 15),
            child: Row(
              children: [
                Icon(Icons.brightness_1_rounded, size: 8, color: Colors.black),
                Container(
                  margin: EdgeInsets.only(left: 15),
                  child: Text(
                    "Lorem ipsum dolor.",
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 11, left: 15),
            child: Row(
              children: [
                Icon(Icons.brightness_1_rounded, size: 8, color: Colors.black),
                Container(
                  margin: EdgeInsets.only(left: 15),
                  child: Text(
                    "Ut enim ad minima veniam.",
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 11, left: 15),
            child: Row(
              children: [
                Icon(Icons.brightness_1_rounded, size: 8, color: Colors.black),
                Container(
                  margin: EdgeInsets.only(left: 15),
                  child: Text(
                    "Duis aute irure dolor.",
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.only(top: 11),
              child: Text(
                "Lorem ipsum dolor sit amet, consectet adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.",
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Row(children: [
              Container(
                child: FlatButton(
                    color: Colors.lightBlueAccent.withOpacity(0.2),
                    padding: EdgeInsets.only(right: 32, left: 32),
                    //highlightColor: Colors.deepPurpleAccent,
                    onPressed: () {},
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    child: Text("TAG_01",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold))),
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: FlatButton(
                    color: Colors.lightBlueAccent.withOpacity(0.2),
                    padding: EdgeInsets.only(right: 32, left: 32),
                    //highlightColor: Colors.deepPurpleAccent,
                    onPressed: () {},
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    child: Text("TAG_01",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold))),
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: FlatButton(
                    color: Colors.lightBlueAccent.withOpacity(0.2),
                    padding: EdgeInsets.only(right: 32, left: 32),
                    //highlightColor: Colors.deepPurpleAccent,
                    onPressed: () {},
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    child: Text("TAG_01",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold))),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
