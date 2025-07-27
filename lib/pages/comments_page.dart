import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/validators.dart';
import 'package:test/cubit/test_cubit.dart';
import 'package:test/models/comment_model.dart';

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
    final TextEditingController commentController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    context.read<TestCubit>().getComments(lessonId);
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments - Lesson $lessonId'),
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
          } else if (state is AddCommentSuccess) {
            commentController.clear();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.response.message),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
            context.read<TestCubit>().getComments(lessonId);
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
          List<CommentModel> comments = [];
          if (state is GetCommentsSuccess) {
            comments = state.comments.posts;
          }

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add a Comment',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: commentController,
                        validator: Validators.validateComment,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          hintText: 'Write your comment here...',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(12),
                        ),
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child:
                              state is AddCommentLoading
                                  ? const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text('Adding Comment...'),
                                    ],
                                  )
                                  : const Text('Add Comment'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child:
                    state is GetCommentsLoading
                        ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.deepPurple,
                          ),
                        )
                        : comments.isEmpty
                        ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.comment_outlined,
                                size: 64,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No comments yet',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Be the first to add a comment!',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                        : RefreshIndicator(
                          onRefresh: () async {
                            context.read<TestCubit>().getComments(lessonId);
                          },
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: comments.length,
                            itemBuilder: (context, index) {
                              final comment = comments[index];
                              return CommentCard(comment: comment);
                            },
                          ),
                        ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CommentCard extends StatelessWidget {
  final CommentModel comment;

  const CommentCard({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(comment.author.avatarUrl),
                  backgroundColor: Colors.grey[300],
                  onBackgroundImageError: (_, __) {},
                  child:
                      comment.author.avatarUrl.isEmpty
                          ? Text(
                            comment.author.login.isNotEmpty
                                ? comment.author.login[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          )
                          : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.author.login,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        comment.datetime,
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _parseHtmlToText(comment.content),
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),

            const SizedBox(height: 8),
  
            if (comment.repliesCount != '0 replies')
              Text(
                comment.repliesCount,
                style: TextStyle(
                  color: Colors.deepPurple[400],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _parseHtmlToText(String htmlString) {
    return htmlString
        .replaceAll(RegExp(r'<[^>]*>'), '') 
        .replaceAll('&nbsp;', ' ') 
        .replaceAll('&amp;', '&') 
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#038;', '&')
        .trim();
  }
}
