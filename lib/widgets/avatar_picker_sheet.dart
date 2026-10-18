import 'package:flutter/material.dart';
import '../data/avatars.dart';
import '../utils/responsive.dart';
import 'user_avatar.dart';

Future<int?> showAvatarPicker(BuildContext context, {required int current}) {
  return showModalBottomSheet<int>(
    context: context,
    showDragHandle: true,
    useSafeArea: true,
    builder: (ctx) {
      final r = Responsive(ctx);
      final cs = Theme.of(ctx).colorScheme;
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Responsive.maxContentWidth),
          child: Padding(
            padding: EdgeInsets.fromLTRB(r.wp(5), 0, r.wp(5), r.wp(6)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Pilih Avatar', style: TextStyle(fontSize: r.sp(5), fontWeight: FontWeight.w700, color: cs.primary)),
                SizedBox(height: r.wp(4)),
                Wrap(
                  spacing: r.wp(4),
                  runSpacing: r.wp(4),
                  alignment: WrapAlignment.center,
                  children: [
                    for (int i = 0; i < avatarStyles.length; i++)
                      GestureDetector(
                        onTap: () => Navigator.pop(ctx, i),
                        child: Container(
                          padding: EdgeInsets.all(r.wp(1)),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: i == current ? cs.primary : Colors.transparent, width: 3),
                          ),
                          child: UserAvatar(index: i, radius: r.wp(7)),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}