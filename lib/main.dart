import 'package:flutter/material.dart';
import 'models/graph_entities/Node.dart';
import 'models/graph_entities/Concept.dart';
import 'models/graph_entities/PaintGraph.dart';
import 'models/graph_entities/Relations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:zoom_widget/zoom_widget.dart';

void main() {
  runApp(new MaterialApp(
      home: new HomePage()
  )
  );
}

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Node> three = List<Node>();
  List<Widget> button2 = List<Widget>();
  Widget buttons;

  List<Widget> titles2 = List<Widget>();
  Widget titles;

  var res;
  var cons;

  Future relFuture;

  parse() async {
    String url = "http://semantic-portal.net/api/branch/dart/concepts/relations";
    String concepts_url = "http://semantic-portal.net/api/branch/dart/concepts";

    final response = await http.get(url);
    final concepts_response = await http.get(concepts_url);

    print(response.body);
    print(concepts_response.body);
    if (response.statusCode == 200 && concepts_response.statusCode == 200){
      var decode_res = jsonDecode(response.body);
      var raw_list = decode_res as List;
      var relations_list = raw_list.map<Relation>((json) => Relation.fromJson(json)).toList();

      var decode_cons = jsonDecode(concepts_response.body);
      var cons_raw_list = decode_cons as List;
      var concepts_list = cons_raw_list.map<Concept>((json) => Concept.fromJson(json)).toList();

      res = relations_list;
      cons = concepts_list;
      //print(response.body);
    }
    else{
      print("error");
    }

  }

  void relationToNodes(List<Relation> relations, List<Concept> concepts){
    three.clear();
    var root = relations[0].to_concept_id;
    var raw_childs = relations.where((a) => a.to_concept_id == relations[0].to_concept_id);
    var childs = raw_childs.map((a)=>a.concept_id).toList();

    print(relations[0].to_concept_id);
    three.add(Node(relations[0].to_concept_id, Colors.deepPurple, Colors.deepPurple, childs, -1, concepts[concepts.indexWhere((element) => element.id == relations[0].to_concept_id)].concept, childs.length, 0));
    relations.forEach((element) {
      raw_childs = relations.where((a) => a.to_concept_id == element.concept_id);
      childs = raw_childs.map((a)=>a.concept_id).toList();
      //print(element.concept_id);
      //print(childs);
      var parent = element.to_concept_id;
      three.add(Node(element.concept_id, Colors.deepPurple, Colors.deepPurple, childs, parent, concepts[concepts.indexWhere((a) => a.id == element.concept_id)].concept, childs.length, 0));
    });

    concepts.forEach((element) {

      if(element.isAspect == "1"){
        if(three.indexWhere((a) => a.id == element.aspectOf) == -1){
          findRelInNode(element);
        }

        three.add(Node(element.id, Colors.deepPurple, Colors.deepPurple, [], element.aspectOf, element.concept, childs.length, 0));
        three[three.indexWhere((a) => a.id == element.aspectOf)].child.add(element.id);
        three[three.indexWhere((a) => a.id == element.aspectOf)].child_sum++;
      }
    });

  }

  findRelInNode(Concept element){
    Concept cons_parent = cons[cons.indexWhere((a) => a.id == element.aspectOf)];
    if(three.indexWhere((a) => a.id == cons_parent.aspectOf) == -1){
      findRelInNode(cons_parent);
    }


    three.add(Node(cons_parent.id, Colors.deepPurple, Colors.deepPurple, [], cons_parent.aspectOf, cons_parent.concept, 0, 0));
    three[three.indexWhere((a) => a.id == cons_parent.aspectOf)].child.add(cons_parent.id);
    three[three.indexWhere((a) => a.id == cons_parent.aspectOf)].child_sum++;
  }

  addButtons(List<Node> new_three){
    var x;
    var y;
    new_three.forEach((element) {
      if(element.x == null){
        element.x = 100.0;
      }
      if(element.y == null){
        element.y = 100.0;
      }

      x = element.x - 30;
      y = element.y - 30;
      buttons2.add(new Positioned(
        top: y,
        left: x,
          child: GestureDetector(
            onTap: (){print(123);},
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                  //color: Colors.red,
                  borderRadius: BorderRadius.circular(30)
              ),
            ),
          )
      ));

      TextPainter textPainter = TextPainter(
          text: TextSpan(text: element.title), maxLines: 1, textDirection: TextDirection.ltr)
        ..layout(minWidth: 0, maxWidth: double.infinity);
      var textWidth = textPainter.width/2;

      x = element.x - textWidth;
      y = element.y + 35;
      titles2.add(new Positioned(
          top: y,
          left: x,
          child: Text(element.title),
      ));
    });
    buttons = new Stack(children: buttons2);
    titles = new Stack(children: titles2);
  }

  @override
  void initState() {
    /*
    three = <Node>[ Node(0 ,Colors.deepPurple, Colors.deepPurpleAccent, [1, 2, 7], -1, "Test0", 3, 0),
          Node(1 ,Colors.deepPurple, Colors.deepPurpleAccent, [3, 4, 8], 0, "Test1", 3, 1),
          Node(2 ,Colors.deepPurple, Colors.deepPurpleAccent, [5, 6], 0, "Test2", 2, 1),
          Node(3 ,Colors.deepPurple, Colors.deepPurpleAccent, [], 1, "Test3", 0, 2),
          Node(4 ,Colors.deepPurple, Colors.deepPurpleAccent, [11, 12], 1, "Test4", 0, 2),
          Node(5 ,Colors.deepPurple, Colors.deepPurpleAccent, [], 2, "Test5", 0, 2),
          Node(6 ,Colors.deepPurple, Colors.deepPurpleAccent, [9], 2, "Test6", 0, 2),
          Node(7 ,Colors.deepPurple, Colors.deepPurpleAccent, [10], 0, "Test7", 0, 1),
          Node(8 ,Colors.deepPurple, Colors.deepPurpleAccent, [], 1, "Test8", 1, 2),
          Node(9 ,Colors.deepPurple, Colors.deepPurpleAccent, [], 6, "Test8", 1, 2),
          Node(10 ,Colors.deepPurple, Colors.deepPurpleAccent, [], 7, "Test10", 0, 2),
          Node(11 ,Colors.deepPurple, Colors.deepPurpleAccent, [], 4, "Test8", 1, 2),
          Node(12 ,Colors.deepPurple, Colors.deepPurpleAccent, [], 4, "Test8", 1, 2),
        ];
     */
    //parse().then((value) => relationToNodes(value));
    relFuture = parse();
    super.initState();
  }


  @override
  Widget build(BuildContext context){
    return new Scaffold(
      body: Container(
        child: Zoom(
            width: 3000,
            height: 3000,
            centerOnScale: true,
            onPositionUpdate: (Offset position){

            },
            onScaleUpdate: (double scale,double zoom){

            },
          child: FutureBuilder(
            future: relFuture,
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.done){
                print(snapshot.data);
                relationToNodes(res, cons);
                return Stack(
                  children: [
                    Positioned(
                        child: CustomPaint(
                          painter: PaintGraph(three, addButtons),
                        )
                    ),

                    Positioned(
                        child: buttons
                    ),
                    Positioned(
                        child: titles
                    )

                  ],
                );
              }
              else{
                return Text("load");
              }
            },
          )
        )
      ),
    );
  }
}