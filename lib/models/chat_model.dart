import 'package:scoped_model/scoped_model.dart';
class ConnectModel extends Model {
  String connect1;
  change() {
    connect1 = "ConnectivityResult.none";
    notifyListeners();
  }
  data() {
    connect1 = "data";
    notifyListeners();
  }
}