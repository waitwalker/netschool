import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}
/// 文档 https://flutterchina.club/catalog/samples/expansion-tile-sample/
class _HomeState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("主页"),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) => EntryItem(data[index]),
        itemCount: data.length,
      ),
    );

  }
}

final List<Entry> data = <Entry>[
  Entry("Chapter A",
    <Entry>[
      Entry("Section A0",
        <Entry>[
          Entry("Item A0-1"),
          Entry("Item A0-2"),
          Entry("Item A0-3"),
        ],
      ),
      Entry("Section A1"),
      Entry("Section A2"),
    ],
  ),
  new Entry('Chapter B',
    <Entry>[
      new Entry('Section B0'),
      new Entry('Section B1'),
    ],
  ),
  new Entry('Chapter C',
    <Entry>[
      new Entry('Section C0'),
      new Entry('Section C1'),
      new Entry('Section C2',
        <Entry>[
          new Entry('Item C2.0'),
          new Entry('Item C2.1'),
          new Entry('Item C2.2'),
          new Entry('Item C2.3'),
        ],
      ),
    ],
  ),
];

class Entry {
  final String title;
  final List<Entry> children;
  Entry(this.title,[this.children = const<Entry>[]]);
}


class EntryItem extends StatelessWidget {

  final Entry entry;

  const EntryItem(this.entry);

  Widget _buildTitles(Entry root) {
    if (root.children.isEmpty) {
      return ListTile(title:  Text(root.title),);
    }
    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      title: Text(root.title),
      children: root.children.map(_buildTitles).toList(),
    );
  }


  @override
  Widget build(BuildContext context) {
    return _buildTitles(entry);
  }
}