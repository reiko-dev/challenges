import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fourier_series/a%20old%20stuff/complex_dft/complex_dft_algorithm.dart';
import 'package:fourier_series/a%20old%20stuff/fourier_painters/dft_painter.dart';

class DFTWithTwoEpyciclesWithCompute extends StatefulWidget {
  const DFTWithTwoEpyciclesWithCompute(this.drawingList, this.skip)
      : assert(skip > 0);
  final List<List<Offset>> drawingList;
  final int skip;

  @override
  createState() => _DFTWithTwoEpyciclesWithComputeState();
}

class _DFTWithTwoEpyciclesWithComputeState
    extends State<DFTWithTwoEpyciclesWithCompute>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  bool isLoaded = false;
  Map<String, dynamic> dataToCompute = {};

  @override
  void initState() {
    super.initState();
    dataToCompute = {
      'drawing': widget.drawingList,
      'skip': widget.skip,
    };
    controller = AnimationController(
      duration: Duration(milliseconds: 3500),
      vsync: this,
    );
    loadData();
    print('initState end');
  }

  Future<void> loadData() async {
    List<Future> futuresList = [];
    dataToCompute['drawing'].forEach((List<Offset> points) {
      futuresList.add(
        compute(
          computeDrawingData,
          {'skip': dataToCompute['skip'], 'drawing': points},
        ),
      );
    });

    dataToCompute['fourierX'] = [];
    dataToCompute['fourierY'] = [];

    await Future.wait(futuresList).then(
      (value) {
        value.forEach((element) {
          dataToCompute['fourierX']
              .add(element['fourierX'] as List<Map<String, dynamic>>);
          dataToCompute['fourierY']
              .add(element['fourierY'] as List<Map<String, dynamic>>);
        });
      },
    );

    isLoaded = true;
    setState(() {});
    print('Computing finished');
  }

  @override
  void dispose() {
    if (controller.isAnimating) controller.stop();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (!isLoaded)
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: SizedBox(
                width: 100,
                height: 30,
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        if (isLoaded)
          AnimatedBuilder(
            animation: controller,
            builder: (_, __) => CustomPaint(
              painter: DFTPainter(
                controller,
                dataToCompute['fourierX'][0],
                dataToCompute['fourierY'][0],
              ),
            ),
          ),
      ],
    );
  }
}
