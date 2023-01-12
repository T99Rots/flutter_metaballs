class Range {
  const Range({
    required this.min,
    required this.max,
  }) : assert(min <= max);

  const Range.fromValue(double value)
      : min = value,
        max = value;

  /// The minimum value.
  final double min;

  /// The maximum value.
  final double max;

  /// Interpolate between the min and max value using [t].
  double interpolate(double t) {
    return min + (max - min) * t;
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'Range(min: $min, max: $max)';
  }
}
