extension TruncateText on String {
  String truncate(int maxLength) {
    if (length > maxLength) {
      return '${substring(0, maxLength)}...';
    }
    return this;
  }
}