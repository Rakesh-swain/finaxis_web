import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../controllers/theme_controller.dart';
import '../theme/app_theme.dart';

/// 🚀 Futuristic Data Table - Full Width Responsive
/// Features holographic headers, animated rows, and glassmorphic styling
class FuturisticTable extends StatefulWidget {
  final List<FuturisticTableColumn> columns;
  final List<FuturisticTableRow> rows;
  final bool isLoading;
  final String? emptyMessage;
  final Function(int index)? onRowTap;
  final int? sortColumnIndex;
  final bool sortAscending;
  final Function(int columnIndex, bool ascending)? onSort;

  const FuturisticTable({
    Key? key,
    required this.columns,
    required this.rows,
    this.isLoading = false,
    this.emptyMessage = 'No data available',
    this.onRowTap,
    this.sortColumnIndex,
    this.sortAscending = true,
    this.onSort,
  }) : super(key: key);

  @override
  State<FuturisticTable> createState() => _FuturisticTableState();
}

class _FuturisticTableState extends State<FuturisticTable>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _scanlineController;
  int? _hoveredRowIndex;
  List<double> _columnWidths = [];

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _scanlineController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _glowController.dispose();
    _scanlineController.dispose();
    super.dispose();
  }

  void _calculateColumnWidths(double totalWidth) {
    final totalFlex = widget.columns.fold<int>(0, (sum, col) => sum + col.flex);
    _columnWidths = widget.columns.map((col) {
      return (totalWidth * col.flex / totalFlex);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).cardColor.withOpacity(0.1),
            Theme.of(context).cardColor.withOpacity(0.05),
          ],
        ),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            // 🎯 Holographic Header
            _buildHolographicHeader(),
        
            // 📋 Table Body
            widget.isLoading
                ? _buildLoadingState()
                : widget.rows.isEmpty
                    ? _buildEmptyState()
                    : Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: _buildTableBody(),
                        ),
                      ),
          ],
        ),
      ),
    );
  }

  /// Build particle background animation
  Widget _buildParticleBackground() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _glowController,
        builder: (context, child) {
          return CustomPaint(
            painter: TableParticlePainter(
              animationValue: _glowController.value,
              primaryColor: Theme.of(context).primaryColor,
            ),
          );
        },
      ),
    );
  }

  /// Build holographic header with glow effects
  Widget _buildHolographicHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        _calculateColumnWidths(constraints.maxWidth - 32); // minus padding

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).primaryColor.withOpacity(0.15),
                Theme.of(context).primaryColor.withOpacity(0.08),
                Colors.transparent,
              ],
            ),
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).primaryColor.withOpacity(0.3),
                width: 2,
              ),
            ),
          ),
          child: Row(
            children: widget.columns.asMap().entries.map((entry) {
              final index = entry.key;
              final column = entry.value;
              final isActive = widget.sortColumnIndex == index;

              return SizedBox(
                width: _columnWidths.isNotEmpty ? _columnWidths[index] : 0,
                child: InkWell(
                  onTap: column.sortable && widget.onSort != null
                      ? () => widget.onSort!(
                            index,
                            widget.sortColumnIndex == index
                                ? !widget.sortAscending
                                : true,
                          )
                      : null,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: isActive
                          ? LinearGradient(
                              colors: [
                                Theme.of(context).primaryColor.withOpacity(0.2),
                                Theme.of(context).primaryColor.withOpacity(0.1),
                              ],
                            )
                          : null,
                      border: isActive
                          ? Border.all(
                              color: Theme.of(context).primaryColor.withOpacity(0.4),
                              width: 1,
                            )
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Holographic Icon
                        if (column.icon != null) ...[
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(context).primaryColor.withOpacity(0.3),
                                  Theme.of(context).primaryColor.withOpacity(0.1),
                                ],
                              ),
                            ),
                            child: Icon(
                              column.icon,
                              size: 16,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(width: 6),
                        ],

                        // Header Text - takes remaining space
                        Expanded(
                          child: ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: isActive
                                  ? [
                                      Theme.of(context).primaryColor,
                                      Theme.of(context).primaryColor.withOpacity(0.8),
                                    ]
                                  : [
                                      Theme.of(context).textTheme.titleMedium?.color ??
                                          Colors.black,
                                      Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.color
                                              ?.withOpacity(0.8) ??
                                          Colors.black54,
                                    ],
                            ).createShader(bounds),
                            child: Text(
                              column.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 0.3,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ),

                        // Sort Indicator
                        if (column.sortable && column.title.isNotEmpty) ...[
                          const SizedBox(width: 4),
                          AnimatedRotation(
                            turns: isActive ? (widget.sortAscending ? 0 : 0.5) : 0,
                            duration: const Duration(milliseconds: 300),
                            child: AnimatedOpacity(
                              opacity: isActive ? 1.0 : 0.4,
                              duration: const Duration(milliseconds: 300),
                              child: Icon(
                                isActive
                                    ? (widget.sortAscending
                                        ? Icons.arrow_upward_rounded
                                        : Icons.arrow_downward_rounded)
                                    : Icons.unfold_more_rounded,
                                size: 14,
                                color: isActive
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.color
                                        ?.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(delay: (index * 100).ms, duration: 600.ms)
                      .slideX(begin: -0.2, end: 0),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  /// Build table body with animated rows
  Widget _buildTableBody() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (_columnWidths.isEmpty) {
          _calculateColumnWidths(constraints.maxWidth - 32);
        }

        return Column(
          children: List.generate(widget.rows.length, (index) {
            final row = widget.rows[index];
            final isHovered = _hoveredRowIndex == index;

            return MouseRegion(
              onEnter: (_) => setState(() => _hoveredRowIndex = index),
              onExit: (_) => setState(() => _hoveredRowIndex = null),
              child: InkWell(
                onTap: widget.onRowTap != null ? () => widget.onRowTap!(index) : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.only(
                    bottom: 12,
                    left: 10,
                    right: 10,
                    top: index == 0 ? 16 : 0,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: isHovered
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Theme.of(context).primaryColor.withOpacity(0.12),
                              Theme.of(context).primaryColor.withOpacity(0.06),
                            ],
                          )
                        : LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Theme.of(context).cardColor.withOpacity(0.8),
                              Theme.of(context).cardColor.withOpacity(0.4),
                            ],
                          ),
                    border: Border.all(
                      color: isHovered
                          ? Theme.of(context).primaryColor.withOpacity(0.4)
                          : Theme.of(context).dividerColor.withOpacity(0.2),
                      width: isHovered ? 1.5 : 1,
                    ),
                    boxShadow: isHovered
                        ? [
                            BoxShadow(
                              color: Theme.of(context).primaryColor.withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                  ),
                  child: Row(
                    children: widget.columns.asMap().entries.map((entry) {
                      final columnIndex = entry.key;
                      final column = entry.value;
                      final cellData = row.cells[columnIndex];

                      return SizedBox(
                        width: _columnWidths.isNotEmpty ? _columnWidths[columnIndex] : 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Center(
                            child: cellData.widget ??
                                Text(
                                  cellData.text,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight:
                                        isHovered ? FontWeight.w600 : FontWeight.w500,
                                    color:
                                        Theme.of(context).textTheme.bodyMedium?.color,
                                  ),
                                ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                )
                    .animate()
                    .fadeIn(delay: (index * 50).ms, duration: 400.ms)
                    .slideY(begin: 0.3, end: 0)
                    .then(delay: (index * 100).ms)
                    .shimmer(
                      duration: 1500.ms,
                      colors: [
                        Colors.transparent,
                        Theme.of(context).primaryColor.withOpacity(0.1),
                        Colors.transparent,
                      ],
                    ),
              ),
            );
          }),
        );
      },
    );
  }

  /// Build loading state with futuristic spinner
  Widget _buildLoadingState() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withOpacity(0.6),
                  ],
                ),
              ),
              child: const Icon(
                Icons.table_chart_rounded,
                color: Colors.white,
                size: 40,
              ),
            )
                .animate()
                .scale(duration: 800.ms)
                .then()
                .shimmer(
                  duration: 1500.ms,
                  colors: [
                    Colors.white.withOpacity(0.3),
                    Colors.white.withOpacity(0.8),
                    Colors.white.withOpacity(0.3),
                  ],
                ),
            const SizedBox(height: 24),
            Text(
              'Loading Data...',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w600),
            ).animate().fadeIn(delay: 300.ms, duration: 600.ms),
          ],
        ),
      ),
    );
  }

  /// Build empty state
  Widget _buildEmptyState() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor.withOpacity(0.2),
                    Theme.of(context).primaryColor.withOpacity(0.05),
                  ],
                ),
                border: Border.all(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.inbox_rounded,
                size: 60,
                color: Theme.of(context).primaryColor.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              widget.emptyMessage!,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.color
                        ?.withOpacity(0.7),
                  ),
            ),
          ],
        ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.3, end: 0),
      ),
    );
  }
}

/// Table Column Definition
class FuturisticTableColumn {
  final String title;
  final int flex;
  final bool sortable;
  final IconData? icon;

  const FuturisticTableColumn({
    required this.title,
    this.flex = 1,
    this.sortable = true,
    this.icon,
  });
}

/// Table Row Definition
class FuturisticTableRow {
  final List<FuturisticTableCell> cells;

  const FuturisticTableRow({required this.cells});
}

/// Table Cell Definition
class FuturisticTableCell {
  final String text;
  final Widget? widget;

  const FuturisticTableCell({required this.text, this.widget});
}

/// Particle Background Painter
class TableParticlePainter extends CustomPainter {
  final double animationValue;
  final Color primaryColor;

  TableParticlePainter({
    required this.animationValue,
    required this.primaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryColor.withOpacity(0.1)
      ..strokeWidth = 1;

    // Draw animated particles
    for (int i = 0; i < 20; i++) {
      final x = (size.width * (i / 20)) + (animationValue * 50);
      final y =
          size.height * 0.5 + (animationValue * 30 * (i % 2 == 0 ? 1 : -1));

      canvas.drawCircle(
        Offset(x % size.width, y % size.height),
        2 + (animationValue * 1),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Scanline Effect Painter
class ScanlinePainter extends CustomPainter {
  final double animationValue;
  final Color primaryColor;

  ScanlinePainter({required this.animationValue, required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent, 
          primaryColor.withOpacity(0.3),
          primaryColor.withOpacity(0.1),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, 20));

    final y = size.height * animationValue;
    canvas.drawRect(Rect.fromLTWH(0, y - 10, size.width, 20), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}