import 'package:concept_maps/models/graph_entities/vertice.dart';
import 'package:flutter/material.dart';

class Edge {
  Edge(this.v, this.u);

  Vertice v;
  Vertice u;
  Color edgeColor;
  
}
