import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:happy_tummy_web/repositories/restaurantRepository.dart';
import 'package:happy_tummy_web/ui/validators.dart';
import 'package:meta/meta.dart';
import './bloc.dart';
import 'package:rxdart/rxdart.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  RestaurantRepository _restaurantRepository;

  SignUpBloc({@required RestaurantRepository restaurantRepository})
      : assert(restaurantRepository != null),
        _restaurantRepository = restaurantRepository;

  @override
  SignUpState get initialState => SignUpState.empty();

  @override
  Stream<SignUpState> transformEvents(
    Stream<SignUpEvent> events,
    Stream<SignUpState> Function(SignUpEvent event) next,
  ) {
    final nonDebounceStream = events.where((event) {
      return (event is! EmailChanged || event is! PasswordChanged);
    });

    final debounceStream = events.where((event) {
      return (event is EmailChanged || event is PasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));

    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      next,
    );
  }

  @override
  Stream<SignUpState> mapEventToState(
    SignUpEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is SignUpWithCredentialsPressed) {
      yield* _mapSignUpWithCredentialsPressedToState(
          email: event.email, password: event.password);
    }
  }

  Stream<SignUpState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<SignUpState> _mapPasswordChangedToState(String password) async* {
    yield state.update(isEmailValid: Validators.isValidPassword(password));
  }

  Stream<SignUpState> _mapSignUpWithCredentialsPressedToState({
    String email,
    String password,
  }) async* {
    yield SignUpState.loading();

    try {
      await _restaurantRepository.signUpWithEmail(email, password);

      yield SignUpState.success();
    } catch (_) {
      SignUpState.failure();
    }
  }
}