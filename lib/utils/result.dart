/// What a repository hands back.
///
/// Note there is no distinct "unauthorised" case. A read that returns nothing
/// because a policy matched no rows arrives here as Ok with an empty list, and
/// is indistinguishable from a genuinely empty table.
sealed class Result<T> {
  const Result();

  R when<R>({
    required R Function(T value) ok,
    required R Function(Object error) failed,
  }) {
    final self = this;
    return switch (self) {
      Ok<T>() => ok(self.value),
      Failed<T>() => failed(self.error),
    };
  }
}

class Ok<T> extends Result<T> {
  const Ok(this.value);
  final T value;
}

class Failed<T> extends Result<T> {
  const Failed(this.error);
  final Object error;
}
