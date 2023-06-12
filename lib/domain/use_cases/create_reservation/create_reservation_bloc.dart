
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'create_reservation_event.dart';
part 'create_reservation_state.dart';
// peut-être pas besoin du bloc
class CreateReservationBloc extends Bloc<CreateReservationEvent, CreateReservationState> {
  CreateReservationBloc() : super(CreateReservationInitial()) {
    on<CreateReservationEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
