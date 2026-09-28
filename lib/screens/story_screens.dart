import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../core/session_controller.dart';
import '../core/story.dart';
import '../core/story_api.dart';
import '../l10n/generated/app_localizations.dart';
import '../l10n/language_selector.dart';

const _ink = Color(0xFF242A24);
const _muted = Color(0xFF6D716B);
const _green = Color(0xFF355C4A);
const _rust = Color(0xFFB9513C);

class StoriesScreen extends StatefulWidget {
  const StoriesScreen({
    required this.api,
    required this.session,
    super.key,
  });

  final StoryApi api;
  final SessionController session;

  @override
  State<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  late Future<List<Story>> _stories;

  @override
  void initState() {
    super.initState();
    _stories = _loadStories();
  }

  Future<List<Story>> _loadStories() {
    return widget.api.fetchStories(widget.session.token!);
  }

  Future<void> _refresh() async {
    final request = _loadStories();
    setState(() => _stories = request);
    try {
      await request;
    } catch (_) {
      return;
    }
  }

  Future<void> _openAddStory() async {
    final added = await context.push<bool>('/add');
    if (added == true && mounted) await _refresh();
  }

  Future<void> _logout() async {
    await widget.session.clearSession();
    if (mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: const _Wordmark(),
        actions: [
          LanguageSelector(session: widget.session),
          IconButton(
            onPressed: _logout,
            tooltip: strings.logout,
            icon: const Icon(Icons.logout_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddStory,
        backgroundColor: _green,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_a_photo_outlined),
        label: Text(strings.writeStory),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: _rust,
        child: FutureBuilder<List<Story>>(
          future: _stories,
          builder: (context, snapshot) {
            final stories = snapshot.data ?? const <Story>[];
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
              children: [
                const _FeedHeading(),
                if (snapshot.connectionState == ConnectionState.waiting)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 72),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (snapshot.hasError)
                  _FeedError(
                    message: snapshot.error is ApiException
                        ? (snapshot.error! as ApiException).message
                      : strings.feedLoadError,
                    onRetry: _refresh,
                  )
                else if (stories.isEmpty)
                  const _EmptyFeed()
                else ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Text(
                      strings.storiesCount(stories.length),
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  for (final story in stories)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _StoryCard(story: story),
                    ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Wordmark extends StatelessWidget {
  const _Wordmark();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.auto_stories_rounded, color: _green, size: 23),
        SizedBox(width: 8),
        Text(
          'ruang cerita',
          style: TextStyle(
            color: _ink,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}

class _FeedHeading extends StatelessWidget {
  const _FeedHeading();

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 22, 0, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strings.feedEyebrow,
            style: TextStyle(
              color: _rust,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            strings.feedTitle,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: _ink,
              fontWeight: FontWeight.w700,
              height: 1.03,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            strings.feedSubtitle,
            style: TextStyle(color: _muted, fontSize: 15),
          ),
        ],
      ),
    );
  }
}

class _StoryCard extends StatelessWidget {
  const _StoryCard({required this.story});

  final Story story;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/stories/${Uri.encodeComponent(story.id)}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.65,
              child: _StoryPhoto(url: story.photoUrl),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: const Color(0xFFE8E9DC),
                        child: Text(
                          story.name.isEmpty ? '?' : story.name[0].toUpperCase(),
                          style: const TextStyle(
                            color: _green,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          story.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: _ink,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const Icon(Icons.arrow_outward, size: 17, color: _muted),
                    ],
                  ),
                  if (story.description.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      story.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _muted,
                        height: 1.4,
                        fontSize: 14,
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  Text(
                    _formatDate(story.createdAt, strings.localeName),
                    style: const TextStyle(
                      color: _rust,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryPhoto extends StatelessWidget {
  const _StoryPhoto({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return const _PhotoFallback();
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => const _PhotoFallback(),
      loadingBuilder: (context, child, progress) => progress == null
          ? child
          : const _PhotoFallback(isLoading: true),
    );
  }
}

class _PhotoFallback extends StatelessWidget {
  const _PhotoFallback({this.isLoading = false});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFE8E9DC),
      child: Center(
        child: isLoading
            ? const SizedBox.square(
                dimension: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.image_outlined, size: 36, color: _green),
      ),
    );
  }
}

class _FeedError extends StatelessWidget {
  const _FeedError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 52),
      child: Column(
        children: [
          const Icon(Icons.cloud_off_outlined, color: _rust, size: 38),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: Text(strings.tryAgain),
          ),
        ],
      ),
    );
  }
}

class _EmptyFeed extends StatelessWidget {
  const _EmptyFeed();

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 52),
      child: Column(
        children: [
          const Icon(Icons.auto_stories_outlined, color: _green, size: 40),
          const SizedBox(height: 12),
          Text(strings.emptyFeedTitle),
          const SizedBox(height: 5),
          Text(strings.emptyFeedBody),
        ],
      ),
    );
  }
}

class StoryDetailScreen extends StatefulWidget {
  const StoryDetailScreen({
    required this.api,
    required this.session,
    required this.storyId,
    super.key,
  });

  final StoryApi api;
  final SessionController session;
  final String storyId;

  @override
  State<StoryDetailScreen> createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  late final Future<Story> _story;

  @override
  void initState() {
    super.initState();
    _story = widget.api.fetchStory(widget.session.token!, widget.storyId);
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: strings.back,
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(strings.storyDetail),
      ),
      body: FutureBuilder<Story>(
        future: _story,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Text(
                  snapshot.error is ApiException
                      ? (snapshot.error! as ApiException).message
                      : strings.storyLoadFailed,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          final story = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AspectRatio(
                  aspectRatio: 0.92,
                  child: _StoryPhoto(url: story.photoUrl),
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFFE8E9DC),
                    child: Text(
                      story.name.isEmpty ? '?' : story.name[0].toUpperCase(),
                      style: const TextStyle(
                        color: _green,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          story.name,
                          style: const TextStyle(
                            color: _ink,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          _formatDate(story.createdAt, strings.localeName),
                          style: const TextStyle(color: _muted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Text(
                story.description,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: _ink,
                  height: 1.65,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class AddStoryScreen extends StatefulWidget {
  const AddStoryScreen({
    required this.api,
    required this.session,
    super.key,
  });

  final StoryApi api;
  final SessionController session;

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  final _descriptionController = TextEditingController();
  final _picker = ImagePicker();
  XFile? _image;
  Uint8List? _imageBytes;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final image = await _picker.pickImage(
        source: source,
        imageQuality: 75,
        maxWidth: 1200,
      );
      if (image == null) return;
      final bytes = await image.readAsBytes();
      if (!mounted) return;
      setState(() {
        _image = image;
        _imageBytes = bytes;
      });
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.photoOpenFailed),
          ),
        );
      }
    }
  }

  Future<void> _submit() async {
    final strings = AppLocalizations.of(context)!;
    final image = _image;
    final description = _descriptionController.text.trim();
    if (image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(strings.photoRequired)),
      );
      return;
    }
    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(strings.descriptionRequired)),
      );
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      await widget.api.addStory(
        token: widget.session.token!,
        image: image,
        description: description,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(strings.storyAdded)),
      );
      context.pop(true);
    } on ApiException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message)),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(strings.storyUploadFailed)),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: strings.back,
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(strings.newStory),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: _isSubmitting
                        ? null
                        : () => _pickImage(ImageSource.gallery),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: AspectRatio(
                        aspectRatio: 1.18,
                        child: _imageBytes == null
                            ? ColoredBox(
                                color: const Color(0xFFE8E9DC),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.add_photo_alternate_outlined,
                                      size: 42,
                                      color: _green,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      strings.photoPrompt,
                                      style: TextStyle(
                                        color: _ink,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      strings.galleryOrCamera,
                                      style: TextStyle(
                                        color: _muted.withValues(alpha: 0.9),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Image.memory(_imageBytes!, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _isSubmitting
                              ? null
                              : () => _pickImage(ImageSource.gallery),
                          icon: const Icon(Icons.photo_library_outlined),
                          label: Text(
                            _image == null ? strings.gallery : strings.replacePhoto,
                          ),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                            foregroundColor: _green,
                            side: const BorderSide(color: _green),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _isSubmitting
                              ? null
                              : () => _pickImage(ImageSource.camera),
                          icon: const Icon(Icons.camera_alt_outlined),
                          label: Text(strings.camera),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                            foregroundColor: _green,
                            side: const BorderSide(color: _green),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    strings.descriptionTitle,
                    style: TextStyle(
                      color: _ink,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descriptionController,
                    minLines: 4,
                    maxLines: 7,
                    maxLength: 500,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: strings.descriptionHint,
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    onPressed: _isSubmitting ? null : _submit,
                    icon: _isSubmitting
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.send_rounded),
                    label: Text(
                      _isSubmitting ? strings.sendingStory : strings.shareStory,
                    ),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      backgroundColor: _rust,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String _formatDate(DateTime date, String locale) {
  const englishMonths = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  const indonesianMonths = [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
  ];
  final months = locale == 'en' ? englishMonths : indonesianMonths;
  final local = date.toLocal();
  return '${local.day} ${months[local.month - 1]} ${local.year}';
}