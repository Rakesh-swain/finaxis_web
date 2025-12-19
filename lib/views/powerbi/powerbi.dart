import 'dart:ui_web';
import 'dart:js' as js;
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'dart:html' as html;

class PowerBIEmbedViewWithReport extends StatefulWidget {
  final String reportKey;
  final String reportName;

  const PowerBIEmbedViewWithReport({
    Key? key,
    required this.reportKey,
    required this.reportName,
  }) : super(key: key);

  @override
  State<PowerBIEmbedViewWithReport> createState() =>
      _PowerBIEmbedViewWithReportState();
}

class _PowerBIEmbedViewWithReportState
    extends State<PowerBIEmbedViewWithReport> {
  final String viewId =
      "powerbi-report-${DateTime.now().millisecondsSinceEpoch}";
  late html.IFrameElement iframe;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _registerViewFactory();
    _loadReportAfterBuild();
  }

  void _registerViewFactory() {
    platformViewRegistry.registerViewFactory(
      viewId,
      (int _) {
        iframe = html.IFrameElement()
          ..src = 'powerbi_embed.html'
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.display = 'block'
          ..style.position = 'absolute'
          ..style.top = '0'
          ..style.left = '0'
          ..allow = 'payment';

        iframe.onLoad.listen((_) {
          print('✅ iframe loaded successfully');
          Future.delayed(Duration(milliseconds: 500), () {
            _loadReport(widget.reportKey);
          });
        });

        return iframe;
      },
    );
  }

  void _loadReportAfterBuild() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: 1000), () {
        _loadReport(widget.reportKey);
      });
    });
  }

  void _loadReport(String reportKey) {
    try {
      print('📡 Attempting to load report: $reportKey');

      js.context['reportKey'] = reportKey;
      js.context.callMethod('eval', [
        '''
        if (window.frames.length > 0) {
          var iframeWindow = window.frames[0];
          if (iframeWindow && iframeWindow.loadPowerBIReport) {
            iframeWindow.loadPowerBIReport('$reportKey');
            console.log('Report loaded: $reportKey');
          }
        }
        '''
      ]);

      print('✅ Report load triggered: $reportKey');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("❌ Error loading report: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void didUpdateWidget(PowerBIEmbedViewWithReport oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.reportKey != widget.reportKey) {
      setState(() {
        isLoading = true;
      });
      _loadReport(widget.reportKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight.isFinite 
          ? constraints.maxHeight 
          : MediaQuery.of(context).size.height;
        final width = constraints.maxWidth.isFinite
          ? constraints.maxWidth
          : MediaQuery.of(context).size.width;

        return SingleChildScrollView(
          child: SizedBox(
            width: width,
            height: height,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.grey[50]!,
                    Colors.grey[100]!,
                  ],
                ),
              ),
              child: Column(
                children: [
                  // Beautiful Header
                  _buildHeader(),
                  // Report Container
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                        right: 16.0,
                        bottom: 16.0,
                      ),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: HtmlElementView(viewType: viewId),
                            ),
                          ),
                          // Loading Overlay
                          if (isLoading)
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white.withOpacity(0.9),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 60,
                                      height: 60,
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.blue.shade600,
                                        ),
                                        strokeWidth: 4,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      'Loading ${widget.reportName}...',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    // Map for beautiful icons and colors
    final reportInfo = {
      'balance': {
        'icon': '💰',
        'color': Colors.blue,
      },
      'transaction': {
        'icon': '💳',
        'color': Colors.green,
      },
      'expense': {
        'icon': '📊',
        'color': Colors.orange,
      },
      'alarming': {
        'icon': '⚠️',
        'color': Colors.red,
      },
      'foir': {
        'icon': '📋',
        'color': Colors.purple,
      },
      'dsr': {
        'icon': '📈',
        'color': Colors.indigo,
      },
      'cashflow': {
        'icon': '💵',
        'color': Colors.teal,
      },
    };

    final info = reportInfo[widget.reportKey] ?? {
      'icon': '📊',
      'color': Colors.blue,
    };

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            (info['color'] as Color),
            (info['color'] as Color),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: (info['color'] as Color).withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Container(
                  //   width: 60,
                  //   height: 60,
                  //   decoration: BoxDecoration(
                  //     color: Colors.white.withOpacity(0.2),
                  //     borderRadius: BorderRadius.circular(16),
                  //     border: Border.all(
                  //       color: Colors.white.withOpacity(0.4),
                  //       width: 2,
                  //     ),
                  //   ),
                  //   child: Center(
                  //     child: Text(
                  //       info['icon'] as String,
                  //       style: const TextStyle(fontSize: 32),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.reportName,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Analytics & Insights',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(0.8),
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                margin: EdgeInsets.only(left: 16),
                height: 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.4),
                      Colors.white.withOpacity(0.1),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}