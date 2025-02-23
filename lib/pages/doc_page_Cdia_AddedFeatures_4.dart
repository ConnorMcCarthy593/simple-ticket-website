import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../util/docs_loader.dart';
import 'dart:collection';
import 'dart:math';
import 'package:flutter/services.dart';


class DocsPage extends StatefulWidget {
  @override
  _DocsPageState createState() => _DocsPageState();
}

class _DocsPageState extends State<DocsPage> {
  late DocsUtil _docs_util;
  late List<Map<String, dynamic>>? _documentationData = [];
  late bool _is_loading = true;
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
    setState(() {
      _documentationData = _docs_util.documentationData;
      _is_loading = false;
    });
  }
}


class Sidebar extends StatefulWidget {
  final List<Map<String, dynamic>> documentationData;
  final Function(int) onItemSelected;

  const Sidebar({
    Key? key, 
    required this.documentationData, 
    required this.onItemSelected
  }) : super(key: key);

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  String? _expandedKey;
  bool _isSearching = false;
  String _searchQuery = '';
  List<String> _recentlyViewed = [];
  bool _showRecentlyViewed = false;
  Set<String> _favorites = {};
  bool _showFavorites = false;
  bool _isCompactMode = false;

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

  String _getEffectiveKey(Map<String, dynamic> item, int currentLevel, List<String> parentKeys) {
    for (int i = currentLevel; i < hierarchyLevels.length; i++) {
      final value = _getNonEmptyValue(item, hierarchyLevels[i]);
      if (value != null && !parentKeys.contains(value)) {
        return value;
      }
    }
    return '';
  }

  String _getNextValidKey(Map<String, dynamic> item, int startLevel, List<String> parentKeys) {
    for (int i = startLevel + 1; i < hierarchyLevels.length; i++) {
      final value = _getNonEmptyValue(item, hierarchyLevels[i]);
      if (value != null && value.length >= 2 && !parentKeys.contains(value)) {
        return value;
      }
    }
    return '';
  }

  bool _hasAnyValue(Map<String, dynamic> item) {
    return hierarchyLevels.any((level) => 
      _getNonEmptyValue(item, level) != null
    );
  }

  void _toggleFavorite(String itemId) {
    setState(() {
      if (_favorites.contains(itemId)) {
        _favorites.remove(itemId);
      } else {
        _favorites.add(itemId);
      }
    });
  }

  void _addToRecentlyViewed(String itemId) {
    setState(() {
      _recentlyViewed.remove(itemId);
      _recentlyViewed.insert(0, itemId);
      if (_recentlyViewed.length > 10) {
        _recentlyViewed.removeLast();
      }
    });
  }

  Widget _buildBreadcrumbNav(List<String> parentKeys) {
    if (parentKeys.isEmpty) return Container();
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Row(
          children: [
            ...parentKeys.asMap().entries.map((entry) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (entry.key > 0)
                    Icon(Icons.chevron_right, size: 16, 
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
                  TextButton(
                    onPressed: () {
                      // Navigate to this level
                      String uniqueKey = parentKeys
                          .take(entry.key + 1)
                          .join('_');
                      setState(() => _expandedKey = uniqueKey);
                    },
                    child: Text(entry.value,
                      style: TextStyle(fontSize: 12)),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context, Map<String, dynamic> item, String title, {List<String> parentKeys = const []}) {
    final bool isUnnamed = !_hasAnyValue(item);
    final String itemId = widget.documentationData.indexOf(item).toString();
    final bool isFavorited = _favorites.contains(itemId);
    
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.symmetric(
        horizontal: _isCompactMode ? 8.0 : 16.0, 
        vertical: _isCompactMode ? 2.0 : 4.0
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              isUnnamed ? "Unnamed" : title,
              style: TextStyle(
                fontSize: _isCompactMode ? 12 : 13,
                fontStyle: isUnnamed ? FontStyle.italic : FontStyle.normal,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(isUnnamed ? 0.6 : 0.87),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              isFavorited ? Icons.star : Icons.star_border,
              size: _isCompactMode ? 16 : 20,
            ),
            onPressed: () => _toggleFavorite(itemId),
          ),
          IconButton(
            icon: Icon(Icons.copy, size: _isCompactMode ? 16 : 20),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: title));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Copied to clipboard'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      subtitle: !_isCompactMode && item['Description'] != null ? Text(
        item['Description'].toString(),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 11,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        ),
      ) : null,
      onTap: () {
        _addToRecentlyViewed(itemId);
        widget.onItemSelected(widget.documentationData.indexOf(item));
      },
    );
  }

  Widget _buildExpansionTile(String title, int currentLevel, List<Widget> children, String uniqueKey) {
    return ExpansionTile(
      key: ValueKey(uniqueKey),
      initiallyExpanded: false,
      onExpansionChanged: (isExpanded) {
        setState(() {
          _expandedKey = isExpanded ? uniqueKey : null;
        });
      },
      maintainState: true,
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: (16 - currentLevel).clamp(12, 16).toDouble(),
        ),
      ),
      children: children,
      tilePadding: EdgeInsets.only(left: 16.0 + (currentLevel * 8.0), right: 16.0),
    );
  }

Widget _buildQuickAccessPanel() {
    if (!_showRecentlyViewed && !_showFavorites) return Container();

    return Container(
      color: Theme.of(context).colorScheme.surface.withOpacity(0.95),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_showRecentlyViewed && _recentlyViewed.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Recently Viewed',
                style: Theme.of(context).textTheme.titleSmall),
            ),
            ...(_recentlyViewed.map((id) {
              final item = widget.documentationData[int.parse(id)];
              return _buildListTile(context, item, 
                _getEffectiveKey(item, 0, []));
            })).take(5),
          ],
          if (_showFavorites && _favorites.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Favorites',
                style: Theme.of(context).textTheme.titleSmall),
            ),
            ...(_favorites.map((id) {
              final item = widget.documentationData[int.parse(id)];
              return _buildListTile(context, item, 
                _getEffectiveKey(item, 0, []));
            })),
          ],
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildHierarchyLevel(BuildContext context, List<Map<String, dynamic>> items, 
      int currentLevel, List<String> parentKeys) {
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
            _getEffectiveKey(item, hierarchyLevels.indexOf(level), newParentKeys).isNotEmpty);
      });

      String uniqueKey = '${currentLevel}_${key}_${newParentKeys.join("_")}';

      if (!hasSubItems || currentLevel == hierarchyLevels.length - 1) {
        children.add(Column(
          children: groupItems.map((item) => _buildListTile(context, item, key)).toList(),
        ));
      } else {
        children.add(_buildExpansionTile(
          key,
          currentLevel,
          [_buildHierarchyLevel(context, groupItems, currentLevel + 1, newParentKeys)],
          uniqueKey,
        ));
      }
    });

    // Add unnamed items at the end
    if (unnamedItems.isNotEmpty) {
      children.add(Column(
        children: unnamedItems.map((item) => 
          _buildListTile(context, item, "Unnamed")
        ).toList(),
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
          // Toolbar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search documentation...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                        _isSearching = value.isNotEmpty;
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(_isCompactMode ? Icons.unfold_more : Icons.unfold_less),
                  onPressed: () => setState(() => _isCompactMode = !_isCompactMode),
                  tooltip: _isCompactMode ? 'Expand view' : 'Compact view',
                ),
              ],
            ),
          ),
          // Quick access toggles
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                ChoiceChip(
                  label: Text('Recent'),
                  selected: _showRecentlyViewed,
                  onSelected: (value) => setState(() => _showRecentlyViewed = value),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: Text('Favorites'),
                  selected: _showFavorites,
                  onSelected: (value) => setState(() => _showFavorites = value),
                ),
              ],
            ),
          ),
          _buildQuickAccessPanel(),
          Expanded(
            child: SingleChildScrollView(
              child: _buildHierarchyLevel(context, widget.documentationData, 0, []),
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
