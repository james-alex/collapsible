import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:collapsible/collapsible.dart';

void main() {
  testWidgets('Collapses/Expands', (WidgetTester tester) async {
    final child = Container();

    await tester.pumpWidget(Collapsible(
      collapsed: true,
      axis: CollapsibleAxis.both,
      child: child,
    ));

    expect(find.byWidget(child), findsNothing);
    expect(find.byType(SizedBox), findsOneWidget);

    await tester.pumpWidget(Collapsible(
      collapsed: false,
      axis: CollapsibleAxis.both,
      child: child,
    ));

    expect(find.byWidget(child), findsOneWidget);
    expect(find.byType(SizedBox), findsNothing);

    await tester.pumpAndSettle();

    await tester.pumpWidget(Collapsible(
      collapsed: true,
      axis: CollapsibleAxis.both,
      child: child,
    ));

    expect(find.byWidget(child), findsOneWidget);
    expect(find.byType(SizedBox), findsNothing);

    await tester.pumpAndSettle();

    expect(find.byWidget(child), findsNothing);
    expect(find.byType(SizedBox), findsOneWidget);
  });
}
