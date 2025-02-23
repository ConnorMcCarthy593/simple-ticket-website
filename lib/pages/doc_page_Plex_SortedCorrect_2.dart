import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../util/docs_loader.dart';
import 'dart:collection';
import 'dart:math';


class DocsPage extends StatefulWidget {
  @override
  _DocsPageState createState() => _DocsPageState();
}

class _DocsPageState extends State<DocsPage> {
  late DocsUtil _docs_util;
  late List<Map<String, dynamic>>? _documentationData = [];
  late bool _is_loading = true;
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener = ItemPositionsListener.create();

  @override
  void initState() {
    super.initState();
    _docs_util = DocsUtil();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    if (_is_loading) {
      return Center(
        child: CircularProgressIndicator(), // Display a loading spinner
      );
    }

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Sidebar(
              documentationData: _documentationData!,
              onItemSelected: (index) {
                _itemScrollController.scrollTo(
                  index: index,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ),
          Expanded(
            flex: 3,
            child: DocumentationContent(
              documentationData: _documentationData!,
              itemScrollController: _itemScrollController,
              itemPositionsListener: _itemPositionsListener,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _init() async {
    await _docs_util.load_data_per_context();
    setState(() {
      _documentationData = _docs_util.documentationData;
      _is_loading = false;
    });
  }
}

class Sidebar extends StatelessWidget {
  final List<Map<String, dynamic>> documentationData;
  final Function(int) onItemSelected;

  Sidebar({required this.documentationData, required this.onItemSelected});

  // Helper function to get non-null value or null if empty string
  String? _getNonEmptyValue(Map<String, dynamic> item, String key) {
    final value = item[key]?.toString().trim();
    return (value != null && value.isNotEmpty) ? value : null;
  }

  // Helper function to find the first available name from the hierarchy
  String _getFirstAvailableName(Map<String, dynamic> item, int startLevel, List<String> levels) {
    for (int i = startLevel; i < levels.length; i++) {
      final value = _getNonEmptyValue(item, levels[i]);
      if (value != null) {
        return value;
      }
    }
    return "Untitled";
  }

  @override
  Widget build(BuildContext context) {
    // Define the hierarchy levels in order
    final levels = ['Mode', 'Theme', 'Sub theme', 'Table', 'Class', 'Object', 'Method name', 'Properties'];

    // Sort the data based on all levels.  IMPORTANT:  Remove this.  It sorts the entire documentation list.
    // var sortedData = List<Map<String, dynamic>>.from(documentationData);
    // sortedData.sort((a, b) {
    //   for (var level in levels) {
    //     final aValue = _getNonEmptyValue(a, level) ?? '';
    //     final bValue = _getNonEmptyValue(b, level) ?? '';
    //     final compareResult = aValue.compareTo(bValue);
    //     if (compareResult != 0) return compareResult;
    //   }
    //   return 0;
    // });

    String _getEffectiveKey(Map<String, dynamic> item, int currentLevel, List<String> parentKeys) {
      for (int i = currentLevel; i < levels.length; i++) {
        final value = _getNonEmptyValue(item, levels[i]);
        if (value != null && !parentKeys.contains(value)) {
          return value;
        }
      }
      return ''; // Return empty string if no valid key is found
    }

    Widget buildHierarchy(List<Map<String, dynamic>> items, int currentLevel, List<String> parentKeys) {
      if (currentLevel >= levels.length) return Container();

      final currentKey = levels[currentLevel];
      LinkedHashMap<String, List<Map<String, dynamic>>> grouped = LinkedHashMap();

      // Group items by current level, preserving original order
      for (int i = 0; i < items.length; i++) {
        var item = items[i];
        String groupKey = _getEffectiveKey(item, currentLevel, parentKeys);
        if (groupKey.isNotEmpty && !parentKeys.contains(groupKey)) {
          grouped.putIfAbsent(groupKey, () => []).add({'item': item, 'index': i});
        }
      }

      // If no groups were created at this level, move to next level
      if (grouped.isEmpty) {
        return buildHierarchy(items, currentLevel + 1, parentKeys);
      }

      // Build list of expansion tiles for this level
      return Column(
        children: grouped.entries.map((entry) {
          List<String> newParentKeys = List.from(parentKeys)..add(entry.key);

          final hasSubItems = entry.value.any((itemData) {
            var item = itemData['item'] as Map<String, dynamic>;
            return levels.skip(currentLevel + 1).any((level) =>
            _getEffectiveKey(item, levels.indexOf(level), newParentKeys).isNotEmpty);
          });

          // If this is the last level with content or no sub-items exist
          if (!hasSubItems || currentLevel == levels.length - 1) {
            // var sortedItems = List<Map<String, dynamic>>.from(entry.value)  //Not needed.  We retain order with the index.
            //   ..sort((a, b) => (a['index'] as int).compareTo(b['index'] as int));

            return Column(
              children: entry.value.map<Widget>((itemData) {   //entry.value is already sorted.
                var item = itemData['item'] as Map<String, dynamic>;
                return ListTile(
                  dense: true,
                  title: Text(
                    entry.key,
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.87),
                    ),
                  ),
                  subtitle: item['Description'] != null
                      ? Text(
                    item['Description'].toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  )
                      : null,
                  onTap: () => onItemSelected(documentationData.indexOf(item)),
                );
              }).toList(),
            );
          }

          return ExpansionTile(
            title: Text(
              entry.key,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: max(14 - currentLevel, 12).toDouble(),
              ),
            ),
            children: [buildHierarchy(
                entry.value.map((e) => e['item'] as Map<String, dynamic>).toList(),
                currentLevel + 1,
                newParentKeys
            )],
          );
        }).toList(),
      );
    }

    // In your build method:
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: SingleChildScrollView(
        child: buildHierarchy(documentationData, 0, []), //Pass in original documentation data.
      ),
    );
  }
}

class DocumentationContent extends StatelessWidget {
  final List<Map<String, dynamic>> documentationData;
  final ItemScrollController itemScrollController;
  final ItemPositionsListener itemPositionsListener;

  DocumentationContent({
    required this.documentationData,
    required this.itemScrollController,
    required this.itemPositionsListener,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.builder(
      itemScrollController: itemScrollController,
      itemPositionsListener: itemPositionsListener,
      itemCount: documentationData.length,
      itemBuilder: (context, index) {
        var item = documentationData[index];
        return Card(
          margin: EdgeInsets.all(8.0),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item['Mode'] != null) Text('Mode: ${item['Mode']}'),
                if (item['Theme'] != null)
                  Text('Theme: ${item['Theme']}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                if (item['Sub theme'] != null) Text('Sub theme: ${item['Sub theme']}'),
                if (item['Table'] != null) Text('Table: ${item['Table']}'),
                if (item['Class'] != null) Text('Class: ${item['Class']}'),
                if (item['Object'] != null) Text('Object: ${item['Object']}'),
                if (item['Method name'] != null) Text('Method: ${item['Method name']}'),
                if (item['Properties'] != null) Text('Properties: ${item['Properties']}'),
                if (item['Description'] != null) Text('Description: ${item['Description']}'),
                if (item['Inputs'] != null) Text('Inputs: ${item['Inputs']}'),
                if (item['Output'] != null) Text('Output: ${item['Output']}'),
                if (item['Type'] != null) Text('Type: ${item['Type']}'),
                if (item['Examples'] != null) Text('Examples: ${item['Examples']}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
