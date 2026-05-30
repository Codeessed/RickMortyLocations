import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rick_morty_flutter/app/app.dart';

void main() {
  testWidgets('App boots and shows Locations title', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: App()),
    );

    // The placeholder screen should show the "Locations" title
    expect(find.text('Locations'), findsAtLeastNWidgets(1));
  });
}
