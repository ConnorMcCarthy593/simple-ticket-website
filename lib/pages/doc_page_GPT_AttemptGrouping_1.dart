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

  @override
  Widget build(BuildContext context) {
    // Define the hierarchy levels in order
    final levels = ['Mode', 'Theme', 'Sub theme', 'Table', 'Class', 'Object', 'Method name', 'Properties'];
    
    // Sort the data based on all levels
    var sortedData = List<Map<String, dynamic>>.from(documentationData);
    sortedData.sort((a, b) {
      for (var level in levels) {
        final compareResult = (_getNonEmptyValue(a, level) ?? '')
            .compareTo(_getNonEmptyValue(b, level) ?? '');
        if (compareResult != 0) return compareResult;
      }
      return 0;
    });

    // Recursively build the hierarchy
    Widget buildHierarchy(List<Map<String, dynamic>> items, int currentLevel) {
      if (currentLevel >= levels.length) return Container();

      final currentKey = levels[currentLevel];
      Map<String, List<Map<String, dynamic>>> grouped = {};

      // Group items by current level
      for (var item in items) {
        final value = _getNonEmptyValue(item, currentKey);
        if (value != null) {
          grouped.putIfAbsent(value, () => []).add(item);
        }
      }

      // If no groups were created at this level, move to next level
      if (grouped.isEmpty) {
        return buildHierarchy(items, currentLevel + 1);
      }

      // Build list of expansion tiles for this level
      return Column(
        children: grouped.entries.map((entry) {
          final hasSubItems = entry.value.any((item) {
            return levels.skip(currentLevel + 1).any((level) => 
              _getNonEmptyValue(item, level) != null);
          });

          // If this is the last level with content or no sub-items exist
          if (!hasSubItems || currentLevel == levels.length - 1) {
            return ListTile(
              dense: true,
              title: Text(
                entry.key,
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.87),
                ),
              ),
              onTap: () => onItemSelected(
                documentationData.indexOf(entry.value.first)
              ),
            );
          }

          return ExpansionTile(
            title: Text(
              entry.key,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14.0 - currentLevel,
              ),
            ),
            children: [buildHierarchy(entry.value, currentLevel + 1)],
          );
        }).toList(),
      );
    }

    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: SingleChildScrollView(
        child: buildHierarchy(sortedData, 0),
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