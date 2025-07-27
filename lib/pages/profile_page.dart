import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/cubit/test_cubit.dart';
import 'package:test/models/account/account_model.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<TestCubit>().getAccount();
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: BlocConsumer<TestCubit, TestState>(
        listener: (context, state) {
          if (state is GetAccountFailure) {
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
          if (state is GetAccountLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.deepPurple),
            );
          }

          AccountModel account = const AccountModel.empty();
          if (state is GetAccountSuccess) {
            account = state.account;
          }

          if (account == const AccountModel.empty()) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No profile data available',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Please check your connection and try again',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(account.avatarUrl),
                    backgroundColor: Colors.grey[300],
                    onBackgroundImageError: (_, __) {},
                    child:
                        account.avatarUrl.isEmpty
                            ? Text(
                              account.login.isNotEmpty
                                  ? account.login[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                            : null,
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Basic Information',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        BuildInfoRow(label: 'ID', value: account.id.toString()),
                        BuildInfoRow(label: 'Login', value: account.login),
                        BuildInfoRow(label: 'Email', value: account.email),
                        BuildInfoRow(
                          label: 'Total Courses',
                          value: account.totalCourses.toString(),
                        ),
                        BuildInfoRow(
                          label: 'Roles',
                          value: account.roles.join(', '),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Personal Information',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        BuildInfoRow(
                          label: 'First Name',
                          value: account.meta.firstName,
                        ),
                        BuildInfoRow(
                          label: 'Last Name',
                          value: account.meta.lastName,
                        ),
                        BuildInfoRow(
                          label: 'Position',
                          value:
                              account.meta.position.isEmpty
                                  ? 'Not specified'
                                  : account.meta.position,
                        ),
                        BuildInfoRow(
                          label: 'Description',
                          value:
                              account.meta.description.isEmpty
                                  ? 'No description'
                                  : account.meta.description,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rating Information',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        BuildInfoRow(
                          label: 'Total Rating',
                          value: account.rating.total.toString(),
                        ),
                        BuildInfoRow(
                          label: 'Average',
                          value: account.rating.average.toString(),
                        ),
                        BuildInfoRow(
                          label: 'Percentage',
                          value: '${account.rating.percent}%',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Social Media',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        BuildInfoRow(
                          label: 'Facebook',
                          value:
                              account.meta.facebook.isEmpty
                                  ? 'Not provided'
                                  : account.meta.facebook,
                        ),
                        BuildInfoRow(
                          label: 'Twitter',
                          value:
                              account.meta.twitter.isEmpty
                                  ? 'Not provided'
                                  : account.meta.twitter,
                        ),
                        BuildInfoRow(
                          label: 'Instagram',
                          value:
                              account.meta.instagram.isEmpty
                                  ? 'Not provided'
                                  : account.meta.instagram,
                        ),
                        BuildInfoRow(
                          label: 'Google+',
                          value:
                              account.meta.googlePlus.isEmpty
                                  ? 'Not provided'
                                  : account.meta.googlePlus,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}

class BuildInfoRow extends StatelessWidget {
  const BuildInfoRow({super.key, required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
