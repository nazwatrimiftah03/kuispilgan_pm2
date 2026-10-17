import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/quiz_provider.dart';
import '../utils/gamification.dart';
import '../utils/responsive.dart';
import '../widgets/avatar_picker_sheet.dart';
import '../widgets/content_wrapper.dart';
import '../widgets/primary_button.dart';
import '../widgets/profile_dialogs.dart';
import '../widgets/user_avatar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const List<String> _months = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
  ];

  String _date(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';

  Future<void> _pickAvatar(BuildContext context, AppUser user) async {
    final index = await showAvatarPicker(context, current: user.avatarIndex);
    if (index != null && context.mounted) {
      context.read<AuthProvider>().updateAvatar(index);
    }
  }

  Future<void> _editName(BuildContext context, AppUser user) async {
    final name = await showDialog<String>(
      context: context,
      builder: (_) => EditNameDialog(initial: user.fullName),
    );
    if (name != null && context.mounted) {
      context.read<AuthProvider>().updateName(name);
    }
  }

  Future<void> _changePassword(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => const ChangePasswordDialog(),
    );
    if (ok == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password berhasil diubah')),
      );
    }
  }

  Future<void> _logout(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar dari akun?'),
        content: const Text('Riwayat skormu tetap tersimpan di perangkat ini.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Keluar')),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    final auth = context.read<AuthProvider>();
    final quiz = context.read<QuizProvider>();
    Navigator.popUntil(context, (route) => route.isFirst);
    quiz.reset();
    auth.logout();
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final cs = Theme.of(context).colorScheme;
    final user = context.watch<AuthProvider>().user;
    if (user == null) return const SizedBox.shrink(); // saat transisi keluar

    final quiz = context.watch<QuizProvider>();
    final history = quiz.historyOf(user.username);
    final level = Gamification.levelFor(Gamification.totalXp(history));
    final isDark = quiz.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ContentWrapper(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: GestureDetector(
                onTap: () => _pickAvatar(context, user),
                child: Stack(
                  children: [
                    UserAvatar(index: user.avatarIndex, radius: r.wp(16)),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: CircleAvatar(
                        radius: r.wp(5),
                        backgroundColor: cs.primary,
                        child: Icon(Icons.edit, size: r.wp(5), color: cs.onPrimary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: r.wp(3)),
            Text(
              user.fullName,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: r.sp(5.5), fontWeight: FontWeight.w700),
            ),
            Text(
              '@${user.username}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: r.sp(3.4), color: cs.onSurfaceVariant),
            ),
            SizedBox(height: r.wp(2)),
            Center(
              child: Chip(
                avatar: Icon(Icons.military_tech, color: cs.primary),
                label: Text(
                  'Level ${level.level} - ${level.title}',
                  style: TextStyle(fontSize: r.sp(3.2)),
                ),
              ),
            ),
            Text(
              'Bergabung sejak ${_date(user.joinedAt)}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: r.sp(3), color: cs.onSurfaceVariant),
            ),
            SizedBox(height: r.wp(5)),

            // Progres XP
            Card(
              child: Padding(
                padding: EdgeInsets.all(r.wp(4)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total XP', style: TextStyle(fontSize: r.sp(3.4), fontWeight: FontWeight.w600)),
                        Text('${level.xp} XP', style: TextStyle(fontSize: r.sp(3.4), fontWeight: FontWeight.w700, color: cs.primary)),
                      ],
                    ),
                    SizedBox(height: r.wp(2)),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(r.wp(2)),
                      child: LinearProgressIndicator(value: level.progress, minHeight: r.wp(2.5)),
                    ),
                    SizedBox(height: r.wp(1.5)),
                    Text(
                      '${level.xpToNext} XP lagi menuju level ${level.level + 1}',
                      style: TextStyle(fontSize: r.sp(2.9), color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: r.wp(3)),

            // Pengaturan akun
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.badge_outlined),
                    title: Text('Ubah nama', style: TextStyle(fontSize: r.sp(3.6))),
                    subtitle: Text(user.fullName, style: TextStyle(fontSize: r.sp(3))),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _editName(context, user),
                  ),
                  const Divider(height: 0),
                  ListTile(
                    leading: const Icon(Icons.lock_outline),
                    title: Text('Ganti password', style: TextStyle(fontSize: r.sp(3.6))),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _changePassword(context),
                  ),
                  const Divider(height: 0),
                  SwitchListTile(
                    secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
                    title: Text('Mode gelap', style: TextStyle(fontSize: r.sp(3.6))),
                    value: isDark,
                    onChanged: (_) => context.read<QuizProvider>().toggleTheme(),
                  ),
                ],
              ),
            ),
            SizedBox(height: r.wp(5)),
            PrimaryButton(
              label: 'Keluar',
              icon: Icons.logout,
              outlined: true,
              onPressed: () => _logout(context),
            ),
          ],
        ),
      ),
    );
  }
}