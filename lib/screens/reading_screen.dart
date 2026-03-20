import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/bloc/notes_bloc/notes_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/bloc/progress_bloc/bloc/progress_bar_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/database/prgress_bar.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/models/note_model.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_event.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_state.dart';

import 'package:jab_zindagi_shuru_hogi_inzaar/services/ad_service.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/widgets/banner_ad_widget.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class ReadingScreen extends StatefulWidget {
  final String chapterTitle;
  final int chapterID;
  final String? readingText;

  const ReadingScreen({
    super.key,
    required this.chapterTitle,
    required this.readingText,
    required this.chapterID,
  });

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  late final ScrollController _controller;

  // No setState needed; this is only used for logic gating saves
  bool _hasScrolledToSavedPosition = false;

  // Debounce to reduce DB writes (recommended)
  Timer? _saveTimer;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _loadSavedOffset();
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    _saveTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadSavedOffset() async {
    final progressModel = await ProgressDB.instance.loadChapterProgress(
      widget.chapterID,
    );

    if (!mounted) return;

    // Wait until first frame so _controller.hasClients becomes true
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_controller.hasClients) return;

      final max = _controller.position.maxScrollExtent;
      final target = progressModel.offset.clamp(0.0, max);

      if (target > 0) {
        _controller.jumpTo(target);
      }

      // Mark loaded/restored (no UI update required)
      _hasScrolledToSavedPosition = true;
    });
  }

  void _scheduleSaveProgress() {
    if (!_controller.hasClients) return;

    final max = _controller.position.maxScrollExtent;
    if (max <= 0) return;

    final offset = _controller.offset;
    final progress = (offset / max).clamp(0.0, 1.0);
    final int percentage = (offset / max).round() * 100;

    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;

      context.read<ProgressBarBloc>().add(
        SaveProgress(
          chapterID: widget.chapterID,
          offset: offset,
          progress: progress,
          percentage: percentage,
        ),
      );
    });
  }

  final List<Color> highlightColors = [
    Colors.yellow.withValues(alpha: 0.5),
    Colors.green.withValues(alpha: 0.5),
    Colors.blue.withValues(alpha: 0.5),
    Colors.orange.withValues(alpha: 0.5),
    Colors.pink.withValues(alpha: 0.5),
    Colors.purple.withValues(alpha: 0.5),
  ];

  void _onHighlightSelected(
    String selectedText,
    Color color,
    SelectedContentRange range,
  ) {
    final note = NoteModel(
      chapterID: widget.chapterID,
      chapterTitle: widget.chapterTitle,
      text: selectedText,
      colorValue: color.toARGB32(),
      startIndex: range.startOffset,
      endIndex: range.endOffset,
      createdAt: DateTime.now(),
    );

    context.read<NotesBloc>().add(AddNote(note));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Highlight saved!'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        // Use state directly (no need for context.watch inside BlocBuilder)
        final AppThemeType themeType = state.themeType;

        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        final textTheme = theme.textTheme;

        final double fontSize = width < 360
            ? 18
            : width < 600
            ? 20
            : 22;

        final double maxReadingWidth = width > 600 ? 650 : double.infinity;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            iconTheme: IconThemeData(color: colorScheme.onSurface),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () async {
                await AdService().showInterstitialAd();
                if (context.mounted) Navigator.pop(context);
              },
            ),
            actions: [
              IconButton(
                icon: Icon(
                  themeType == AppThemeType.dark
                      ? Icons.dark_mode
                      : themeType == AppThemeType.light
                      ? Icons.light_mode
                      : Icons.auto_stories,
                  color: colorScheme.onSurface,
                ),
                onPressed: () {
                  final isSepiaUnlocked = context
                      .read<ThemeBloc>()
                      .isSepiaUnlocked;

                  final nextTheme = themeType == AppThemeType.dark
                      ? AppThemeType.light
                      : themeType == AppThemeType.light
                      ? (isSepiaUnlocked
                            ? AppThemeType.sepia
                            : AppThemeType.dark)
                      : AppThemeType.dark;

                  context.read<ThemeBloc>().add(ChangeTheme(nextTheme));
                },
              ),
            ],
            title: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Hero(
                    tag: 'chapter_icon_${widget.chapterTitle}',
                    child: Icon(
                      Icons.menu_book_rounded,
                      size: 20,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.chapterTitle,
                    style: textTheme.titleLarge?.copyWith(
                      fontFamily: 'Urdu',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(4),
              child: BlocBuilder<ProgressBarBloc, ProgressBarState>(
                builder: (context, progressState) {
                  double progress = 0.0;
                  if (progressState is ProgressBarLoaded) {
                    final chapterProgress = progressState.chapterProgress
                        .where((p) => p.chapterID == widget.chapterID)
                        .toList();
                    if (chapterProgress.isNotEmpty) {
                      progress = chapterProgress.first.progress;
                    }
                  }
                  return LinearProgressIndicator(
                    value: progress,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      colorScheme.primary,
                    ),
                    minHeight: 3,
                  );
                },
              ),
            ),
          ),
          body: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) async {
              if (didPop) return;
              await AdService().showInterstitialAd();
              if (context.mounted) Navigator.pop(context);
            },
            child: Column(
              children: [
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      // Only save after restore OR when user scrolls
                      if (_hasScrolledToSavedPosition ||
                          scrollNotification is UserScrollNotification) {
                        _scheduleSaveProgress();
                      }
                      return false;
                    },
                    child: SingleChildScrollView(
                      controller: _controller,
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.06,
                        vertical: height * 0.03,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: maxReadingWidth,
                          ),
                          child: BlocBuilder<NotesBloc, NotesState>(
                            builder: (context, notesState) {
                              // Normalize text to avoid index mismatch (convert \r\n to \n)
                              final rawText = widget.readingText ?? '';
                              final text = rawText.replaceAll('\r', '');

                              List<TextSpan> spans = [];
                              if (notesState is NotesLoaded) {
                                final chapterNotes = notesState.notes
                                    .where(
                                      (n) => n.chapterID == widget.chapterID,
                                    )
                                    .toList();

                                if (chapterNotes.isNotEmpty) {
                                  int lastIndex = 0;
                                  chapterNotes.sort(
                                    (a, b) =>
                                        a.startIndex.compareTo(b.startIndex),
                                  );

                                  for (var note in chapterNotes) {
                                    if (note.startIndex >= lastIndex &&
                                        note.startIndex < text.length) {
                                      if (note.startIndex > lastIndex) {
                                        spans.add(
                                          TextSpan(
                                            text: text.substring(
                                              lastIndex,
                                              note.startIndex,
                                            ),
                                          ),
                                        );
                                      }

                                      final int end = note.endIndex.clamp(
                                        0,
                                        text.length,
                                      );
                                      spans.add(
                                        TextSpan(
                                          text: text.substring(
                                            note.startIndex,
                                            end,
                                          ),
                                          style: TextStyle(
                                            backgroundColor: Color(
                                              note.colorValue,
                                            ),
                                          ),
                                        ),
                                      );
                                      lastIndex = end;
                                    }
                                  }

                                  if (lastIndex < text.length) {
                                    spans.add(
                                      TextSpan(text: text.substring(lastIndex)),
                                    );
                                  }
                                } else {
                                  spans.add(TextSpan(text: text));
                                }
                              } else {
                                spans.add(TextSpan(text: text));
                              }

                              return SelectableText.rich(
                                TextSpan(children: spans),
                                textAlign: TextAlign.justify,
                                textDirection: TextDirection.rtl,
                                style: textTheme.bodyLarge?.copyWith(
                                  fontFamily: 'Urdu',
                                  fontSize: fontSize,
                                  height: 1.9,
                                  wordSpacing: 1.2,
                                  color: colorScheme.onSurface,
                                ),
                                selectionHeightStyle: ui.BoxHeightStyle.tight,
                                selectionWidthStyle: ui.BoxWidthStyle.tight,
                                contextMenuBuilder: (context, editableTextState) {
                                  return AdaptiveTextSelectionToolbar(
                                    anchors:
                                        editableTextState.contextMenuAnchors,
                                    children: [
                                      Container(
                                        height: 48,
                                        margin: const EdgeInsets.only(
                                          bottom: 8,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: theme.cardColor,
                                          borderRadius: BorderRadius.circular(
                                            24,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.2,
                                              ),
                                              blurRadius: 10,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: highlightColors.map((
                                            color,
                                          ) {
                                            return GestureDetector(
                                              onTap: () {
                                                final selection =
                                                    editableTextState
                                                        .textEditingValue
                                                        .selection;
                                                if (!selection.isCollapsed) {
                                                  // Use normalized text for background text extraction
                                                  final content =
                                                      editableTextState
                                                          .textEditingValue
                                                          .text;
                                                  final selectedText = content
                                                      .substring(
                                                        selection.start,
                                                        selection.end,
                                                      );

                                                  _onHighlightSelected(
                                                    selectedText,
                                                    color,
                                                    SelectedContentRange(
                                                      startOffset:
                                                          selection.start,
                                                      endOffset: selection.end,
                                                    ),
                                                  );
                                                }
                                                editableTextState.hideToolbar();
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                    ),
                                                child: CircleAvatar(
                                                  radius: 14,
                                                  backgroundColor: color
                                                      .withValues(alpha: 1.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color: Colors.white,
                                                        width: 1,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const BannerAdWidget(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SelectedContentRange {
  final int startOffset;
  final int endOffset;
  const SelectedContentRange({
    required this.startOffset,
    required this.endOffset,
  });
}
