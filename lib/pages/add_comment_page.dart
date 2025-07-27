import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/validators.dart';
import 'package:test/cubit/test_cubit.dart';
import 'package:test/widgets/common_widgets.dart';

class AddCommentPage extends StatelessWidget {
  final int lessonId;
  final String lessonTitle;

  const AddCommentPage({
    super.key,
    required this.lessonId,
    required this.lessonTitle,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController commentController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Comment - $lessonTitle'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<TestCubit, TestState>(
        listener: (context, state) {
          if (state is AddCommentSuccess) {
            commentController.clear();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.response.message),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
            Navigator.of(context).pop(true);
          } else if (state is AddCommentFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Your Comment',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: commentController,
                    validator: Validators.validateComment,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText: 'Write your comment here...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(16),
                    ),
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                  const SizedBox(height: 20),
                  AppButton(
                    text: 'Add Comment',
                    isLoading: state is AddCommentLoading,
                    onPressed:
                        state is AddCommentLoading
                            ? null
                            : () {
                              if (formKey.currentState!.validate()) {
                                context.read<TestCubit>().addComment(
                                  lessonId,
                                  commentController.text.trim(),
                                );
                              }
                            },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
