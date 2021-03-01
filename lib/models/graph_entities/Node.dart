

class Node{

  Node(this.id, this.color1, this.color2, this.child, this.parent, this.title, this.child_sum, this.depth);

  var id;
  var color1;
  var color2;
  var child;
  var parent;
  var title;
  var child_sum;
  var depth;
  var node_class;

  var x;
  var y;

  var xx;
  var yy;

  double get_x(){
    var n = x - 30.0;
    return n;
  }

  double get_y(){
    var n = y - 30.0;
    return n;
  }

  void add_x(var xx){
    this.x = xx;
  }

  void add_y(var yy){
    this.y = yy;
  }
}