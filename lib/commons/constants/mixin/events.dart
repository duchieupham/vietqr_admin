import 'package:event_bus/event_bus.dart';

EventBus eventBus = EventBus();

class GetListConnect {
  GetListConnect();
}

class RefreshLog {
  final bool envGoLive;
  RefreshLog({this.envGoLive = false});
}

class ResetDateLog {
  ResetDateLog();
}

class RefreshTransaction {
  RefreshTransaction();
}

class RefreshServicePackList {
  RefreshServicePackList();
}

class RefreshListActiveFee {
  RefreshListActiveFee();
}

class RefreshListAnnualFee {
  RefreshListAnnualFee();
}

class RefreshTransactionVNPTPage {
  RefreshTransactionVNPTPage();
}
