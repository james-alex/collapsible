# collapsible

A widget that implicitly collapses and expands around its child by clipping it.

# Usage

```dart
import 'package:collapsible/collapsible.dart';
```

[Collapsible] has three required parameters: [child], [collapsed], and [axis].

[child] provides the widget [Collapsible] wraps, while [collapsed] defines
the current state, whether its collapsed or not, and [axis] specifies whether
the collapsing/expanding animation should transition horizontally, vertically,
or along both axes.

```dart
/// When updated to `false` the [Collapsible] will expand, revealing its
/// child, and will collapse, hiding the child if set back to `true`.
var _collapsed = true;

/// A [Collapsible] built with its default parameters.
Collapsible(
  collapsed: _collapsed,
  axis: CollapsibleAxis.both,
  child: MyWidget(),
);
```

## Alignment

Depending on the [axis] of the transition and the [Collapsible]'s placement
within its parent, you'll likely want to change the [alignment] of the [child]
to match that of the [Collapsible]'s alignment within its parent.

```dart
/// When collapsing vertically and the [Collapsible] is aligned to
/// the top edge of its parent, the [child] will look best if aligned
/// to the top-center of the [Collapsible].
Collapsible(
  collapsed: _collapsed,
  axis: CollapsibleAxis.vertical,
  alignment: Alignment.topCenter,
  child: MyWidget(),
);
```

## Restricting the Size

The minimum width and height the [Collapsible] will collapse to can be provided
as factors that the [child]'s size will be multiplied by.

Specifying a minimum width/height factor can be a good idea if you want to
clip only a part of the [child] or if you'd like the child to continue
occupying space within its parent when collapsed.

```dart
/// A [Collapsible] that collapses to 20% of the width and 40% of the
/// height of its child.
Collapsible(
  collapsed: _collapsed,
  axis: CollapsibleAxis.both,
  minWidthFactor: 0.2,
  minHeightFactor: 0.4,
  child: MyWidget(),
);
```

## Fading

[Collapsible] has a parameter, [fade], that if set to `true`, will wrap the
[child] with an [AnimatedOpacity] widget, which will fade the child in/out
as the [Collapsible] expands/collapses.

The minimum opacity the [child] should fade to can be specified with the
[minOpacity] parameter, which defaults to `0.0` (0%).

```dart
/// A [Collapsible] that fades its child in/out as it expands/collapses,
/// fading it out to 20% opacity.
Collapsible(
  collapsed: _collapsed,
  axis: CollapsibleAxis.horizontal,
  fade: true,
  minOpacity: 0.2,
  child: MyWidget(),
);
```

## Curve

An easing curve can be applied to the animation with the [curve] parameter,
the curve will also be applied to the fading animation if [fade] is `true`.

[curve] defaults to `Curves.easeOut`.

```dart
/// A [Collapsible] whose animations start slowly then speed up.
Collapsible(
  collapsed: _collapsed,
  axis: CollapsibleAxis.both,
  curve: Curves.easeIn,
  fade: true,
  child: MyWidget(),
);
```

## Duration

The [duration] of the animation can also be provided, which defaults to 240ms.

```dart
/// A [Collapsible] that takes 1 second to expand/collapse around its child.
Collapsible(
  collapsed: _collapsed,
  axis: CollapsibleAxis.both,
  duration: Duration(seconds: 1),
  child: MyWidget(),
);
```

Depending on the [curve] you may want to provide a different duration
for the collapsing and expanding animations for a smoother appearance.

```dart
/// A [Collapsible] that takes 240ms to collapse and 360ms to expand.
Collapsible(
  collapsed: _collapsed,
  axis: CollapsibleAxis.both,
  duration: Duration(milliseconds: _collapsed ? 240 : 360),
  child: MyWidget(),
);
```

## State Management

### MaintainState

With the default settings, the [Collapsible] will replace the [child] with
a `SizedBox.shrink()` to free up the resources used by the [child]. This
means every time the [child] is revealed it will be built from a fresh state.

To prevent this, [maintainState] can be set to `true`, which will tell the
[Collapsible] to build the [child] once and keep it built.

```dart
/// A [Collapsible] that maintains the state of its child when the
/// child is hidden.
Collapsible(
  collapsed: _collapsed,
  axis: CollapsibleAxis.both,
  maintainState: true,
  child: MyWidget(),
);
```

[maintainState] will automatically be set to `true` if the [child] still
occupies any space when the [Collapsible] is in its collapsed space. This
occurs when [minWidthFactor] or [minHeightFactor] are greater than `0.0`
and the transition occurs along the horizontal or vertical axes respectively.

### MaintainAnimation

By default, the [Collapsible] will stop any of the childs', or its sub-trees',
animation tickers when in the collapsed state. [maintainAnimation] can be
set to `true` to keep them running.

```dart
/// A [Collapsible] that maintains the animations of its child when collapsed.
Collapsible(
  collapsed: _collapsed,
  axis: CollapsibleAxis.both,
  maintainAnimation: true,
  child: MyWidget(),
);
```

Setting [maintainAnimation] to `true` will automatically set [maintainState]
to `true`, but unlike [maintainState], [maintainAnimation] will remain
`false` even if part of the child is still in view when collapsed, it must
be set to `true` to keep the tickers active.
