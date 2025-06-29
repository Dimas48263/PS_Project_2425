import 'package:flutter/material.dart';
import 'package:zcap_net_app/core/services/remote_table.dart';

Widget buildListView<T extends IsarTable>(
  List<T> list,
  List<List<String>> labelsList,
  void Function(T) onSync,
  void Function(T) onEdit,
  Future<void> Function(T) onDelete,
) {
  return Expanded(
    child: ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        final labels = labelsList[index];

        return Card(
          child: ListTile(
            contentPadding: const EdgeInsets.only(left: 10.0),
            title: Text(labels[0],
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 1; i < labels.length; i++) Text(labels[i]),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!item.isSynced)
                  IconButton(
                    onPressed: () => onSync(item),
                    icon: const Icon(Icons.sync_problem,
                        color: Colors.orange, size: 30),
                  ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => onEdit(item),
                ),
                IconButton(
                  onPressed: () => onDelete(item),
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

class CustomElementListView<T extends IsarTable> {
  T element;
  String title;
  List<List<String>> labels;
  CustomElementListView(this.element, this.title, this.labels);
}
//          1 collumn                    2 collumn
//[[name, category, start, end], [name, category, start, end]]

Widget buildListViewV2<T extends IsarTable>(
    List<CustomElementListView> list,
    void Function(T) onSync,
    void Function(T) onEdit,
    Future<void> Function(T) onDelete) {
  return Expanded(
    child: ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];

        return Card(
          child: ListTile(
            contentPadding: const EdgeInsets.only(left: 10.0),
            title: Text(item.title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    for (var col in item.labels)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var str in col) Text(str),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!item.element.isSynced)
                  IconButton(
                    onPressed: () => onSync(item.element as T),
                    icon: const Icon(Icons.sync_problem,
                        color: Colors.orange, size: 30),
                  ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => onEdit(item.element as T),
                ),
                IconButton(
                  onPressed: () => onDelete(item.element as T),
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
