extension ListExtensions<T> on List<T> {
  E? firstWhereType<E>() {
    final Iterator<T> it = iterator;

    while (it.moveNext()) {
      if (it.current is E) {
        return it.current as E;
      }
    }

    return null;
  }
}
