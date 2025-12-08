import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/services/business_hours.service.dart';
import 'business_status_state.dart';

@injectable
class BusinessStatusCubit extends Cubit<BusinessStatusState> {
  final BusinessHoursService _businessHoursService;

  BusinessStatusCubit(this._businessHoursService)
    : super(const BusinessStatusInitial());

  void checkBusinessStatus() {
    if (!_businessHoursService.isOpen()) {
      emit(
        BusinessClosed(
          message: 'Lo sentimos, actualmente no estamos aceptando pedidos.',
          nextOpeningTime: _businessHoursService.getNextOpeningTime(),
          schedule: _businessHoursService.getBusinessHoursMessage(),
        ),
      );
    } else if (_businessHoursService.isClosingSoon()) {
      emit(
        const BusinessClosingSoon(
          '¡Atención! Estaremos cerrando en breve. Asegúrate de completar tu pedido pronto.',
        ),
      );
    } else {
      emit(const BusinessOpen());
    }
  }
}
