enum Sex {
  male('Male'),
  female('Female');

  const Sex(this.value);

  final String value;
}

enum Difficulty {
  beginner('Beginner'),
  intermediate('Intermediate'),
  pro('Pro');

  const Difficulty(this.value);

  final String value;
}

enum Intensity {
  low('Low'),
  medium('Medium'),
  high('High');

  const Intensity(this.value);

  final String value;
}
