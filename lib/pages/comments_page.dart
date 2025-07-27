import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/cubit/test_cubit.dart';
import 'package:test/models/comment_model.dart';
import 'package:test/widgets/comment_card.dart';
import 'package:test/widgets/common_widgets.dart';

class CommentsPage extends StatelessWidget {
  final int lessonId;
  final String lessonTitle;

  const CommentsPage({
    super.key,
    required this.lessonId,
    required this.lessonTitle,
  });

  @override
  Widget build(BuildContext context) {
    context.read<TestCubit>().getComments(lessonId);
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments - $lessonTitle'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<TestCubit, TestState>(
        listener: (context, state) {
          if (state is GetCommentsFailure) {
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
          if (state is GetCommentsLoading) {
            return const LoadingWidget(message: 'Loading comments...');
          }

          List<CommentModel> comments = [];
          if (state is GetCommentsSuccess) {
            comments = state.comments.posts;
          }

          if (comments.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.comment_outlined,
              title: 'No comments yet',
              subtitle: 'No comments available for this lesson',
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: comments.length,
            itemBuilder: (context, index) {
              final comment = comments[index];
              return CommentCard(comment: comment);
            },
          );
        },
      ),
    );
  }
}
