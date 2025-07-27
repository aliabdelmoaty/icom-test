import 'package:flutter/material.dart';
import 'package:test/widgets/common_widgets.dart';
import 'add_comment_page.dart';
import 'comments_page.dart';
import 'profile_page.dart';

class TestAllApi extends StatelessWidget {
  const TestAllApi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test All API'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppButton(
              text: 'View Profile',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
            ),
            const SizedBox(height: 20),
            LessonSection(
              lessonId: 27144,
              lessonTitle: "Lesson 27144",
              commentsButtonColor: Colors.orange,
              addCommentButtonColor: Colors.deepOrange,
            ),
            const SizedBox(height: 20),
            LessonSection(
              lessonId: 32192,
              lessonTitle: "Lesson 32192",
              commentsButtonColor: Colors.green,
              addCommentButtonColor: Colors.teal,
            ),
          ],
        ),
      ),
    );
  }
}

class LessonSection extends StatelessWidget {
  const LessonSection({
    super.key,
    required this.lessonId,
    required this.lessonTitle,
    required this.commentsButtonColor,
    required this.addCommentButtonColor,
  });
  final int lessonId;
  final String lessonTitle;
  final Color commentsButtonColor;
  final Color addCommentButtonColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          lessonTitle,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: AppButton(
                text: 'View Comments',
                backgroundColor: commentsButtonColor,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (context) => CommentsPage(
                            lessonId: lessonId,
                            lessonTitle: lessonTitle,
                          ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppButton(
                text: 'Add Comment',
                backgroundColor: addCommentButtonColor,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (context) => AddCommentPage(
                            lessonId: lessonId,
                            lessonTitle: lessonTitle,
                          ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
