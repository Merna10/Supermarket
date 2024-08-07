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
 final OrderRepository _cartRepository; // Add CartRepository

  AuthBloc({
    required AuthRepository authRepository,
    required OrderRepository cartRepository, // Add CartRepository in constructor
  })  : _authRepository = authRepository,
        _cartRepository = cartRepository, // Initialize CartRepository
        super(AuthInitial()) {
    on<AuthSignUpEvent>(_onSignUp);
    on<AuthLoginEvent>(_onLogin);
    on<AuthLogoutEvent>(_onLogout);
    on<AuthCheckStatusEvent>(_onCheckStatus);
  }

  void _onSignUp(AuthSignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepository.signUp(
        event.email,
        event.password,
        event.userName,
        event.phoneNumber,
       
      );
      emit(AuthAuthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onLogin(AuthLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepository.login(event.email, event.password);
      emit(AuthAuthenticated());
      _transferCartData();
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onLogout(AuthLogoutEvent event, Emitter<AuthState> emit) async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;

    emit(AuthLoading());
    try {
      await _authRepository.logout();

      if (userId != null) {
        HiveService().clearCart();
      }

      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
 Future<void> _transferCartData() async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;

    if (userId != null) {
      final hiveService = HiveService();
      final cartItems = await hiveService.getCartItems();
      final cartData = cartItems.map((item) => item.toMap()).toList();

      await _cartRepository.saveCartToUser(userId, cartData); // Save cart to Firestore
      await hiveService.clearCart(); // Clear cart from Hive after transfer
    }
  }
  void _onCheckStatus(AuthCheckStatusEvent event, Emitter<AuthState> emit) {
    _authRepository.user.listen((user) {
      if (user != null) {
        emit(AuthAuthenticated());
      } else {
        emit(AuthUnauthenticated());
      }
    });
  }
}
