import 'package:concept_maps/providers/app_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BottomPannelLinear extends StatefulWidget {
  @override
  _BottomPannelLinearState createState() => _BottomPannelLinearState();
}

class _BottomPannelLinearState extends State<BottomPannelLinear> {
  Widget build(BuildContext context) {
    return Row(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: 340,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Text(
                        context.read<AppProvider>().focusNode.title,
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
                        Icon(Icons.brightness_1_rounded,
                            size: 8, color: Colors.black),
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
                        Icon(Icons.brightness_1_rounded,
                            size: 8, color: Colors.black),
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
                        Icon(Icons.brightness_1_rounded,
                            size: 8, color: Colors.black),
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
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Container(
                            child: TextButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                          (_) {
                                    return Colors.lightBlueAccent
                                        .withOpacity(0.2);
                                  }),
                                  padding: MaterialStateProperty.resolveWith<
                                      EdgeInsetsGeometry>((_) {
                                    return EdgeInsets.only(right: 32, left: 32);
                                  }),
                                  textStyle: MaterialStateProperty.resolveWith<
                                      TextStyle>((_) {
                                    return TextStyle(color: Colors.white);
                                  }),
                                  shape: MaterialStateProperty.resolveWith<
                                      OutlinedBorder>((_) {
                                    return RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    );
                                  }),
                                ),
                                //highlightColor: Colors.deepPurpleAccent,
                                onPressed: () {},
                                child: Text("TAG_01",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold))),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            child: TextButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                          (_) {
                                    return Colors.lightBlueAccent
                                        .withOpacity(0.2);
                                  }),
                                  padding: MaterialStateProperty.resolveWith<
                                      EdgeInsetsGeometry>((_) {
                                    return EdgeInsets.only(right: 32, left: 32);
                                  }),
                                  textStyle: MaterialStateProperty.resolveWith<
                                      TextStyle>((_) {
                                    return TextStyle(color: Colors.white);
                                  }),
                                  shape: MaterialStateProperty.resolveWith<
                                      OutlinedBorder>((_) {
                                    return RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    );
                                  }),
                                ),
                                child: Text("TAG_01",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold))),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            child: TextButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                          (_) {
                                    return Colors.lightBlueAccent
                                        .withOpacity(0.2);
                                  }),
                                  padding: MaterialStateProperty.resolveWith<
                                      EdgeInsetsGeometry>((_) {
                                    return EdgeInsets.only(right: 32, left: 32);
                                  }),
                                  textStyle: MaterialStateProperty.resolveWith<
                                      TextStyle>((_) {
                                    return TextStyle(color: Colors.white);
                                  }),
                                  shape: MaterialStateProperty.resolveWith<
                                      OutlinedBorder>((_) {
                                    return RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    );
                                  }),
                                ),
                                onPressed: () {},
                                child: Text("TAG_01",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold))),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Column(
            children: [
              InkWell(
                onTap: () {},
                child: Container(
                  child: Icon(
                    Icons.keyboard_arrow_up_rounded,
                    size: 40,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.only(top: 145),
                  child: Icon(
                    Icons.keyboard_arrow_down_outlined,
                    size: 40,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
