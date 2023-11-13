import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';

class Seperator extends StatelessWidget {
  const Seperator({super.key});

  @override
  Widget build(BuildContext context) {
    return Dash(
      dashColor: Colors.grey,
      dashLength: 3,
      direction: Axis.horizontal,
      length: MediaQuery.of(context).size.width - 60,
      dashThickness: 2,
      dashGap: 5,
    );
  }
}
