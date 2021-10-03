import 'package:concept_maps/models/courses/branch.dart';
import 'package:concept_maps/utils/app_colors.dart';
import 'package:flutter/material.dart';

const Map<int, Color> _levelColors = {
  0: kPurpleColor,
  1: kGreyBlueColor,
  2: kBreezeColor,
};

class ExpandableBranchTile extends StatefulWidget {
  final Branch branch;
  final int level;
  ExpandableBranchTile({Key key, @required this.branch, this.level = 0}) : super(key: key);

  @override
  _ExpandableBranchTileState createState() => _ExpandableBranchTileState();
}

class _ExpandableBranchTileState extends State<ExpandableBranchTile> {
  bool isOpen = false;

  Branch get _branch => widget.branch;
  Color get _branchColor => _levelColors[widget.level % 3];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          left: BorderSide(
            color: _branchColor,
            width: 3,
          ),
        ),
      ),
      child: GestureDetector(
        onTap: () => setState(() => isOpen = !isOpen),
        child: Column(
          children: [
            Row(
              children: [
                _branch.endBranch
                    ? Container(
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _levelColors[(widget.level + 1) % 3],
                          shape: BoxShape.circle,
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Icon(
                          isOpen ? Icons.arrow_drop_down : Icons.arrow_right,
                          size: 35,
                          color: _branchColor,
                        ),
                      ),
                Flexible(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: Text(
                      _branch.caption,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 24),
              child: isOpen
                  ? Column(
                      children: _branch.children
                          .map((branch) => ExpandableBranchTile(
                                branch: branch,
                                level: widget.level + 1,
                              ))
                          .toList(),
                    )
                  : SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
