extension StringExtensions on String {
  String capitalFirstLetter() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
