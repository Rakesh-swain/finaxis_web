import 'package:flutter/material.dart';

class AnalyticsView extends StatelessWidget {
  const AnalyticsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, c) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: const [
                      Expanded(child: _Panel(title: 'Revenue Trend', child: _LineChartPlaceholder())),
                      SizedBox(width: 16),
                      Expanded(child: _Panel(title: 'Loan Distribution', child: _LineChartPlaceholder()))
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: const [
                      Expanded(child: _Panel(title: 'Loan Type Composition', child: _DonutPlaceholder())),
                      SizedBox(width: 16),
                      Expanded(child: _Panel(title: 'Regional Applicant Spread (Map)', child: _MapPlaceholder())),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  final String title; final Widget child;
  const _Panel({required this.title, required this.child});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            const SizedBox(height: 12),
            SizedBox(height: 240, child: child),
          ],
        ),
      ),
    );
  }
}

class _LineChartPlaceholder extends StatefulWidget { const _LineChartPlaceholder({Key? key}) : super(key: key); @override State<_LineChartPlaceholder> createState() => _LineChartPlaceholderState(); }
class _LineChartPlaceholderState extends State<_LineChartPlaceholder> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  @override void initState(){ super.initState(); _c=AnimationController(vsync:this,duration:const Duration(seconds:2))..repeat(); }
  @override void dispose(){ _c.dispose(); super.dispose(); }
  @override Widget build(BuildContext context){
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        return CustomPaint(
          painter: _LinePainter(_c.value),
          child: Container(),
        );
      },
    );
  }
}

class _LinePainter extends CustomPainter {
  final double t; _LinePainter(this.t);
  @override void paint(Canvas canvas, Size size){
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final path = Path();
    for (int i=0;i<20;i++){
      final x = size.width * (i/19);
      final y = size.height * (0.5 + 0.3 * (i%2==0? (1-t):t));
      if(i==0) path.moveTo(x,y); else path.lineTo(x,y);
    }
    canvas.drawPath(path, paint);
  }
  @override bool shouldRepaint(covariant _LinePainter old)=> old.t!=t;
}

class _DonutPlaceholder extends StatelessWidget {
  const _DonutPlaceholder({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 180, height: 180,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(value: 0.7, strokeWidth: 24, color: Colors.indigo),
            const Text('70%')
          ],
        ),
      ),
    );
  }
}

class _MapPlaceholder extends StatelessWidget { const _MapPlaceholder({Key? key}) : super(key: key); @override Widget build(BuildContext context){ return Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), gradient: const LinearGradient(colors:[Color(0xFFE3F2FD), Color(0xFFFCE4EC)])), child: const Center(child: Icon(Icons.map, size: 72, color: Colors.black38))); }}
