import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';


class RiskScoreCard extends StatefulWidget {
  final double score;

  const RiskScoreCard({Key? key, required this.score}) : super(key: key);

  @override
  State<RiskScoreCard> createState() => _RiskScoreCardState();
}

class _RiskScoreCardState extends State<RiskScoreCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0,
      end: widget.score,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    // Start animation after a small delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Risk Score',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return SfRadialGauge(
                    axes: <RadialAxis>[
                      RadialAxis(
                        minimum: 0,
                        maximum: 100,
                        startAngle: 180,
                        endAngle: 0,
                        showLabels: false,
                        showTicks: false,
                        axisLineStyle: const AxisLineStyle(
                          thickness: 20,
                          color: Color(0xFFE8E8E8),
                          cornerStyle: CornerStyle.bothCurve,
                        ),
                        ranges: <GaugeRange>[
                          GaugeRange(
                            startValue: 0,
                            endValue: 20,
                            color: const Color(0xFF2E7D32),
                            startWidth: 20,
                            endWidth: 20,
                          ),
                          GaugeRange(
                            startValue: 20,
                            endValue: 40,
                            color: const Color(0xFF66BB6A),
                            startWidth: 20,
                            endWidth: 20,
                          ),
                          GaugeRange(
                            startValue: 40,
                            endValue: 60,
                            color: const Color(0xFFFDD835),
                            startWidth: 20,
                            endWidth: 20,
                          ),
                          GaugeRange(
                            startValue: 60,
                            endValue: 80,
                            color: const Color(0xFFFF9800),
                            startWidth: 20,
                            endWidth: 20,
                          ),
                          GaugeRange(
                            startValue: 80,
                            endValue: 100,
                            color: const Color(0xFFE53935),
                            startWidth: 20,
                            endWidth: 20,
                          ),
                        ],
                        pointers: <GaugePointer>[
                          NeedlePointer(
                            value: _animation.value,
                            needleLength: 0.7,
                            needleStartWidth: 1.5,
                            needleEndWidth: 4,
                            needleColor: const Color(0xFF424242),
                            knobStyle: const KnobStyle(
                              knobRadius: 0.07,
                              color: Color(0xFF424242),
                            ),
                            enableAnimation: false,
                          ),
                        ],
                        annotations: <GaugeAnnotation>[
                          GaugeAnnotation(
                            widget: Text(
                              _animation.value.toInt().toString(),
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFE53935),
                              ),
                            ),
                            angle: 90,
                            positionFactor: 0.7,
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CreditScoreCard extends StatefulWidget {
  final double score;

  const CreditScoreCard({Key? key, required this.score}) : super(key: key);

  @override
  State<CreditScoreCard> createState() => _CreditScoreCardState();
}

class _CreditScoreCardState extends State<CreditScoreCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 300, // Start from minimum credit score
      end: widget.score,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    // Start animation after a small delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String getRiskCategory(double score) {
    if (score >= 750) return 'Low';
    if (score >= 650) return 'Medium';
    return 'High';
  }

  Color getScoreColor(double score) {
    if (score >= 750) return const Color(0xFF2E7D32);
    if (score >= 650) return const Color(0xFFFDD835);
    if (score >= 550) return const Color(0xFFFF9800);
    return const Color(0xFFE53935);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Credit Score',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  final currentScore = _animation.value;
                  final riskCategory = getRiskCategory(currentScore);
                  final scoreColor = getScoreColor(currentScore);

                  return Column(
                    children: [
                      Expanded(
                        child: SfRadialGauge(
                          axes: <RadialAxis>[
                            RadialAxis(
                              minimum: 300,
                              maximum: 900,
                              startAngle: 180,
                              endAngle: 0,
                              showLabels: false,
                              showTicks: false,
                              axisLineStyle: const AxisLineStyle(
                                thickness: 20,
                                color: Color(0xFFE8E8E8),
                                cornerStyle: CornerStyle.bothCurve,
                              ),
                              ranges: <GaugeRange>[
                                GaugeRange(
                                  startValue: 300,
                                  endValue: 420,
                                  color: const Color(0xFFE53935),
                                  startWidth: 20,
                                  endWidth: 20,
                                ),
                                GaugeRange(
                                  startValue: 420,
                                  endValue: 540,
                                  color: const Color(0xFFFF5722),
                                  startWidth: 20,
                                  endWidth: 20,
                                ),
                                GaugeRange(
                                  startValue: 540,
                                  endValue: 660,
                                  color: const Color(0xFFFF9800),
                                  startWidth: 20,
                                  endWidth: 20,
                                ),
                                GaugeRange(
                                  startValue: 660,
                                  endValue: 780,
                                  color: const Color(0xFFFDD835),
                                  startWidth: 20,
                                  endWidth: 20,
                                ),
                                GaugeRange(
                                  startValue: 780,
                                  endValue: 900,
                                  color: const Color(0xFF66BB6A),
                                  startWidth: 20,
                                  endWidth: 20,
                                ),
                              ],
                              pointers: <GaugePointer>[
                                NeedlePointer(
                                  value: currentScore,
                                  needleLength: 0.7,
                                  needleStartWidth: 1.5,
                                  needleEndWidth: 4,
                                  needleColor: const Color(0xFF424242),
                                  knobStyle: const KnobStyle(
                                    knobRadius: 0.07,
                                    color: Color(0xFF424242),
                                  ),
                                  enableAnimation: false,
                                ),
                              ],
                              annotations: <GaugeAnnotation>[
                                GaugeAnnotation(
                                  widget: Text(
                                    currentScore.toInt().toString(),
                                    style: TextStyle(
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold,
                                      color: scoreColor,
                                    ),
                                  ),
                                  angle: 90,
                                  positionFactor: 0.7,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Risk category : $riskCategory',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF666666),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}