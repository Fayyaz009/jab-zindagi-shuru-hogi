import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/bloc/progress_bloc/bloc/progress_bar_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/database/prgress_bar.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_event.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_state.dart';

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
  bool _hasScrolledToSavedPosition = false;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _loadSavedOffset();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadSavedOffset() async {
    final progressModel = await ProgressDB.instance.loadChapterProgress(
      widget.chapterID,
    );

    if (progressModel.offset > 0 && _controller.hasClients) {
      _controller.jumpTo(progressModel.offset);
      _hasScrolledToSavedPosition = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        final AppThemeType themeType = context
            .watch<ThemeBloc>()
            .state
            .themeType;
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        final textTheme = theme.textTheme;

        // 📐 Responsive values
        final double horizontalPadding = width * 0.06;
        final double verticalPadding = height * 0.03;

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
            actions: [
              // ================= THEME TOGGLE =================
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
                  final nextTheme = themeType == AppThemeType.dark
                      ? AppThemeType.light
                      : themeType == AppThemeType.light
                      ? AppThemeType.sepia
                      : AppThemeType.dark;

                  context.read<ThemeBloc>().add(ChangeTheme(nextTheme));
                },
              ),
            ],
            title: Text(
              widget.chapterTitle,
              style: textTheme.titleLarge?.copyWith(
                fontFamily: 'Urdu',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          body: NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if (_hasScrolledToSavedPosition ||
                  scrollNotification is UserScrollNotification) {
                final max = _controller.position.maxScrollExtent;
                if (max > 0) {
                  final offset = _controller.offset;
                  final progress = (offset / max).clamp(0.0, 1.0);

                  context.read<ProgressBarBloc>().add(
                    SaveProgress(
                      chapterID: widget.chapterID,
                      offset: offset,
                      progress: progress,
                    ),
                  );
                }
              }
              return false;
            },

            child: SingleChildScrollView(
              controller: _controller,
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxReadingWidth),
                  child: Text(
                    widget.readingText ?? '',
                    textAlign: TextAlign.justify,
                    textDirection: TextDirection.rtl,
                    style: textTheme.bodyLarge?.copyWith(
                      fontFamily: 'Urdu',
                      fontSize: fontSize,
                      height: 1.9,
                      wordSpacing: 1.2,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
