enum ChatUserRole {
  student('Student'),
  teacher('Teacher'),
  guardian('Guardian'),
  staff('Staff');

  const ChatUserRole(this.value);

  final String value;

  static ChatUserRole fromString(String value) =>
      ChatUserRole.values.firstWhere(
        (e) => e.value == value,
        orElse: () => ChatUserRole.student,
      );
}
