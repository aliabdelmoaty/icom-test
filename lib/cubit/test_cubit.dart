import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/api_constant.dart';
import 'package:test/core/dio_helper.dart';
import 'package:test/models/account/account_model.dart';
import '../core/secure_storage.dart';
import '../models/add_comment_response.dart';
import '../models/comments_response.dart';

part 'test_state.dart';

class TestCubit extends Cubit<TestState> {
  TestCubit() : super(TestInitial());

  final DioHelper _dioHelper = DioHelper();
  bool isPasswordVisible = false;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    emit(PasswordVisibilityToggled(isPasswordVisible));
  }

  Future<void> login(String login, String password) async {
    emit(LoginLoading());
    try {
      final response = await _dioHelper.post(ApiConstants.loginEndpoint, {
        'login': login,
        'password': password,
      });
      if (response.statusCode == 200) {
        final token = response.data['token'];
        log(response.data.toString());
        await SecureStorage.saveToken(token);
        emit(LoginSuccess());
      } else {
        String errorMessage = 'Login failed';
        if (response.statusCode == 400 && response.data != null) {
          final errorData = response.data;
          final String code = errorData['code'] ?? '';
          final String message = errorData['message'] ?? '';
          switch (code) {
            case 'user_not_exist':
              errorMessage = 'User not exist';
              break;
            case 'wrong_password':
              errorMessage = 'Wrong password';
              break;
            default:
              errorMessage = message.isNotEmpty ? message : 'Login failed';
          }
        } else {
          errorMessage = response.statusMessage ?? 'Login failed';
        }

        log('Login failed Cubit: $errorMessage');
        emit(LoginFailure(errorMessage));
      }
    } catch (e) {
      log('Error occurred while logging in Cubit: $e');
      emit(LoginFailure(e.toString()));
    }
  }

  Future<AccountModel> getAccount() async {
    emit(GetAccountLoading());
    try {
      final response = await _dioHelper.get(ApiConstants.accountEndpoint);
      if (response.statusCode == 200) {
        final account = AccountModel.fromJson(response.data);
        emit(GetAccountSuccess(account));
        return account;
      } else if (response.statusCode == 400) {
        String errorMessage = 'Failed to get account';
        if (response.data != null &&
            response.data['errors'] != null &&
            response.data['errors']['invalid_token'] != null &&
            response.data['errors']['invalid_token'].isNotEmpty) {
          errorMessage = response.data['errors']['invalid_token'][0];
        }
        emit(GetAccountFailure(errorMessage));
        return const AccountModel.empty();
      } else {
        emit(
          GetAccountFailure(response.statusMessage ?? 'Failed to get account'),
        );
      }
    } catch (e) {
      emit(GetAccountFailure(e.toString()));
    }
    return const AccountModel.empty();
  }

  Future<void> addComment(int lessonId, String commentText) async {
    emit(AddCommentLoading());
    try {
      final response = await _dioHelper.put(ApiConstants.addCommentEndpoint, {
        'id': lessonId,
        'comment': commentText,
        'parent': 0,
      });

      if (response.statusCode == 200) {
        final addCommentResponse = AddCommentResponse.fromJson(response.data);
        emit(AddCommentSuccess(addCommentResponse));
      } else {
        String errorMessage = _parseCommentError(response);
        log('Add comment failed: $errorMessage');
        emit(AddCommentFailure(errorMessage));
      }
    } catch (e) {
      log('Error occurred while adding comment: $e');
      emit(AddCommentFailure('Failed to add comment: ${e.toString()}'));
    }
  }

  Future<void> getComments(int lessonId) async {
    emit(GetCommentsLoading());
    try {
      final response = await _dioHelper.post(ApiConstants.addCommentEndpoint, {
        'id': lessonId,
      });

      if (response.statusCode == 200) {
        final commentsResponse = CommentsResponse.fromJson(response.data);
        emit(GetCommentsSuccess(commentsResponse));
      } else {
        String errorMessage = _parseCommentError(response);
        log('Get comments failed: $errorMessage');
        emit(GetCommentsFailure(errorMessage));
      }
    } catch (e) {
      log('Error occurred while getting comments: $e');
      emit(GetCommentsFailure('Failed to load comments: ${e.toString()}'));
    }
  }

  String _parseCommentError(response) {
    if (response.data != null) {
      if (response.data['code'] != null) {
        final code = response.data['code'];
        final message = response.data['message'] ?? '';
        switch (code) {
          case 'rest_no_route':
            return 'Invalid request. Please try again.';
          case 'rest_invalid_json':
            return 'Invalid data format. Please check your input.';
          default:
            return message.isNotEmpty ? message : 'Request failed';
        }
      }
      if (response.data['errors'] != null) {
        final errors = response.data['errors'];
        if (errors['invalid_token'] != null) {
          return 'Your session has expired. Please login again.';
        }
        if (errors['empty_comment'] != null) {
          return errors['empty_comment'][0] ?? 'Comment error occurred';
        }
      }
      if (response.data['message'] != null) {
        return response.data['message'];
      }
    }
    switch (response.statusCode) {
      case 400:
        return 'Invalid request. Please check your input.';
      case 401:
        return 'Authentication failed. Please login again.';
      case 404:
        return 'Resource not found. Please try again.';
      default:
        return response.statusMessage ?? 'Something went wrong';
    }
  }
}
