double transformValueOverTime(double value, double target, double frameTime, double speed) {
  // Calculate the distance between the current value and the target.
  double distance = target - value;

  // Calculate the time it would take to move from value to target at the given speed.
  double transformTime = distance / speed;

  // If the movement time is less than or equal to the frame time, return the target.
  if (transformTime <= frameTime) {
    return target;
  }

  // Otherwise, calculate the increment to the value based on the speed and frame time
  double increment = speed * frameTime;

  // Return the new position after applying the increment
  return value + increment;
}
