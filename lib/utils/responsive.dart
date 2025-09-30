import 'package:flutter/widgets.dart';

class ResponsiveContainer extends StatelessWidget {
  const ResponsiveContainer({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double maxContentWidth = width >= 900 ? 720 : 480;
        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: child,
          ),
        );
      },
    );
  }
}


