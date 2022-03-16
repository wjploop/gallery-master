main() {
  Stream<int> getRange(int start, int end) async* {
    for (int i = start; i <= end; i++) {
      await Future.delayed(Duration(seconds: 2));
      yield i;
    }
  }

  Stream<int> str(int n) async*{
    if(n > 0){
      await Future.delayed(Duration(seconds: 1));
      yield n;
      yield* str(n-1);
    }
  }
  getRange(1, 4).forEach((element) {
    print(element);
  });

}