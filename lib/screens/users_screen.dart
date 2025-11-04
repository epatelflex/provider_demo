
import 'package:provider_demo/index.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(title: const AppTitle('Users')),
      body: AsyncBuilder<UserProvider>(
        onLoad: (provider) => provider.loadUsers(),
        isEmpty: (provider) => provider.users?.isEmpty ?? true,
        emptyBuilder: (context) =>
            const Center(child: AppBody('No users found')),
        // errorBuilder: (context, provider, error) {
        //   if (error is HttpException) {
        //     return Center(child: AppHeadline('Http error: ${error.message}'));
        //   } else {
        //     return Center(child: AppHeadline('Something failed: $error'));
        //   }
        // },
        builder: (context, provider) {
          final users = provider.users!;
          return RefreshIndicator(
            onRefresh: () => provider.loadUsers(),
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return AppCard(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            child: AppBody(
                              user.name[0].toUpperCase(),
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppTitle(user.name),
                                AppCaption('@${user.username}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          const Icon(Icons.email, size: 16),
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(child: AppCaption(user.email)),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Row(
                        children: [
                          const Icon(Icons.phone, size: 16),
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(child: AppCaption(user.phone)),
                        ],
                      ),
                      if (user.company != null) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Row(
                          children: [
                            const Icon(Icons.business, size: 16),
                            const SizedBox(width: AppSpacing.xs),
                            Expanded(child: AppCaption(user.company!.name)),
                          ],
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
