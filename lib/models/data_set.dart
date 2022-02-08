class DataSet {
  final String title;
  final List<num> data;
  final num? sum;
  final int fractionDigits;

  DataSet({
    this.title = '',
    required this.data,
    this.sum,
    this.fractionDigits = 3,
  });
}
