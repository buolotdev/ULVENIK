import 'package:flutter/material.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);
const Color _crimson = Color(0xFFE5484D);

class MediaUploadManagerScreen extends StatefulWidget {
  const MediaUploadManagerScreen({super.key});

  @override
  State<MediaUploadManagerScreen> createState() =>
      _MediaUploadManagerScreenState();
}

class _MediaUploadManagerScreenState extends State<MediaUploadManagerScreen> {
  bool _isPaused = false;
  bool _failedRetried = false;

  void _retryFailed() {
    setState(() => _failedRetried = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Retrying failed upload...'), backgroundColor: _forest),
    );
  }

  void _togglePauseAll() {
    setState(() => _isPaused = !_isPaused);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_isPaused ? 'All uploads paused.' : 'Uploads resumed.'), backgroundColor: _forest),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      appBar: AppBar(
        backgroundColor: _obsidian,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: _offWhite, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Media Uploads',
          style: TextStyle(color: _offWhite, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit upload queue'), backgroundColor: _forest),
              );
            },
            child: const Text('Edit', style: TextStyle(color: _stoneGrey, fontSize: 14)),
          ),
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cleared completed uploads.'), backgroundColor: _forest),
              );
            },
            child: const Text('Clear Completed', style: TextStyle(color: _mint, fontSize: 14, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // UPLOAD STATUS
          const Text(
            'UPLOAD STATUS',
            style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildStatusCol('3', 'UPLOADING', _mint),
                    _buildDivider(),
                    _buildStatusCol('5', 'WAITING', _stoneGrey),
                    _buildDivider(),
                    _buildStatusCol(_failedRetried ? '0' : '1', 'FAILED', _crimson),
                    _buildDivider(),
                    _buildStatusCol('14', 'COMPLETED', _offWhite),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: _cardBorder),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('12.4 MB uploading now', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                    Row(
                      children: [
                        Container(width: 6, height: 6, decoration: const BoxDecoration(color: _mint, shape: BoxShape.circle)),
                        const SizedBox(width: 6),
                        const Text('Sync active', style: TextStyle(color: _mint, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // ACTIONS STRIP
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: _retryFailed,
                child: const Text('Retry All Failed', style: TextStyle(color: _crimson, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
              InkWell(
                onTap: _togglePauseAll,
                child: Text(_isPaused ? 'Paused' : 'Pause All', style: const TextStyle(color: _stoneGrey, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
              InkWell(
                onTap: _togglePauseAll,
                child: const Text('Resume All', style: TextStyle(color: _mint, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
              InkWell(
                onTap: () {},
                child: const Text('Cancel All', style: TextStyle(color: _stoneGrey, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // SECTION UPLOADING
          const Text(
            'UPLOADING',
            style: TextStyle(color: _mint, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 12),
          _buildUploadingCard(
            icon: Icons.image_outlined,
            title: 'Koda_Training_Session_14.jpg',
            subtitle: 'Training Session • 12 Jul 2026',
            size: '3.2 MB',
            progress: 0.68,
            eta: '68% • 12 sec remaining',
          ),
          const SizedBox(height: 10),
          _buildUploadingCard(
            icon: Icons.image_outlined,
            title: 'Koda_Outdoor_Run.jpg',
            subtitle: 'Training Session • 12 Jul 2026',
            size: '1.9 MB',
            progress: 0.34,
            eta: '34% • 28 sec remaining',
          ),
          const SizedBox(height: 10),
          _buildUploadingCard(
            icon: Icons.play_arrow_outlined,
            title: 'Session14_Recall.mp4',
            subtitle: 'Training Session • 12 Jul 2026',
            size: '47.2 MB',
            progress: 0.12,
            eta: '12% • 1 min remaining',
          ),
          const SizedBox(height: 28),

          // SECTION WAITING
          const Text(
            'WAITING',
            style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 12),
          _buildWaitingCard(
            icon: Icons.description_outlined,
            title: 'Koda_Competition_Score.pdf',
            subtitle: 'Competition • 10 Jul 2026',
            size: '1.8 MB',
          ),
          const SizedBox(height: 10),
          _buildWaitingCard(
            icon: Icons.description_outlined,
            title: 'Vet_Assessment_Jul26.pdf',
            subtitle: 'Health Record • 10 Jul 2026',
            size: '2.4 MB',
          ),
          const SizedBox(height: 28),

          // SECTION FAILED
          if (!_failedRetried) ...[
            const Text(
              'FAILED',
              style: TextStyle(color: _crimson, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
            ),
            const SizedBox(height: 12),
            _buildFailedCard(
              icon: Icons.play_arrow_outlined,
              title: 'Koda_Training_Video_Recall.mp4',
              subtitle: 'Training Session • 8 Jul 2026',
              size: '47.2 MB',
              progress: 0.45,
              onRetry: _retryFailed,
            ),
            const SizedBox(height: 28),
          ],

          // SECTION COMPLETED TODAY
          const Text(
            'COMPLETED TODAY',
            style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 12),
          _buildCompletedCard(
            icon: Icons.image_outlined,
            title: 'Koda_Agility_Run.jpg',
            subtitle: 'Training Session • Completed 14:32',
          ),
          const SizedBox(height: 10),
          _buildCompletedCard(
            icon: Icons.description_outlined,
            title: 'Training_Notes_Jul12.pdf',
            subtitle: 'Training Session • Completed 14:28',
          ),
          const SizedBox(height: 10),
          _buildCompletedCard(
            icon: Icons.image_outlined,
            title: 'Koda_Session14_Overview.jpg',
            subtitle: 'Training Session • Completed 14:21',
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildStatusCol(String val, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(val, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 3),
          Text(label, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.6)),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(height: 24, width: 1, color: _cardBorder);
  }

  Widget _buildUploadingCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String size,
    required double progress,
    required String eta,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFF242A2E),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: _stoneGrey, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _forest.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text('UPLOADING', style: TextStyle(color: _mint, fontSize: 9, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 8),
                        Text(size, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.pause, color: _stoneGrey, size: 18),
              const SizedBox(width: 10),
              const Icon(Icons.close, color: _stoneGrey, size: 18),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFF242A2E),
              valueColor: const AlwaysStoppedAnimation<Color>(_mint),
              minHeight: 3,
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: Text(eta, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
          ),
        ],
      ),
    );
  }

  Widget _buildWaitingCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String size,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFF242A2E),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: _stoneGrey, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF242A2E),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('WAITING', style: TextStyle(color: _stoneGrey, fontSize: 9, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 8),
                    Text(size, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.close, color: _stoneGrey, size: 18),
        ],
      ),
    );
  }

  Widget _buildFailedCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String size,
    required double progress,
    required VoidCallback onRetry,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFF242A2E),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: _crimson, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _crimson.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text('FAILED', style: TextStyle(color: _crimson, fontSize: 9, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 8),
                        Text(size, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: _crimson, size: 20),
                onPressed: onRetry,
              ),
              const Icon(Icons.close, color: _stoneGrey, size: 18),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFF242A2E),
              valueColor: const AlwaysStoppedAnimation<Color>(_crimson),
              minHeight: 3,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: onRetry,
                child: const Text('Upload interrupted — tap Retry', style: TextStyle(color: _crimson, fontSize: 11)),
              ),
              Text('${(progress * 100).toInt()}%', style: const TextStyle(color: _stoneGrey, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFF242A2E),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: _stoneGrey, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
              ],
            ),
          ),
          const Icon(Icons.check_circle_outline, color: _mint, size: 20),
        ],
      ),
    );
  }
}
