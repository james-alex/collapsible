import 'package:flutter/widgets.dart';

/// The axes a [Collapsible] collapses/expands its child along.
enum CollapsibleAxis {
  /// The [Collapsible] will collapse/expand its child along the x-axis.
  horizontal,

  /// The [Collapsible] will collapse/expand its child along the y-axis.
  vertical,

  /// The [Collapsbile] will collapse/expand its child along both axes.
  both,
}

/// A widget that implicitly collapses and expands around its child by clipping it.
class Collapsible extends StatefulWidget {
  /// A widget that implicitly collapses and expands around its child by clipping it.
  ///
  /// A [child] must be provided, it must not be `null`.
  ///
  /// [collapsed] defines the current state, the child will implicity
  /// collapse or expand when [collapsed] is updated.
  ///
  /// [axis] defines the axes the child will collapse/expand upon.
  ///
  /// [alignment] defines the position of the [child] within the [ClipRect]
  /// that wraps it, it should be modified for a cleaner animation depending
  /// upon the [Collapsible]'s position within its parent.
  ///
  /// [minWidthFactor] and [minHeightFactor] define the values the width
  /// and height of the [child] will be factored by when the in the collapsed
  /// state. [minWidthFactor] will have no effect if [axis] equals
  /// `CollapsibleAxis.vertical`, likewise [minHeightFactor] will have no
  /// effect if [axis] equals `CollapsibleAxis.horizontal`.
  ///
  /// If [fade] is `true`, the [child]'s opacity will transition to
  /// [minOpacity] when collapsing, and to `1.0` when expanding.
  /// [minOpacity] will have no effect on the [child] if [fade] is `false`.
  ///
  /// [duration] defines the duration of the collapsing/expanding animation.
  ///
  /// [curve] is the easing curve applied to the collapsing/expanding
  /// animation, as well as the fading animation if [fade] is `true`.
  ///
  /// [onComplete] is a callback called each time the animation completes.
  ///
  /// If [maintainState] is `true`, the state of the [child] will be maintained
  /// when in the collapsed state. [maintainState] will be set to `true` by
  /// default if [minWidthFactor] or [minHeightFactor] is `> 0.0` and [axis]
  /// affects the horizontal or vertical axes respectively, as the [child] will
  /// still occupy space when in the collapsed state in those cases.
  ///
  /// If [maintainState] is `false`, in order to free up the sources used by
  /// the [child], it will be replaced with a `SizedBox.shrink()` when in the
  /// collapsed state.
  ///
  /// If [maintainAnimation] is `false`, the [child] and its sub-tree's
  /// animation tickers, if there are any, will be paused when in the collapsed
  /// state, if `true`, they will continue running. The tickers will be paused
  /// regardless of whether the child is still visible in the collapsed state
  /// unless [maintainAnimation] is set to `true`.
  const Collapsible({
    Key key,
    @required this.child,
    @required this.collapsed,
    @required this.axis,
    this.alignment = Alignment.center,
    this.minWidthFactor = 0.0,
    this.minHeightFactor = 0.0,
    this.fade = false,
    this.minOpacity = 0.0,
    this.duration = const Duration(milliseconds: 240),
    this.curve = Curves.easeOut,
    this.clipBehavior = Clip.hardEdge,
    this.onComplete,
    bool maintainState = false,
    this.maintainAnimation = false,
  })  : assert(child != null),
        assert(collapsed != null),
        assert(axis != null),
        assert(alignment != null),
        assert(minWidthFactor != null &&
            minWidthFactor >= 0.0 &&
            minWidthFactor <= 1.0),
        assert(minHeightFactor != null &&
            minHeightFactor >= 0.0 &&
            minHeightFactor <= 1.0),
        assert(fade != null),
        assert(minOpacity != null && minOpacity >= 0.0 && minOpacity <= 1.0),
        assert(duration != null),
        assert(curve != null),
        assert(maintainState != null),
        assert(maintainAnimation != null),
        maintainState = maintainState ||
            maintainAnimation ||
            (axis != CollapsibleAxis.vertical && minWidthFactor > 0.0) ||
            (axis != CollapsibleAxis.horizontal && minHeightFactor > 0.0),
        super(key: key);

  /// The components contained within the sub-menu.
  final Widget child;

  /// The state of the sub-menu, whether it's visible or not.
  final bool collapsed;

  /// The axes the widget will collapse/expand along.
  final CollapsibleAxis axis;

  /// If `true`, the [child] will fade in/out during the
  /// collapsing/expanding animation.
  final bool fade;

  /// The value the width of the child is multiplied by when
  /// the widget is in its collapsed state.
  ///
  /// [minWidthFactor] will not affect the size of the child if
  /// [axis] equals `CollapsibleAxis.vertical`.
  final double minWidthFactor;

  /// The value the height of the child is multiplied by when
  /// the widget is in its collapsed state.
  ///
  /// [minHeightFactor] will not affect the size of the child if
  /// [axis] equals `CollapsibleAxis.horizontal`.
  final double minHeightFactor;

  /// If [fade] is `true`, the opacity will be transitioned to
  /// [minOpacity] when the widget is in its collapsed state.
  final double minOpacity;

  /// The duration of the collapsing/expanding animation.
  final Duration duration;

  /// The alignment of the [child] within the [ClipRect] wrapping it.
  final AlignmentGeometry alignment;

  /// The easing curve applied to the collapsing/expanding animation.
  final Curve curve;

  /// The clipping behavior applied to the [ClipRect] that wraps the [child].
  final Clip clipBehavior;

  /// A callback called every time the animation completes.
  final VoidCallback onComplete;

  /// If `false`, the [child] will be replaced with a `SizedBox.shrink()`
  /// when the [Collapsible] is in its collapsed state, if `true`, the
  /// [child] will remain built when collapsed.
  ///
  /// [maintainState] will be set to `true` by default if [minWidthFactor]
  /// or [minHeightFactor] is `> 0.0` and [axis] affects the horizontal or
  /// vertical axes respectively, as the [child] will still occupy space
  /// when in the collapsed state in those cases.
  final bool maintainState;

  /// If `false`, the [child] and its sub-tree's animation tickers, if it
  /// has any, will be paused when in the collapsed state, if `true`, they
  /// will continue running.
  ///
  /// The tickers will be paused regardless of whether the child is still
  /// visible in the collapsed state unless [maintainAnimation] is set to
  /// `true`.
  final bool maintainAnimation;

  @override
  _CollapsibleState createState() => _CollapsibleState();
}

class _CollapsibleState extends State<Collapsible> {
  /// Returns `true` if the widget collapses/expands along the y-axis.
  bool get _vertical =>
      widget.axis == CollapsibleAxis.vertical ||
      widget.axis == CollapsibleAxis.both;

  /// Returns `true` if the widget collapses/expands along the x-axis.
  bool get _horizontal =>
      widget.axis == CollapsibleAxis.horizontal ||
      widget.axis == CollapsibleAxis.both;

  /// Whether the child is currently visible, fills any space, has
  /// an active animation, or its state should be maintained.
  bool _maintainChild = true;

  @override
  void initState() {
    super.initState();

    if (!widget.maintainAnimation && widget.collapsed) {
      _maintainChild = false;
    }
  }

  @override
  void didUpdateWidget(Collapsible oldWidget) {
    if (!widget.collapsed) {
      _maintainChild = true;
    }

    super.didUpdateWidget(oldWidget);
  }

  /// Sets [_maintainChild] to `false` if the widget is in the collapsed state.
  ///
  /// [_toggleChild] is only called if [widget.maintainState] and
  /// [widget.maintainAnimation] are both `false`.
  void _toggleChild() {
    if (!widget.maintainState &&
        !widget.maintainAnimation &&
        widget.collapsed) {
      _maintainChild = false;
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // Replace the child with a [SizedBox] if its not visible
    // and the state doesn't need to be maintained.
    if (!_maintainChild && !widget.maintainState) {
      return SizedBox.shrink();
    }

    return TickerMode(
      enabled: _maintainChild,
      child: ClipRect(
        clipBehavior: widget.clipBehavior,
        child: AnimatedAlign(
          alignment: widget.alignment,
          heightFactor:
              _vertical && widget.collapsed ? widget.minHeightFactor : 1.0,
          widthFactor:
              _horizontal && widget.collapsed ? widget.minWidthFactor : 1.0,
          duration: widget.duration,
          curve: widget.curve,
          onEnd: () {
            if (widget.onComplete != null) widget.onComplete();
            _toggleChild();
          },
          child: widget.fade
              ? AnimatedOpacity(
                  opacity: widget.collapsed ? widget.minOpacity : 1.0,
                  duration: widget.duration,
                  curve: widget.curve,
                  child: widget.child,
                )
              : widget.child,
        ),
      ),
    );
  }
}
