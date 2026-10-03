import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:packet_pal/features/onboarding/presentation/onboarding_screen.dart';
import 'package:packet_pal/features/scan/domain/edit_recipe.dart';
import 'package:packet_pal/features/scan/presentation/crop_view.dart';

import 'support/pump_app.dart';
import 'support/test_env.dart';

void main() {
  late TestEnv env;
  setUp(() async => env = await TestEnv.create());
  tearDown(() => env.dispose());

  testWidgets('onboarding has three skippable slides', (tester) async {
    await pumpApp(tester, const OnboardingScreen(), env: env);

    expect(find.text('Scans that stay on your phone'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Build application packets'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Honest and simple'), findsOneWidget);
    expect(find.text('Get started'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('dragging a crop handle moves that corner', (tester) async {
    CropQuad quad = CropQuad.full;
    final path = env.writeJpeg('crop.jpg', width: 300, height: 400);

    await pumpApp(
      tester,
      Scaffold(
        body: StatefulBuilder(
          builder: (context, setState) => SizedBox(
            width: 300,
            height: 400,
            child: CropView(
              imagePath: path,
              aspectRatio: 0.75,
              quad: quad,
              onChanged: (q) => setState(() => quad = q),
            ),
          ),
        ),
      ),
      env: env,
    );

    final handle = find.bySemanticsLabel('Top left corner of the crop area');
    expect(handle, findsOneWidget);
    await tester.drag(handle, const Offset(60, 80));
    await tester.pump();

    // The first few pixels of a drag are consumed by touch slop.
    expect(quad.topLeft.dx, inInclusiveRange(0.1, 0.2));
    expect(quad.topLeft.dy, inInclusiveRange(0.1, 0.2));
    expect(quad.bottomRight, const Offset(1, 1));
    await disposeApp(tester);
  });
}
