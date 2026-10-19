class Range {
  const Range({
    required this.min,
    required this.max,
  });

  final double min;
  final double max;

  double interpolate(double t) {
    return min + t * (max - min);
  }
}
