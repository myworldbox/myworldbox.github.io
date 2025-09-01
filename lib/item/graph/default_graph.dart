import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../core/core_enum.dart';
import '../../core/core_record.dart';

class DefaultGraph extends StatefulWidget {
  const DefaultGraph({super.key, required this.focus, required this.relations});

  final String focus;
  final List<CoreRecordGraph> relations;

  @override
  State<DefaultGraph> createState() => _DefaultGraphState();
}

class _DefaultGraphState extends State<DefaultGraph> {
  // Layout constants
  static const double nodeRadius = 40;
  static const int permutationLimit = 100;
  static const double paddingFactor = 2.0; // Controls padding relative to graph size

  // Fixed cell size (not scaled)
  double cellSize = 160;
  late Offset center;

  // State
  final GlobalKey _containerKey = GlobalKey();
  final TransformationController _controller = TransformationController();
  double _scale = 1.0;

  // Graph structures
  Map<String, Map<CoreEnumStep, Set<String>>> graph = {};
  Map<String, Point> positions = {};
  List<List<String>>? optimizedLayers;
  int minCrossings = 0;

  // Graph bounds
  double graphWidth = 0.0;
  double graphHeight = 0.0;

  // UI states
  String? hoveredNode;
  bool focusMode = false;
  bool isDarkMode = true;

  @override
  void initState() {
    super.initState();
    _buildGraph();
    _layoutAndOptimize();
    WidgetsBinding.instance.addPostFrameCallback((_) => _centerOnFocus());
    _controller.addListener(_updateScale);
  }

  @override
  void didUpdateWidget(covariant DefaultGraph oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.relations != widget.relations ||
        oldWidget.focus != widget.focus) {
      _buildGraph();
      _layoutAndOptimize();
      WidgetsBinding.instance.addPostFrameCallback((_) => _centerOnFocus());
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_updateScale);
    _controller.dispose();
    super.dispose();
  }

  void _updateScale() {
    final newScale = _controller.value.getMaxScaleOnAxis();
    if (newScale != _scale) {
      setState(() {
        _scale = newScale;
      });
      _centerOnFocus(); // Recenter after scale change to maintain padding
    }
  }

  void _buildGraph() {
    graph.clear();
    for (final r in widget.relations) {
      graph.putIfAbsent(
        r.from,
        () => {
          CoreEnumStep.prev: <String>{},
          CoreEnumStep.next: <String>{},
          CoreEnumStep.parallel: <String>{},
        },
      );
      graph.putIfAbsent(
        r.to,
        () => {
          CoreEnumStep.prev: <String>{},
          CoreEnumStep.next: <String>{},
          CoreEnumStep.parallel: <String>{},
        },
      );
      final f = graph[r.from]!;
      final t = graph[r.to]!;
      if (r.type == CoreEnumStep.next) {
        f[CoreEnumStep.next]!.add(r.to);
        t[CoreEnumStep.prev]!.add(r.from);
      } else if (r.type == CoreEnumStep.prev) {
        f[CoreEnumStep.prev]!.add(r.to);
        t[CoreEnumStep.next]!.add(r.from);
      } else if (r.type == CoreEnumStep.parallel) {
        f[CoreEnumStep.parallel]!.add(r.to);
        t[CoreEnumStep.parallel]!.add(r.from);
      }
    }
  }

  void _layoutAndOptimize() {
    if (graph.isEmpty) {
      positions = {};
      optimizedLayers = [];
      minCrossings = 0;
      center = Offset.zero;
      graphWidth = cellSize * 2;
      graphHeight = cellSize * 2;
      return;
    }

    // BFS for depth assignment
    final levels = <String, int>{};
    final visited = <String>{};
    final queue = <(String, int)>[(widget.focus, 0)];

    while (queue.isNotEmpty) {
      final (node, depth) = queue.removeAt(0);
      if (visited.contains(node)) continue;
      visited.add(node);
      levels[node] = depth;
      final gNode = graph[node];
      if (gNode == null) continue;
      for (final n in gNode[CoreEnumStep.next]!) {
        queue.add((n, depth - 1));
      }
      for (final n in gNode[CoreEnumStep.prev]!) {
        queue.add((n, depth + 1));
      }
      for (final n in gNode[CoreEnumStep.parallel]!) {
        queue.add((n, depth));
      }
    }

    // Group by depth
    final layerMap = <int, List<String>>{};
    for (final e in levels.entries) {
      layerMap.putIfAbsent(e.value, () => <String>[]).add(e.key);
    }

    final depths = layerMap.keys.toList()..sort();
    List<List<String>> layers = depths
        .map((d) => List<String>.from(layerMap[d]!))
        .toList();

    // Sort by degree
    int deg(String n) =>
        (graph[n]?[CoreEnumStep.next]?.length ?? 0) +
        (graph[n]?[CoreEnumStep.prev]?.length ?? 0) +
        (graph[n]?[CoreEnumStep.parallel]?.length ?? 0);

    for (final layer in layers) {
      layer.sort((a, b) => deg(b).compareTo(deg(a)));
    }

    // Optimize layer permutations
    List<List<String>> bestLayers = layers
        .map((l) => List<String>.from(l))
        .toList();
    var c0 = _countCrossings(bestLayers, graph, widget.relations);
    int minLocal = c0.sameDepthCrossings + c0.diffDepthCrossings;

    // Track total permutations across all considered layers
    int totalPermutations = 1;

    for (int numLayers = 1; numLayers <= layers.length; numLayers++) {
      final indices = List<int>.generate(numLayers, (i) => i);
      final multiPerms = _generateMultiLayerPermutations(
        layers,
        indices,
        permutationLimit,
      );

      // Calculate total possible permutations for current layer set
      int layerPermutations = 1;
      for (int i = 0; i < numLayers; i++) {
        layerPermutations *= _factorial(layers[indices[i]].length);
      }

      // Update total permutations
      totalPermutations = layerPermutations;

      int iterationCount = 0;
      for (final permSet in multiPerms) {
        iterationCount++;
        final temp = bestLayers.map((l) => List<String>.from(l)).toList();
        for (int i = 0; i < indices.length; i++) {
          temp[indices[i]] = List<String>.from(permSet[i]);
        }
        final c = _countCrossings(temp, graph, widget.relations);
        final total = c.sameDepthCrossings + c.diffDepthCrossings;
        if (total < minLocal) {
          minLocal = total;
          bestLayers = temp.map((l) => List<String>.from(l)).toList();
        }
        if (total == 0) break;
      }

      // Print permutation info for this layer
      print(
        'Layer $numLayers: Optimal iteration count = $iterationCount, '
        'Total permutations = $totalPermutations',
      );

      if (minLocal == 0) break;
    }

    // Calculate positions and bounds
    final pos = <String, Point>{};
    int maxX = 0, minX = 0, maxY = 0, minY = 0;
    for (int i = 0; i < bestLayers.length; i++) {
      final layer = bestLayers[i];
      final half = layer.length ~/ 2;
      for (int idx = 0; idx < layer.length; idx++) {
        final x = idx - half;
        final y = -depths[i]; // Invert y to place highest depth at top
        pos[layer[idx]] = Point(x, y);
        maxX = math.max(maxX, x);
        minX = math.min(minX, x);
        maxY = math.max(maxY, y);
        minY = math.min(minY, y);
      }
    }

    // Calculate graph size with equal padding
    final width = (maxX - minX + 1) * cellSize + paddingFactor * cellSize;
    final height = (maxY - minY + 1) * cellSize + paddingFactor * cellSize;

    setState(() {
      optimizedLayers = bestLayers;
      positions = pos;
      minCrossings = minLocal;
      center = Offset(width / 2, height / 2);
      graphWidth = width;
      graphHeight = height;
    });
  }

  void _centerOnFocus() {
    final ctx = _containerKey.currentContext;
    if (ctx == null || !positions.containsKey(widget.focus)) return;

    final renderBox = ctx.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    final size = renderBox.size;
    final gp = positions[widget.focus]!;
    final targetPx = Offset(
      center.dx + gp.x * cellSize,
      center.dy + gp.y * cellSize,
    );

    // Calculate translation to center the focus node
    final tx = size.width / 2 - _scale * targetPx.dx;
    final ty = size.height / 2 - _scale * targetPx.dy;

    // Ensure equal padding by adjusting translation based on graph bounds
    final scaledWidth = graphWidth * _scale;
    final scaledHeight = graphHeight * _scale;
    final paddingX = (size.width - scaledWidth) / 2;
    final paddingY = (size.height - scaledHeight) / 2;

    // Clamp translation to keep graph within padded bounds
    final clampedTx = tx.clamp(
      paddingX - scaledWidth / 2,
      size.width - scaledWidth / 2 - paddingX,
    );
    final clampedTy = ty.clamp(
      paddingY - scaledHeight / 2,
      size.height - scaledHeight / 2 - paddingY,
    );

    _controller.value = Matrix4.identity()
      ..translate(clampedTx, clampedTy)
      ..scale(_scale);
  }

  Set<String>? _getVisibleNodes() {
    if (!focusMode || hoveredNode == null) return null;
    final visible = <String>{hoveredNode!};
    final gNode = graph[hoveredNode!];
    if (gNode != null) {
      visible.addAll(gNode[CoreEnumStep.prev]!);
      visible.addAll(gNode[CoreEnumStep.next]!);
      visible.addAll(gNode[CoreEnumStep.parallel]!);
    }
    return visible;
  }

  Color get _bgColor =>
      isDarkMode ? const Color(0xFF111827) : const Color(0xFFE5E7EB);
  Color get _panelBg =>
      isDarkMode ? const Color(0xCC1F2937) : const Color(0xCCFFFFFF);
  Color get _panelBorder =>
      isDarkMode ? const Color(0xFF4B5563) : const Color(0xFFD1D5DB);
  Color get _textColor => isDarkMode ? Colors.white : const Color(0xFF111827);

  Color _nodeFill({
    required bool isFocused,
    required bool isHovered,
    required bool isNeighbor,
  }) {
    if (isFocused)
      return isDarkMode ? const Color(0xCCDC2626) : const Color(0xCCF87171);
    if (isHovered)
      return isDarkMode ? const Color(0xCCEAB308) : const Color(0xCCFDE68A);
    if (isNeighbor)
      return isDarkMode ? const Color(0xCC059669) : const Color(0xCC86EFAC);
    return isDarkMode ? const Color(0xCC374151) : const Color(0xCCFFFFFF);
  }

  Color _nodeBorder({required bool isFocused}) {
    return isFocused
        ? (isDarkMode ? const Color(0xFFFB7185) : const Color(0xFFEF4444))
        : (isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF4B5563));
  }

  Color get _nextColor =>
      isDarkMode ? const Color(0xFF34D399) : const Color(0xFF16A34A);
  Color get _prevColor =>
      isDarkMode ? const Color(0xFFF87171) : const Color(0xFFDC2626);
  Color get _parColor =>
      isDarkMode ? const Color(0xFF60A5FA) : const Color(0xFF2563EB);

  @override
  Widget build(BuildContext context) {
    final visibleNodes = _getVisibleNodes();

    final nodeEntries = positions.entries
        .where((e) => visibleNodes == null || visibleNodes.contains(e.key))
        .toList();

    nodeEntries.sort((a, b) {
      final aKey = a.key;
      final bKey = b.key;
      int z(String n) {
        if (n == widget.focus || n == hoveredNode) return 2;
        if (visibleNodes != null &&
            n != hoveredNode &&
            visibleNodes.contains(n))
          return 1;
        return 0;
      }

      return z(aKey).compareTo(z(bKey));
    });

    // Calculate dynamic boundary margin based on graph size and scale
    final boundaryMargin = math.max(graphWidth, graphHeight) * _scale * paddingFactor;

    return Scaffold(
      backgroundColor: _bgColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: ClipRect(
              child: Container(
                key: _containerKey,
                color: _bgColor,
                child: Listener(
                  onPointerSignal: (PointerSignalEvent event) {
                    if (event is PointerScrollEvent) {
                      GestureBinding.instance.pointerSignalResolver.register(
                        event,
                        (event) {},
                      );
                    }
                  },
                  child: GestureDetector(
                    onPanStart: (_) {},
                    onPanUpdate: (_) {},
                    onPanEnd: (_) {},
                    child: InteractiveViewer(
                      transformationController: _controller,
                      panEnabled: true,
                      scaleEnabled: true,
                      minScale: 0.1,
                      maxScale: 5.0,
                      boundaryMargin: EdgeInsets.all(boundaryMargin),
                      clipBehavior: Clip.none,
                      child: SizedBox(
                        width: graphWidth,
                        height: graphHeight,
                        child: CustomPaint(
                          painter: _EdgesPainter(
                            positions: positions,
                            relations: widget.relations,
                            center: center,
                            cellSize: cellSize,
                            nodeRadius: nodeRadius,
                            isDarkMode: isDarkMode,
                            nextColor: _nextColor,
                            prevColor: _prevColor,
                            parColor: _parColor,
                            focusMode: focusMode,
                            hoveredNode: hoveredNode,
                            visibleNodes: visibleNodes,
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: nodeEntries.map((entry) {
                              final n = entry.key;
                              final gp = entry.value;
                              final isFocused = n == widget.focus;
                              final isHovered = n == hoveredNode;
                              final isNeighbor =
                                  visibleNodes != null &&
                                  n != hoveredNode &&
                                  visibleNodes.contains(n);

                              final px = center.dx + gp.x * cellSize;
                              final py = center.dy + gp.y * cellSize;

                              return Positioned(
                                left: px - nodeRadius,
                                top: py - nodeRadius,
                                width: nodeRadius * 2,
                                height: nodeRadius * 2,
                                child: MouseRegion(
                                  onEnter: (_) =>
                                      setState(() => hoveredNode = n),
                                  onExit: (_) =>
                                      setState(() => hoveredNode = null),
                                  child: GestureDetector(
                                    onTap: () =>
                                        setState(() => hoveredNode = n),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: _nodeFill(
                                          isFocused: isFocused,
                                          isHovered: isHovered,
                                          isNeighbor: isNeighbor,
                                        ),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: _nodeBorder(
                                            isFocused: isFocused,
                                          ),
                                          width: 2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              isDarkMode ? 0.3 : 0.2,
                                            ),
                                            blurRadius: 10,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        n,
                                        style: TextStyle(
                                          color: isDarkMode
                                              ? Colors.white
                                              : const Color(0xFF111827),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: Row(
              children: [
                _softButton(
                  onTap: () => setState(() => focusMode = !focusMode),
                  child: Icon(
                    focusMode ? Icons.grid_view_rounded : Icons.search_rounded,
                    color: _textColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                _softButton(
                  onTap: () => setState(() => isDarkMode = !isDarkMode),
                  child: Icon(
                    isDarkMode
                        ? Icons.light_mode_rounded
                        : Icons.dark_mode_rounded,
                    color: _textColor,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _panelBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _panelBorder),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDarkMode ? 0.4 : 0.2),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _legendRow(color: _nextColor, label: 'Next', withArrow: true),
                  const SizedBox(height: 6),
                  _legendRow(color: _prevColor, label: 'Prev', withArrow: true),
                  const SizedBox(height: 6),
                  _legendRow(color: _parColor, label: 'Parallel', dashed: true),
                  const SizedBox(height: 8),
                  Text(
                    'Edge Crossings: $minCrossings',
                    style: TextStyle(color: _textColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _softButton({required VoidCallback onTap, required Widget child}) {
    return Material(
      color: _panelBg,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: _panelBorder),
            borderRadius: BorderRadius.circular(10),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _legendRow({
    required Color color,
    required String label,
    bool withArrow = false,
    bool dashed = false,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomPaint(
          size: const Size(28, 12),
          painter: _LegendLinePainter(
            color: color,
            withArrow: withArrow,
            dashed: dashed,
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(color: _textColor)),
      ],
    );
  }

  static List<List<T>> _permute<T>(List<T> arr) {
    final results = <List<T>>[];
    void generate(List<T> a, List<T> m) {
      if (a.isEmpty) {
        results.add(List<T>.from(m));
      } else {
        for (int i = 0; i < a.length; i++) {
          final curr = List<T>.from(a);
          final next = curr.removeAt(i);
          generate(curr, [...m, next]);
        }
      }
    }

    generate(List<T>.from(arr), <T>[]);
    return results;
  }

  static List<List<T>> _generatePermutations<T>(List<T> layer, int limit) {
    final n = layer.length;
    if (_factorial(n) <= limit) {
      return _permute(layer);
    } else {
      final results = <List<T>>[List<T>.from(layer)];
      final rnd = math.Random();
      for (int i = 1; i < limit; i++) {
        final perm = List<T>.from(layer);
        for (int j = n - 1; j > 0; j--) {
          final k = rnd.nextInt(j + 1);
          final tmp = perm[j];
          perm[j] = perm[k];
          perm[k] = tmp;
        }
        results.add(perm);
      }
      return results;
    }
  }

  static int _factorial(int n) {
    if (n <= 1) return 1;
    return n * _factorial(n - 1);
  }

  static List<List<List<T>>> _generateMultiLayerPermutations<T>(
    List<List<T>> layers,
    List<int> indices,
    int limit,
  ) {
    final layerPerms = indices
        .map((i) => _generatePermutations(layers[i], limit))
        .toList();

    final perms = <List<List<T>>>[];

    void combineLayer(int depth, List<List<T>> current) {
      if (depth == layerPerms.length) {
        perms.add(current.map((e) => List<T>.from(e)).toList());
        return;
      }
      for (final perm in layerPerms[depth]) {
        combineLayer(depth + 1, [...current, perm]);
      }
    }

    final totalPerms = layerPerms.fold<int>(1, (acc, p) => acc * p.length);
    if (totalPerms <= limit) {
      combineLayer(0, []);
    } else {
      final rnd = math.Random();
      for (int i = 0; i < limit; i++) {
        final combo = <List<T>>[];
        for (var lp in layerPerms) {
          combo.add(lp[rnd.nextInt(lp.length)]);
        }
        perms.add(combo);
      }
    }
    return perms;
  }

  static int _orientation(Offset p, Offset q, Offset r) {
    final val = (q.dy - p.dy) * (r.dx - q.dx) - (q.dx - p.dx) * (r.dy - q.dy);
    if (val == 0) return 0;
    return val > 0 ? 1 : 2;
  }

  static bool _onSegment(Offset p, Offset q, Offset r) {
    return q.dx <= math.max(p.dx, r.dx) &&
        q.dx >= math.min(p.dx, r.dx) &&
        q.dy <= math.max(p.dy, r.dy) &&
        q.dy >= math.min(p.dy, r.dy);
  }

  static bool _segmentsIntersect(Offset p1, Offset p2, Offset q1, Offset q2) {
    final o1 = _orientation(p1, p2, q1);
    final o2 = _orientation(p1, p2, q2);
    final o3 = _orientation(q1, q2, p1);
    final o4 = _orientation(q1, q2, p2);
    if (o1 != o2 && o3 != o4) return true;
    if (o1 == 0 && _onSegment(p1, q1, p2)) return true;
    if (o2 == 0 && _onSegment(p1, q2, p2)) return true;
    if (o3 == 0 && _onSegment(q1, p1, q2)) return true;
    if (o4 == 0 && _onSegment(q1, p2, q2)) return true;
    return false;
  }

  static ({int sameDepthCrossings, int diffDepthCrossings}) _countCrossings(
    List<List<String>> layers,
    Map<String, Map<CoreEnumStep, Set<String>>> graph,
    List<CoreRecordGraph> relations,
  ) {
    int sameDepthCrossings = 0;
    int diffDepthCrossings = 0;
    final nodeToPos = <String, ({int depth, int x})>{};
    for (int depth = 0; depth < layers.length; depth++) {
      final layer = layers[depth];
      for (int idx = 0; idx < layer.length; idx++) {
        nodeToPos[layer[idx]] = (depth: depth, x: idx);
      }
    }
    for (int i = 0; i < relations.length; i++) {
      for (int j = i + 1; j < relations.length; j++) {
        final edge1 = relations[i];
        final edge2 = relations[j];
        final p1 = nodeToPos[edge1.from];
        final p2 = nodeToPos[edge1.to];
        final q1 = nodeToPos[edge2.from];
        final q2 = nodeToPos[edge2.to];
        if (p1 == null || p2 == null || q1 == null || q2 == null) continue;
        if (edge1.from == edge2.from ||
            edge1.from == edge2.to ||
            edge1.to == edge2.from ||
            edge1.to == edge2.to)
          continue;

        ({int depth, int x}) u1 = p1, v1 = p2;
        if (edge1.type == CoreEnumStep.parallel && p1.depth == p2.depth) {
          u1 = p1.x <= p2.x ? p1 : p2;
          v1 = p1.x <= p2.x ? p2 : p1;
        } else if (p1.depth > p2.depth && edge1.type != CoreEnumStep.parallel) {
          u1 = p2;
          v1 = p1;
        }
        ({int depth, int x}) u2 = q1, v2 = q2;
        if (edge2.type == CoreEnumStep.parallel && q1.depth == q2.depth) {
          u2 = q1.x <= q2.x ? q1 : q2;
          v2 = q1.x <= q2.x ? q2 : q1;
        } else if (q1.depth > q2.depth && edge2.type != CoreEnumStep.parallel) {
          u2 = q2;
          v2 = q1;
        }
        final u1Coord = Offset(u1.x.toDouble(), u1.depth.toDouble());
        final v1Coord = Offset(v1.x.toDouble(), v1.depth.toDouble());
        final u2Coord = Offset(u2.x.toDouble(), u2.depth.toDouble());
        final v2Coord = Offset(v2.x.toDouble(), v2.depth.toDouble());
        if (u1.depth == v1.depth &&
            u2.depth == v2.depth &&
            u1.depth == u2.depth) {
          final xs = [u1.x, v1.x, u2.x, v2.x]..sort();
          final u1Idx = xs.indexOf(u1.x);
          final v1Idx = xs.indexOf(v1.x);
          final u2Idx = xs.indexOf(u2.x);
          final v2Idx = xs.indexOf(v2.x);
          final isNonCrossing =
              ((u1Idx - v1Idx).abs() == 1 && (u2Idx - v2Idx).abs() == 1) &&
              (math.max(u1Idx, v1Idx) < math.min(u2Idx, v2Idx) ||
                  math.max(u2Idx, v2Idx) < math.min(u1Idx, v1Idx));
          if (!isNonCrossing) sameDepthCrossings++;
        } else {
          if (_segmentsIntersect(u1Coord, v1Coord, u2Coord, v2Coord))
            diffDepthCrossings++;
        }
      }
    }
    return (
      sameDepthCrossings: sameDepthCrossings,
      diffDepthCrossings: diffDepthCrossings,
    );
  }
}

class Point {
  final int x;
  final int y;
  const Point(this.x, this.y);
}

class _EdgesPainter extends CustomPainter {
  _EdgesPainter({
    required this.positions,
    required this.relations,
    required this.center,
    required this.cellSize,
    required this.nodeRadius,
    required this.isDarkMode,
    required this.nextColor,
    required this.prevColor,
    required this.parColor,
    required this.focusMode,
    required this.hoveredNode,
    required this.visibleNodes,
  });

  final Map<String, Point> positions;
  final List<CoreRecordGraph> relations;
  final Offset center;
  final double cellSize;
  final double nodeRadius;
  final bool isDarkMode;
  final Color nextColor;
  final Color prevColor;
  final Color parColor;
  final bool focusMode;
  final String? hoveredNode;
  final Set<String>? visibleNodes;

  bool _isVisibleEdge(String a, String b) {
    if (visibleNodes == null) return true;
    return visibleNodes!.contains(a) && visibleNodes!.contains(b);
  }

  int _pairHash(String a, String b) {
    final sorted = [a, b]..sort();
    return sorted.join('|').hashCode;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final drawnParallel = <String>{};
    for (final r in relations) {
      if (!positions.containsKey(r.from) || !positions.containsKey(r.to))
        continue;
      if (!_isVisibleEdge(r.from, r.to)) continue;

      final from = positions[r.from]!;
      final to = positions[r.to]!;
      final fromXpx = center.dx + from.x * cellSize;
      final fromYpx = center.dy + from.y * cellSize;
      final toXpx = center.dx + to.x * cellSize;
      final toYpx = center.dy + to.y * cellSize;

      final paint = Paint()
        ..color = r.type == CoreEnumStep.next
            ? nextColor
            : r.type == CoreEnumStep.prev
            ? prevColor
            : parColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;

      final path = Path();
      if (r.type == CoreEnumStep.parallel) {
        final key = ([r.from, r.to]..sort()).join('|');
        if (drawnParallel.contains(key)) continue;
        drawnParallel.add(key);

        final midY = (fromYpx + toYpx) / 2;
        double c1x = fromXpx;
        double c2x = toXpx;
        double ctrlY = midY;

        final sameRow = from.y == to.y;
        final sameCol = from.x == to.x;
        final dir = (_pairHash(r.from, r.to) & 1) == 1 ? 1 : -1;
        double bendX = 0;
        double bendY = 0;

        if (sameRow) {
          bendY = dir * 40;
          final minX = math.min(from.x, to.x);
          final maxX = math.max(from.x, to.x);
          final hasNodeBetween = positions.entries.any(
            (entry) =>
                entry.value.y == from.y &&
                entry.value.x > minX &&
                entry.value.x < maxX,
          );
          if (hasNodeBetween) {
            bendY = dir * math.max(cellSize * 0.6, nodeRadius * 2 + 16);
          }
        } else if (sameCol) {
          bendX = dir * 40;
          final minY = math.min(from.y, to.y);
          final maxY = math.max(from.y, to.y);
          final hasNodeBetween = positions.entries.any(
            (entry) =>
                entry.value.x == from.x &&
                entry.value.y > minY &&
                entry.value.y < maxY,
          );
          if (hasNodeBetween) {
            bendX = dir * math.max(cellSize * 0.6, nodeRadius * 2 + 16);
          }
        }
        c1x = fromXpx + bendX;
        c2x = toXpx + bendX;
        ctrlY = (fromYpx + toYpx) / 2 + bendY;

        path
          ..moveTo(fromXpx, fromYpx)
          ..cubicTo(c1x, ctrlY, c2x, ctrlY, toXpx, toYpx);

        final dashed = _dashPath(path, dashArray: const [6, 6]);
        canvas.drawPath(dashed, paint);
      } else {
        // First vertical segment
        final midY = fromYpx + (toYpx - fromYpx) / 2;
        path.moveTo(fromXpx, fromYpx);
        path.lineTo(fromXpx, midY);

        // Second horizontal segment
        final dx = toXpx - fromXpx;
        final dy = toYpx - midY;
        final diagLength = math.min(dx.abs(), dy.abs());
        final diagX = toXpx - dx.sign * diagLength;
        final diagY = toYpx - dy.sign * diagLength;
        path.lineTo(diagX, midY);

        // Final 45-degree diagonal segment
        path.lineTo(toXpx, toYpx);

        canvas.drawPath(path, paint);
      }

      _drawArrowHead(
        canvas,
        from: Offset(fromXpx, fromYpx),
        to: Offset(toXpx, toYpx),
        color: paint.color,
      );
    }
  }

  static Path _dashPath(Path source, {required List<double> dashArray}) {
    final metrics = source.computeMetrics();
    final dashed = Path();
    for (final m in metrics) {
      double distance = 0.0;
      int index = 0;
      while (distance < m.length) {
        final len = dashArray[index % dashArray.length];
        final next = distance + len;
        final extract = m.extractPath(distance, next.clamp(0.0, m.length));
        if (index % 2 == 0) dashed.addPath(extract, Offset.zero);
        distance = next;
        index++;
      }
    }
    return dashed;
  }

  static void _drawArrowHead(
    Canvas canvas, {
    required Offset from,
    required Offset to,
    required Color color,
  }) {
    final v = to - from;
    final angle = math.atan2(v.dy, v.dx);
    const double length = 12;
    const double width = 7;
    final p1 = to;
    final p2 = Offset(
      to.dx - length * math.cos(angle - math.pi / 6),
      to.dy - length * math.sin(angle - math.pi / 6),
    );
    final p3 = Offset(
      to.dx - length * math.cos(angle + math.pi / 6),
      to.dy - length * math.sin(angle + math.pi / 6),
    );
    final path = Path()
      ..moveTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy)
      ..lineTo(p3.dx, p3.dy)
      ..close();
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _EdgesPainter oldDelegate) {
    return oldDelegate.positions != positions ||
        oldDelegate.relations != relations ||
        oldDelegate.isDarkMode != isDarkMode ||
        oldDelegate.hoveredNode != hoveredNode ||
        oldDelegate.focusMode != focusMode ||
        oldDelegate.cellSize != cellSize ||
        oldDelegate.center != center;
  }
}

class _LegendLinePainter extends CustomPainter {
  _LegendLinePainter({
    required this.color,
    required this.withArrow,
    required this.dashed,
  });

  final Color color;
  final bool withArrow;
  final bool dashed;

  @override
  void paint(Canvas canvas, Size size) {
    final p1 = Offset(0, size.height / 2);
    final p2 = Offset(size.width, size.height / 2);
    final path = Path()
      ..moveTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    if (dashed) {
      final dashedPath = _EdgesPainter._dashPath(path, dashArray: const [3, 3]);
      canvas.drawPath(dashedPath, paint);
    } else {
      canvas.drawPath(path, paint);
    }
    if (withArrow) {
      _EdgesPainter._drawArrowHead(canvas, from: p1, to: p2, color: color);
    }
  }

  @override
  bool shouldRepaint(covariant _LegendLinePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.withArrow != withArrow ||
        oldDelegate.dashed != dashed;
  }
}