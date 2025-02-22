import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../util/docs_loader.dart';
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

  String _getDisplayName(Map<String, dynamic> item, List<String> levels, int startFromLevel) {
    for (int i = startFromLevel; i < levels.length; i++) {
      final value = _getNonEmptyValue(item, levels[i]);
      if (value != null) return value;
    }
    return "Untitled";
  }

  // Get all non-empty values for an item in hierarchical order
  List<MapEntry<String, String>> _getNonEmptyHierarchy(Map<String, dynamic> item) {
    final levels = ['Mode', 'Theme', 'Sub theme', 'Table', 'Class', 'Object', 'Method name', 'Properties'];
    return levels
        .map((level) => MapEntry(level, _getNonEmptyValue(item, level)))
        .where((entry) => entry.value != null)
        .map((entry) => MapEntry(entry.key, entry.value!))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final levels = ['Mode', 'Theme', 'Sub theme', 'Table', 'Class', 'Object', 'Method name', 'Properties'];
    
    // Group and organize the data
    Map<String, Map<String, List<Map<String, dynamic>>>> organizedData = {};

    Map<String, Map<String, List<Map<String, dynamic>>>> buildNestedStructure(
    List<Map<String, dynamic>> items, int currentLevel) {
      Map<String, Map<String, List<Map<String, dynamic>>>> organizedData = {};

      // Ensure we don't exceed the number of levels
      if (currentLevel >= levels.length) return organizedData;

      for (var item in items) {
        // Get the key based on the current level
        String key = _getNonEmptyValue(item, levels[currentLevel]) ?? '';

        // If the key is empty at this level, find the next non-empty level
        if (key.isEmpty) {
          key = _getDisplayName(item, levels, currentLevel + 1);
          // Store as leaf node if a key is found
          if (key.isNotEmpty) {
            // Add the item under the current level
            organizedData.putIfAbsent(key, () => {});
            organizedData[key]![levels[currentLevel + 1]] = [item];
          }
          continue;
        }

        // Add item to the list at the current level
        organizedData[key]![levels[currentLevel + 1]]!.add(item);

        // Recursively build children if there are more levels
        var children = buildNestedStructure([item], currentLevel + 1);
        if (children.isNotEmpty) {
          // Add the children under the current level
          organizedData[key]!.putIfAbsent('children', () => []);
          
          // Flatten the children into a List<Map<String, dynamic>>
          organizedData[key]!['children']!.addAll(children.values.expand((child) => child.entries.expand((e) => e.value)));
        }
      }

      return organizedData;
    }

    // Process each item
    for (var item in documentationData) {
      var hierarchy = _getNonEmptyHierarchy(item);
      if (hierarchy.isEmpty) continue;

      // Use the first level as the primary group
      var primaryLevel = hierarchy.first;
      String primaryKey = primaryLevel.value;

      // Use the last level as the sub-item name if there are multiple levels
      var lastLevel = hierarchy.last;
      String subKey = hierarchy.length > 1 ? lastLevel.value : primaryKey;

      // Organize the data
      organizedData.putIfAbsent(primaryKey, () => {});
      organizedData[primaryKey]!.putIfAbsent(subKey, () => []).add(item);
    }

    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: ListView.builder(
        itemCount: organizedData.length,
        itemBuilder: (context, index) {
          String primaryKey = organizedData.keys.elementAt(index);
          var subItems = organizedData[primaryKey]!;

          // If there's only one sub-item with the same name as the primary key,
          // just show it as a single item
          if (subItems.length == 1 && subItems.keys.first == primaryKey) {
            return ListTile(
              dense: true,
              title: Text(
                primaryKey,
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.87),
                ),
              ),
              subtitle: subItems.values.first.first['Description'] != null 
                ? Text(
                    subItems.values.first.first['Description'].toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  )
                : null,
              onTap: () => onItemSelected(
                documentationData.indexOf(subItems.values.first.first)
              ),
            );
          }

          // Otherwise, show as an expansion tile with sub-items
          return ExpansionTile(
            title: Text(
              primaryKey,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            children: subItems.entries.map((entry) {
              return ListTile(
                dense: true,
                title: Text(
                  entry.key,
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.87),
                  ),
                ),
                subtitle: entry.value.first['Description'] != null 
                  ? Text(
                      entry.value.first['Description'].toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    )
                  : null,
                onTap: () => onItemSelected(
                  documentationData.indexOf(entry.value.first)
                ),
              );
            }).toList(),
          );
        },
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