import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import '../data/media_store.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/health_ui.dart';
import '../widgets/ulvenik_icon.dart';
import 'media_actions.dart';
import 'media_edit_screen.dart';

Widget _failed(String text) => Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.error_outline, color: AppColors.secondaryTextStoneGrey, size: 36),
          const SizedBox(height: 10),
          Text(text,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14, height: 1.4)),
        ]),
      ),
    );

/// Full-screen viewer for photos, videos and documents. Swipe sideways through
/// the list the user opened it from; actions always refer to the current item.
class MediaViewerScreen extends StatefulWidget {
  final String dogName;
  final List<MediaItem> items;
  final int initialIndex;
  const MediaViewerScreen({super.key, required this.dogName, required this.items, required this.initialIndex});

  @override
  State<MediaViewerScreen> createState() => _MediaViewerScreenState();
}

class _MediaViewerScreenState extends State<MediaViewerScreen> {
  late final PageController _page = PageController(initialPage: widget.initialIndex);
  late int _index = widget.initialIndex;
  late final List<MediaItem> _items = [...widget.items];
  final _store = MediaStore.instance;

  MediaItem get _current => _items[_index];

  @override
  void initState() {
    super.initState();
    _store.addListener(_refresh);
  }

  @override
  void dispose() {
    _store.removeListener(_refresh);
    _page.dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  Future<void> _share() async {
    final i = _current;
    if (i.path == null) return;
    try {
      await SharePlus.instance.share(ShareParams(files: [XFile(i.path!)], title: i.displayTitle));
    } catch (_) {
      if (mounted) AppSnackbar.show(context, message: 'Couldn’t open sharing.', type: SnackbarType.error);
    }
  }

  void _menu() {
    final i = _current;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            ListTile(
              leading: UlvenikIcon(UlvenikIcons.edit, color: AppColors.primaryTextOffWhite),
              title: Text('Edit Details', style: TextStyle(color: AppColors.primaryTextOffWhite)),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => MediaEditScreen(dogName: widget.dogName, item: i)));
              },
            ),
            ListTile(
              title: Text('Add to Collection', style: TextStyle(color: AppColors.primaryTextOffWhite)),
              onTap: () {
                Navigator.pop(ctx);
                showAddToCollectionSheet(context, widget.dogName, [i]);
              },
            ),
            ListTile(
              title: Text('Download / Save', style: TextStyle(color: AppColors.primaryTextOffWhite)),
              onTap: () {
                Navigator.pop(ctx);
                downloadItems(context, [i]);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Color(0xFFFFB4AB)),
              title: const Text('Delete Media', style: TextStyle(color: Color(0xFFFFB4AB))),
              onTap: () async {
                Navigator.pop(ctx);
                final ok = await confirmDeleteMedia(context, [i]);
                if (!ok || !mounted) return;
                _store.delete(widget.dogName, [i.id]);
                AppSnackbar.show(context, message: 'Media deleted', type: SnackbarType.success);
                Navigator.pop(context);
              },
            ),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final i = _current;
    final isDoc = i.type == MediaType.document;
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundObsidian,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(i.displayTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 16, fontWeight: FontWeight.w600)),
        leading: IconButton(
          tooltip: 'Back',
          icon: UlvenikIcon(UlvenikIcons.back, color: AppColors.secondaryTextStoneGrey),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            tooltip: i.favourite ? 'Remove from Favourites' : 'Add to Favourites',
            icon: Icon(i.favourite ? Icons.favorite : Icons.favorite_border,
                color: i.favourite ? AppColors.primaryForestGreen : AppColors.secondaryTextStoneGrey),
            onPressed: () => _store.toggleFavourite(i),
          ),
          IconButton(
            tooltip: 'More',
            icon: UlvenikIcon(UlvenikIcons.more, color: AppColors.primaryTextOffWhite),
            onPressed: _menu,
          ),
        ],
      ),
      body: Column(children: [
        Expanded(
          child: PageView.builder(
            controller: _page,
            itemCount: _items.length,
            onPageChanged: (v) => setState(() => _index = v),
            itemBuilder: (_, n) {
              final it = _items[n];
              return switch (it.type) {
                MediaType.photo => _PhotoPage(item: it),
                MediaType.video => _VideoPage(item: it, active: n == _index),
                MediaType.document => _DocumentPage(item: it),
              };
            },
          ),
        ),
        _InfoPanel(item: i, showDocActions: isDoc, onShare: _share, onDownload: () => downloadItems(context, [i])),
      ]),
    );
  }
}

class _PhotoPage extends StatelessWidget {
  final MediaItem item;
  const _PhotoPage({required this.item});

  @override
  Widget build(BuildContext context) {
    if (item.path == null) return _failed('This photo couldn’t be opened.');
    return InteractiveViewer(
      maxScale: 5,
      child: Center(
        child: Image.file(File(item.path!),
            fit: BoxFit.contain, errorBuilder: (_, _, _) => _failed('This photo couldn’t be opened.')),
      ),
    );
  }
}

/// Plays one video. Playback stops when the page is no longer the current one
/// (swiping away) so audio never carries over to the next item.
class _VideoPage extends StatefulWidget {
  final MediaItem item;
  final bool active;
  const _VideoPage({required this.item, required this.active});

  @override
  State<_VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<_VideoPage> {
  VideoPlayerController? _c;
  bool _failedToOpen = false;

  @override
  void initState() {
    super.initState();
    final p = widget.item.path;
    if (p == null) {
      _failedToOpen = true;
      return;
    }
    final c = VideoPlayerController.file(File(p));
    _c = c;
    c.initialize().then((_) {
      if (mounted) setState(() {});
    }).catchError((_) {
      if (mounted) setState(() => _failedToOpen = true);
    });
  }

  @override
  void didUpdateWidget(_VideoPage old) {
    super.didUpdateWidget(old);
    if (!widget.active) _c?.pause();
  }

  @override
  void dispose() {
    _c?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_failedToOpen) return _failed('This video couldn’t be opened.');
    final c = _c;
    if (c == null || !c.value.isInitialized) {
      return Center(child: CircularProgressIndicator(color: AppColors.primaryForestGreen));
    }
    return Stack(alignment: Alignment.center, children: [
      Center(child: AspectRatio(aspectRatio: c.value.aspectRatio, child: VideoPlayer(c))),
      ValueListenableBuilder<VideoPlayerValue>(
        valueListenable: c,
        builder: (_, v, _) => GestureDetector(
          onTap: () => v.isPlaying ? c.pause() : c.play(),
          child: Container(
            color: Colors.transparent,
            alignment: Alignment.center,
            child: AnimatedOpacity(
              opacity: v.isPlaying ? 0 : 1,
              duration: const Duration(milliseconds: 200),
              child: Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                child: const Icon(Icons.play_arrow, color: Colors.white, size: 36),
              ),
            ),
          ),
        ),
      ),
      Positioned(
        left: 16,
        right: 16,
        bottom: 8,
        child: VideoProgressIndicator(
          c,
          allowScrubbing: true,
          colors: VideoProgressColors(
              playedColor: AppColors.primaryForestGreen, bufferedColor: AppColors.cardBorder, backgroundColor: AppColors.cardBorder),
        ),
      ),
    ]);
  }
}

class _DocumentPage extends StatelessWidget {
  final MediaItem item;
  const _DocumentPage({required this.item});

  @override
  Widget build(BuildContext context) {
    final isPdf = item.name.toLowerCase().endsWith('.pdf');
    if (!isPdf || item.path == null) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.description_outlined, color: AppColors.secondarySage, size: 56),
          const SizedBox(height: 12),
          Text(item.name,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text('This file type can’t be previewed in Ulvenik. You can download or share it.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13.5, height: 1.4)),
          ),
        ]),
      );
    }
    return PdfViewer.file(
      item.path!,
      params: PdfViewerParams(backgroundColor: AppColors.backgroundObsidian),
    );
  }
}

class _InfoPanel extends StatelessWidget {
  final MediaItem item;
  final bool showDocActions;
  final VoidCallback onShare;
  final VoidCallback onDownload;
  const _InfoPanel(
      {required this.item, required this.showDocActions, required this.onShare, required this.onDownload});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.3),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border(top: BorderSide(color: AppColors.cardBorder)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(fmtDate(item.mediaDate),
                style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
            if (item.description.trim().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(item.description,
                    style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14, height: 1.4)),
              ),
            if (item.links.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text('Linked Records',
                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Wrap(spacing: 8, runSpacing: 6, children: [
                for (final l in item.links)
                  ActionChip(
                    label: Text('${l.section} · ${l.label()}',
                        style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 12.5)),
                    backgroundColor: AppColors.backgroundObsidian,
                    side: BorderSide(color: AppColors.cardBorder),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: l.open)),
                  ),
              ]),
            ],
            if (showDocActions) ...[
              const SizedBox(height: 12),
              Row(children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onDownload,
                    style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryTextOffWhite,
                        side: BorderSide(color: AppColors.cardBorder),
                        minimumSize: const Size(0, 44)),
                    child: const Text('Download'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onShare,
                    style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryTextOffWhite,
                        side: BorderSide(color: AppColors.cardBorder),
                        minimumSize: const Size(0, 44)),
                    child: const Text('Share'),
                  ),
                ),
              ]),
            ],
          ]),
        ),
      ),
    );
  }
}
