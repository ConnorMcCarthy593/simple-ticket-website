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
  List<Map<String, dynamic>>? _documentationData = [];
  bool _isLoading = true;
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  @override
  void initState() {
    super.initState();
    _docs_util = DocsUtil();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(), // Display a loading spinner
      );
    }

    return Scaffold(
      body: Row(
        children: [
          Flexible(
            flex: 1,
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(maxWidth: 300), // Prevent excessive expansion
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
          ),
          Flexible(
            // Change this from Expanded to Flexible
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
    if (mounted) {
      setState(() {
        _documentationData = _docs_util.documentationData;
        _isLoading = false;
      });
    }
  }
}

class Sidebar extends StatefulWidget {
  final List<Map<String, dynamic>> documentationData;
  final Function(int) onItemSelected;

  const Sidebar(
      {Key? key, required this.documentationData, required this.onItemSelected})
      : super(key: key);

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  String? _expandedKey;

  static const List<String> hierarchyLevels = [
    'Mode',
    'Theme',
    'Sub theme',
    'Table',
    'Class',
    'Object',
    'Method name',
    'Properties'
  ];

  String? _getNonEmptyValue(Map<String, dynamic> item, String key) {
    final value = item[key]?.toString().trim();
    return (value != null && value.isNotEmpty) ? value : null;
  }

  String _getEffectiveKey(
      Map<String, dynamic> item, int currentLevel, List<String> parentKeys) {
    for (int i = currentLevel; i < hierarchyLevels.length; i++) {
      final value = _getNonEmptyValue(item, hierarchyLevels[i]);
      if (value != null && !parentKeys.contains(value)) {
        return value;
      }
    }
    return '';
  }

  String _getNextValidKey(
      Map<String, dynamic> item, int startLevel, List<String> parentKeys) {
    for (int i = startLevel + 1; i < hierarchyLevels.length; i++) {
      final value = _getNonEmptyValue(item, hierarchyLevels[i]);
      if (value != null && value.length >= 2 && !parentKeys.contains(value)) {
        return value;
      }
    }
    return '';
  }

  bool _hasAnyValue(Map<String, dynamic> item) {
    return hierarchyLevels
        .any((level) => _getNonEmptyValue(item, level) != null);
  }

  Widget _buildListTile(
      BuildContext context, Map<String, dynamic> item, String title) {
    final bool isUnnamed = !_hasAnyValue(item);

    return ListTile(
      dense: true,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      title: Text(
        isUnnamed ? "Unnamed" : title,
        style: TextStyle(
          fontSize: 13,
          fontStyle: isUnnamed ? FontStyle.italic : FontStyle.normal,
          color: Theme.of(context)
              .colorScheme
              .onSurface
              .withOpacity(isUnnamed ? 0.6 : 0.87),
        ),
      ),
      subtitle: item['Description'] != null
          ? Text(
              item['Description'].toString(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            )
          : null,
      onTap: () =>
          widget.onItemSelected(widget.documentationData.indexOf(item)),
    );
  }

  ValueNotifier<Set<String>> _expandedKeysNotifier = ValueNotifier({});

  Widget _buildExpansionTile(String title, int currentLevel, List<Widget> children, String uniqueKey) {
    return ValueListenableBuilder<Set<String>>(
      valueListenable: _expandedKeysNotifier,
      builder: (context, expandedKeys, child) {
        return ExpansionTile(
          key: ValueKey(uniqueKey),
          initiallyExpanded: expandedKeys.contains(uniqueKey),
          onExpansionChanged: (isExpanded) {
            _expandedKeysNotifier.value = {
              ...expandedKeys,
              if (isExpanded) uniqueKey else ...expandedKeys.where((key) => key != uniqueKey),
            };
          },
          maintainState: true,
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: (16 - currentLevel).clamp(12, 16).toDouble(),
            ),
          ),
          tilePadding: EdgeInsets.only(
                left: 16.0 + (currentLevel * 8.0), right: 16.0
          ),
          children: [
            AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              child: expandedKeys.contains(uniqueKey)
                  ? Column(children: children) 
                  : SizedBox.shrink(),
            ),
          ],
        );
      }
    );
  }

  Widget _buildHierarchyLevel(
      BuildContext context,
      List<Map<String, dynamic>> items,
      int currentLevel,
      List<String> parentKeys) {
    if (currentLevel >= hierarchyLevels.length) return Container();

    var grouped = <String, List<Map<String, dynamic>>>{};
    var itemsToRegroup = <Map<String, dynamic>>[];
    var unnamedItems = <Map<String, dynamic>>[];

    // First pass: separate items into groups
    for (var item in items) {
      if (!_hasAnyValue(item)) {
        unnamedItems.add(item);
        continue;
      }

      String groupKey = _getEffectiveKey(item, currentLevel, parentKeys);

      if (groupKey.isEmpty || groupKey.length < 2) {
        itemsToRegroup.add(item);
      } else {
        grouped.putIfAbsent(groupKey, () => []).add(item);
      }
    }

    // Handle regrouping
    if (itemsToRegroup.isNotEmpty) {
      var subGroups = <String, List<Map<String, dynamic>>>{};

      for (var item in itemsToRegroup) {
        String nextKey = _getNextValidKey(item, currentLevel, parentKeys);
        if (nextKey.isNotEmpty) {
          subGroups.putIfAbsent(nextKey, () => []).add(item);
        } else {
          unnamedItems.add(item);
        }
      }

      subGroups.forEach((key, items) {
        if (grouped.containsKey(key)) {
          grouped[key]!.addAll(items);
        } else {
          grouped[key] = items;
        }
      });
    }

    var children = <Widget>[];

    // Add grouped items
    grouped.forEach((key, groupItems) {
      var newParentKeys = List<String>.from(parentKeys)..add(key);
      bool hasSubItems = groupItems.any((item) {
        return hierarchyLevels.skip(currentLevel + 1).any((level) =>
            _getEffectiveKey(
                    item, hierarchyLevels.indexOf(level), newParentKeys)
                .isNotEmpty);
      });

      String uniqueKey = '${currentLevel}_${key}_${newParentKeys.join("_")}';

      if (!hasSubItems || currentLevel == hierarchyLevels.length - 1) {
        children.add(Column(
          children: groupItems
              .map((item) => _buildListTile(context, item, key))
              .toList(),
        ));
      } else {
        children.add(_buildExpansionTile(
          key,
          currentLevel,
          [
            _buildHierarchyLevel(
                context, groupItems, currentLevel + 1, newParentKeys)
          ],
          uniqueKey,
        ));
      }
    });

    // Add unnamed items at the end
    if (unnamedItems.isNotEmpty) {
      children.add(Column(
        children: unnamedItems
            .map((item) => _buildListTile(context, item, "Unnamed"))
            .toList(),
      ));
    }

    return Column(children: children);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          right: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1.0,
          ),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search documentation...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: _buildHierarchyLevel(
                  context, widget.documentationData, 0, []),
            ),
          ),
        ],
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
                  Text('Theme: ${item['Theme']}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                if (item['Sub theme'] != null)
                  Text('Sub theme: ${item['Sub theme']}'),
                if (item['Table'] != null) Text('Table: ${item['Table']}'),
                if (item['Class'] != null) Text('Class: ${item['Class']}'),
                if (item['Object'] != null) Text('Object: ${item['Object']}'),
                if (item['Method name'] != null)
                  Text('Method: ${item['Method name']}'),
                if (item['Properties'] != null)
                  Text('Properties: ${item['Properties']}'),
                if (item['Description'] != null)
                  Text('Description: ${item['Description']}'),
                if (item['Inputs'] != null) Text('Inputs: ${item['Inputs']}'),
                if (item['Output'] != null) Text('Output: ${item['Output']}'),
                if (item['Type'] != null) Text('Type: ${item['Type']}'),
                if (item['Examples'] != null)
                  Text('Examples: ${item['Examples']}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
