import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SpinnerWidget extends StatelessWidget {
  const SpinnerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Center(
        child: SpinKitCircle(
          color: Colors.grey,
          size: 50.0,
        ),
      ),
    );
  }
}
