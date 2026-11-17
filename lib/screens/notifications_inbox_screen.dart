import 'package:flutter/material.dart';
import '../data/health_store.dart';
import '../data/persist.dart';
import '../data/timeline_store.dart';
import '../theme/app_colors.dart';
import '../widgets/health_ui.dart';
import 'health_reminders_list_screen.dart';

/// Read / archived state for inbox items, saved on the device.
class InboxState extends ChangeNotifier {
  InboxState._();
  static final InboxState instance = InboxState._();
  final Set<String> read = {};
  final Set<String> archived = {};

  Future<void> load() async {
    final j = await Persist.read('store.inbox');
    if (j is! Map) return;
    read
      ..clear()
      ..addAll([for (final x in (j['read'] as List? ?? [])) '$x']);
    archived
      ..clear()
      ..addAll([for (final x in (j['archived'] as List? ?? [])) '$x']);
    notifyListeners();
  }

  void change(void Function() f) {
    f();
    Persist.write('store.inbox', {'read': read.toList(), 'archived': archived.toList()});
    notifyListeners();
  }
}

class _Item {
  final String id;
  final String dog;
  final HealthReminder reminder;
  _Item(this.id, this.dog, this.reminder);
}

/// Notifications Inbox: reminders that have come due. Only items that really
/// reached their time appear — a future reminder is never shown as received.
/// Reading or archiving a notice never completes the reminder behind it.
class NotificationsInboxScreen extends StatefulWidget {
  const NotificationsInboxScreen({super.key});

  @override
  State<NotificationsInboxScreen> createState() => _NotificationsInboxScreenState();
}

class _NotificationsInboxScreenState extends State<NotificationsInboxScreen> {
  final _inbox = InboxState.instance;
  bool _unreadOnly = false;
  bool _showArchived = false;

  @override
  void initState() {
    super.initState();
    _inbox.addListener(_r);
    HealthStore.instance.addListener(_r);
  }

  @override
  void dispose() {
    _inbox.removeListener(_r);
    HealthStore.instance.removeListener(_r);
    super.dispose();
  }

  void _r() {
    if (mounted) setState(() {});
  }

  List<_Item> _items() {
    final now = DateTime.now();
    final out = <_Item>[];
    for (final dog in TimelineStore.dogNames()) {
      for (final r in HealthStore.instance.reminders(dog)) {
        if (r.completed || r.due.isAfter(now)) continue;
        out.add(_Item('rem:${r.id}', dog, r));
      }
    }
    out.sort((a, b) => b.reminder.due.compareTo(a.reminder.due));
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final all = _items();
    final active = all.where((i) => !_inbox.archived.contains(i.id)).toList();
    final archived = all.where((i) => _inbox.archived.contains(i.id)).toList();
    final unread = active.where((i) => !_inbox.read.contains(i.id)).length;
    var list = _showArchived ? archived : active;
    if (_unreadOnly && !_showArchived) list = list.where((i) => !_inbox.read.contains(i.id)).toList();

    return HealthScaffold(
      title: 'Notifications Inbox',
      actions: [
        if (unread > 0 && !_showArchived)
          TextButton(
            onPressed: () => _inbox.change(() => _inbox.read.addAll(active.map((i) => i.id))),
            child: Text('Mark all as read', style: TextStyle(color: AppColors.primaryForestGreen, fontSize: 13)),
          ),
      ],
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          ChoiceRow(
            options: ['All', 'Unread ($unread)', 'Archived'],
            value: _showArchived ? 'Archived' : (_unreadOnly ? 'Unread ($unread)' : 'All'),
            onChanged: (v) => setState(() {
              _showArchived = v == 'Archived';
              _unreadOnly = v.startsWith('Unread');
            }),
          ),
          const SizedBox(height: 14),
          if (list.isEmpty)
            EmptyState(
              icon: Icons.notifications_none,
              title: _showArchived
                  ? 'No Archived Notifications'
                  : (_unreadOnly ? 'No Unread Notifications' : 'No Notifications Yet'),
              message: _showArchived
                  ? 'Notifications you archive will appear here.'
                  : (_unreadOnly ? 'You’re all caught up.' : 'Reminders will appear here once they come due.'),
            ),
          for (final i in list)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: HealthCard(
                onTap: () {
                  _inbox.change(() => _inbox.read.add(i.id));
                  Navigator.push(context, MaterialPageRoute(builder: (_) => HealthReminderForm(dogName: i.dog, entry: i.reminder)));
                },
                padding: const EdgeInsets.fromLTRB(16, 12, 4, 12),
                child: Row(children: [
                  if (!_inbox.read.contains(i.id))
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(color: AppColors.primaryForestGreen, shape: BoxShape.circle),
                    ),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(i.reminder.title,
                          style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w600)),
                      Text('${i.dog} · ${i.reminder.type.label}',
                          style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                      Text(reminderWhen(i.reminder), style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                    ]),
                  ),
                  PopupMenuButton<String>(
                    color: AppColors.cardsCarbon,
                    tooltip: 'More',
                    onSelected: (v) => _inbox.change(() {
                      if (v == 'read') {
                        _inbox.read.contains(i.id) ? _inbox.read.remove(i.id) : _inbox.read.add(i.id);
                      } else if (_inbox.archived.contains(i.id)) {
                        _inbox.archived.remove(i.id);
                      } else {
                        _inbox.archived.add(i.id);
                      }
                    }),
                    itemBuilder: (_) => [
                      PopupMenuItem(
                          value: 'read',
                          child: Text(_inbox.read.contains(i.id) ? 'Mark as unread' : 'Mark as read',
                              style: TextStyle(color: AppColors.primaryTextOffWhite))),
                      PopupMenuItem(
                          value: 'archive',
                          child: Text(_inbox.archived.contains(i.id) ? 'Restore notification' : 'Archive notification',
                              style: TextStyle(color: AppColors.primaryTextOffWhite))),
                    ],
                  ),
                ]),
              ),
            ),
        ],
      ),
    );
  }
}
