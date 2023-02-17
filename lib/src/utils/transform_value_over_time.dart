double transformValueOverTime(double value, double target, double frameTime, double speed) {
  // Calculate the distance between the current value and the target.
  final double distance = target - value;

  // Calculate the time it would take to move from value to target at the given speed.
  final double transformTime = distance / speed;

  // If the movement time is less than or equal to the frame time, return the target.
  if (transformTime.abs() <= frameTime) {
    return target;
  }

  // Check whether we need to add or subtract.
  final int positivityModifier = distance.isNegative ? -1 : 1;

  // Calculate the change to the value based on the speed and frame time.
  final double change = speed * frameTime * positivityModifier;

  // Return the new position after applying the change.
  return value + change;
}
