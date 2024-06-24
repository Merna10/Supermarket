import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthenticationBloc() : super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is UserLoggedIn) {
      yield* _mapUserLoggedInToState();
    } else if (event is UserLoggedOut) {
      yield* _mapUserLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      // Check if user is already authenticated
      User? user = _auth.currentUser;
      if (user != null) {
        yield AuthenticationAuthenticated(user);
      } else {
        yield AuthenticationUnauthenticated();
      }
    } catch (e) {
      // Handle error
      yield AuthenticationUnauthenticated();
    }
  }

  Stream<AuthenticationState> _mapUserLoggedInToState() async* {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        yield AuthenticationAuthenticated(user);
      }
    } catch (e) {
      // Handle error
    }
  }

  Stream<AuthenticationState> _mapUserLoggedOutToState() async* {
    try {
      await _auth.signOut();
      yield AuthenticationUnauthenticated();
    } catch (e) {
      // Handle error
    }
  }
}
