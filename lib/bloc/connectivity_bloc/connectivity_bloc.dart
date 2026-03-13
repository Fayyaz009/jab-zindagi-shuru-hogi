import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/services/connectivity_service.dart';

// Events
abstract class ConnectivityEvent extends Equatable {
  const ConnectivityEvent();
  @override
  List<Object> get props => [];
}

class ConnectivityChanged extends ConnectivityEvent {
  final ConnectivityStatus status;
  const ConnectivityChanged(this.status);
  @override
  List<Object> get props => [status];
}

// States
abstract class ConnectivityState extends Equatable {
  final ConnectivityStatus status;
  const ConnectivityState(this.status);
  @override
  List<Object> get props => [status];
}

class ConnectivityInitial extends ConnectivityState {
  const ConnectivityInitial() : super(ConnectivityStatus.online);
}

class ConnectivityUpdate extends ConnectivityState {
  const ConnectivityUpdate(super.status);
}

// Bloc
class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final ConnectivityService _connectivityService;
  StreamSubscription? _subscription;

  ConnectivityBloc(this._connectivityService) : super(const ConnectivityInitial()) {
    on<ConnectivityChanged>((event, emit) {
      emit(ConnectivityUpdate(event.status));
    });

    _subscription = _connectivityService.connectivityStream.listen((status) {
      add(ConnectivityChanged(status));
    });

    // Check initial status
    _init();
  }

  void _init() async {
    final status = await _connectivityService.checkConnectivity();
    add(ConnectivityChanged(status));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
