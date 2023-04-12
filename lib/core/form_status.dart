abstract class FormStatus {
  const FormStatus();
}

class FormNotSent extends FormStatus {
  const FormNotSent();
}

class FormSubmitting extends FormStatus {
  const FormSubmitting();
}

class FormSubmissionFailed extends FormStatus {
  final String message;
  const FormSubmissionFailed({required this.message});
}

class FormSubmissionSuccessful extends FormStatus {
  const FormSubmissionSuccessful();
}