import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:market/modules/authentication/data/repositories/authentication_repository.dart';
import 'package:market/modules/cart/data/repositories/cart_repository.dart';
import 'package:market/modules/cart/data/services/hive_services.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final OrderRepository _cartRepository;
  late final StreamSubscription<User?> _userSubscription;

  AuthBloc({
    required AuthRepository authRepository,
    required OrderRepository cartRepository,
  })  : _authRepository = authRepository,
        _cartRepository = cartRepository,
        super(AuthInitial()) {
    _userSubscription = _authRepository.user.listen(
      (user) {
        if (user != null) {
          add(AuthCheckStatusEvent());
        } else {}
      },
    )..onError((error) {
        emit(AuthError('Error in user stream: ${error.toString()}'));
      });

    on<AuthSignUpEvent>(_onSignUp);
    on<AuthLoginEvent>(_onLogin);
    on<AuthLogoutEvent>(_onLogout);
    on<AuthCheckStatusEvent>(_onCheckStatus);
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }

  void _onSignUp(AuthSignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepository.signUp(
        event.email,
        event.password,
        event.userName,
        event.phoneNumber,
        event.role,
      );
      add(AuthCheckStatusEvent());
    } catch (e) {
      emit(AuthError('Sign up failed: ${e.toString()}'));
    }
  }

  Future<void> _onLogin(AuthLoginEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());

      await _authRepository.login(event.email, event.password);

      add(AuthCheckStatusEvent());

      await _transferCartData();
    } catch (e) {
      emit(AuthError('Login failed: $e'));
    }
  }

  void _onLogout(AuthLogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepository.logout();
      await HiveService().clearCart();
      add(AuthCheckStatusEvent());
    } catch (e) {
      emit(AuthError('Logout failed: ${e.toString()}'));
    }
  }

  Future<void> _transferCartData() async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;

    if (userId != null) {
      final hiveService = HiveService();
      final cartItems = await hiveService.getCartItems();
      final cartData = cartItems.map((item) => item.toMap()).toList();

      await _cartRepository.saveCartToUser(userId, cartData);
      await hiveService.clearCart();
    }
  }

  Future<void> _onCheckStatus(
      AuthCheckStatusEvent event, Emitter<AuthState> emit) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final role = await _authRepository.getUserRole(); // Fetch user role
        emit(AuthAuthenticated(role: role));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (error) {
      emit(AuthError(error.toString()));
    }
  }
}
