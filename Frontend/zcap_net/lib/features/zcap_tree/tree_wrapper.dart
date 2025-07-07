import 'package:zcap_net_app/features/settings/models/trees/tree/tree_isar.dart';

//wrapper to allow zcap count on zcap tree screen
class TreeWrapper {
  final TreeIsar tree;
  final int zcapCount;

  TreeWrapper(this.tree, this.zcapCount);
}