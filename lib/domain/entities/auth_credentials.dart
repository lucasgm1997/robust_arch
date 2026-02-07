sealed class AuthCredentials {
  const AuthCredentials();
}

final class EmailCredentials extends AuthCredentials {
  const EmailCredentials({required this.email, required this.password});

  final String email;
  final String password;
}

final class GoogleCredentials extends AuthCredentials {
  const GoogleCredentials({required this.idToken});

  final String idToken;
}

final class AppleCredentials extends AuthCredentials {
  const AppleCredentials({required this.identityToken});

  final String identityToken;
}

final class PhoneCredentials extends AuthCredentials {
  const PhoneCredentials({required this.phoneNumber, required this.smsCode});

  final String phoneNumber;
  final String smsCode;
}
