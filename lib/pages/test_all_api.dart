import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/test_cubit.dart';
import 'comments_page.dart';
import 'profile_page.dart';

class TestAllApi extends StatelessWidget {
  const TestAllApi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test All API')),
      body: BlocConsumer<TestCubit, TestState>(
        listener: (context, state) {
          // No need to handle GetAccountSuccess here anymore
          // ProfilePage will handle its own data loading
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Get Account Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ProfilePage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('View Profile'),
                ),

                const SizedBox(height: 16),

                // Lesson 32192 Comments Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (context) => const CommentsPage(
                              lessonId: 32192,
                              lessonTitle: "Applied Transplant Immunology",
                            ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Lesson 32192 Comments'),
                ),

                const SizedBox(height: 16),

                // Lesson 27144 Comments Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (context) => const CommentsPage(
                              lessonId: 27144,
                              lessonTitle: "Lesson 27144",
                            ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Lesson 27144 Comments'),
                ),

                const SizedBox(height: 24),

                // Information Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'API Test Features',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '• View Profile - Automatically loads user profile',
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '• Lesson Comments - View and add comments to lessons',
                        ),
                        const SizedBox(height: 4),
                        const Text('• Test both lesson ID 32192 and 27144'),
                        const SizedBox(height: 4),
                        const Text(
                          '• All endpoints include proper error handling',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
