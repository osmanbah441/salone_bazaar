final class FormFields {
  static bool validate(List<FormInput> inputs) =>
      inputs.every((i) => i.isValid);
}


abstract class FormInput<T, E> {
  const FormInput._(this.value, this.shouldValidate);

  const FormInput.unvalidated(T value) : this._(value, false);
  const FormInput.validated(T value) : this._(value, true);

  final T value;
  final bool shouldValidate;

  E? get error => shouldValidate ? validator(value) : null;

  bool get isValid => error == null;

  E? validator(T value);
}
