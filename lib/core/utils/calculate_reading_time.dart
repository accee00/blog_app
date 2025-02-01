int calculateReadingTime(String content) {
  final wordCount = content.split(RegExp(r'\s+')).length;
  final redingTime = wordCount / 225;
  // ceil will take the highest number possible.
  return redingTime.ceil();
}
