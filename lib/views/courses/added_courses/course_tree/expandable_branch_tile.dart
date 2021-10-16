import 'package:concept_maps/models/courses/branch.dart';
import 'package:concept_maps/providers/app_provider.dart';
import 'package:concept_maps/providers/user_provider.dart';
import 'package:concept_maps/utils/app_colors.dart';
import 'package:concept_maps/views/authorization/navigate_when_ready_load_screen.dart';
import 'package:concept_maps/views/courses/added_courses/lecture_content_screen/lecture_content_screen.dart';
import 'package:concept_maps/views/force_directed.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

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
  Color get _branchColor => levelColors[widget.level % 3];
  Color get _nextBranchColor => levelColors[(widget.level + 1) % 3];

  Widget get leadingIcon => _branch.endBranch
      ? Padding(
          padding: const EdgeInsets.only(top: 7, left: 16, right: 12),
          child: Icon(
            Icons.circle,
            size: 16,
            color: _nextBranchColor,
          ),
        )
      : Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Icon(
            isOpen ? Icons.arrow_drop_down : Icons.arrow_right,
            size: 35,
            color: _nextBranchColor,
          ),
        );

  Widget get trailingIcon => Align(
        alignment: Alignment.topRight,
        child: IconButton(
          onPressed: onMapTap,
          icon: Icon(
            Icons.map_outlined,
            color: _nextBranchColor,
          ),
        ),
      );

  Widget get title => Text(
        _branch.caption,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      );

  Widget get tile => Padding(
        padding: _branch.endBranch ? EdgeInsets.symmetric(vertical: 4) : EdgeInsets.zero,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            leadingIcon,
            Flexible(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                title: title,
                subtitle: _branch.intro != null ? Text(_branch.intro) : null,
                onTap: onBranchTileTap,
              ),
            ),
            trailingIcon,
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          left: BorderSide(
            color: _branchColor,
            width: 3,
          ),
        ),
      ),
      child: Column(
        children: [
          tile,
          Container(
            margin: EdgeInsets.only(left: 16),
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
    );
  }

  void onBranchTileTap() {
    if (_branch.endBranch) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LectureContentScreen(branch: _branch),
        ),
      );
    } else {
      setState(() => isOpen = !isOpen);
    }
  }

  void onMapTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NavigateWhenReadyLoadScreen(callWhenReady: navigateAfterMapLoaded),
      ),
    );
  }

  Future<void> navigateAfterMapLoaded(BuildContext context) async {
    final appProvider = context.read<AppProvider>();
    final result = await appProvider.fetchMapByBranch(_branch.view);
    if (result.field == _branch.view) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ForceDirected(title: _branch.caption)),
      );
    } else {
      Navigator.pop(context);
    }
  }
}
