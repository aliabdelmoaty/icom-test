part of 'test_cubit.dart';

abstract class TestState extends Equatable {
  const TestState();

  @override
  List<Object> get props => [];
}

class TestInitial extends TestState {}

class LoginLoading extends TestState {}

class LoginSuccess extends TestState {
  const LoginSuccess();
  @override
  List<Object> get props => [];
}

class LoginFailure extends TestState {
  final String error;
  const LoginFailure(this.error);
  @override
  List<Object> get props => [error];
}

class GetAccountLoading extends TestState {}

class GetAccountSuccess extends TestState {
  final AccountModel account;
  const GetAccountSuccess(this.account);
  @override
  List<Object> get props => [account];
}

class GetAccountFailure extends TestState {
  final String error;
  const GetAccountFailure(this.error);
  @override
  List<Object> get props => [error];
}

class AddCommentLoading extends TestState {}

class AddCommentSuccess extends TestState {
  final AddCommentResponse response;
  const AddCommentSuccess(this.response);
  @override
  List<Object> get props => [response];
}

class AddCommentFailure extends TestState {
  final String error;
  const AddCommentFailure(this.error);
  @override
  List<Object> get props => [error];
}

class GetCommentsLoading extends TestState {}

class GetCommentsSuccess extends TestState {
  final CommentsResponse comments;
  const GetCommentsSuccess(this.comments);
  @override
  List<Object> get props => [comments];
}

class GetCommentsFailure extends TestState {
  final String error;
  const GetCommentsFailure(this.error);
  @override
  List<Object> get props => [error];
}

class PasswordVisibilityToggled extends TestState {
  final bool isVisible;
  const PasswordVisibilityToggled(this.isVisible);
  @override
  List<Object> get props => [isVisible];
}
