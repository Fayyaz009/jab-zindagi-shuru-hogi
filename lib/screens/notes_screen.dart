import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/bloc/notes_bloc/notes_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/services/note_sharing_service.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/theme_colors.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final Map<int, GlobalKey> _shareKeys = {};

  @override
  Widget build(BuildContext context) {
    final themeType = context.watch<ThemeBloc>().state.themeType;
    final colors = ThemeColors(themeType);

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        title: const Text(
          'My Notes',
          style: TextStyle(
            fontFamily: 'Urdu',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: colors.bg,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocBuilder<NotesBloc, NotesState>(
        builder: (context, state) {
          if (state is NotesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NotesLoaded) {
            if (state.notes.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.note_alt_outlined,
                      size: 80,
                      color: colors.text.withValues(alpha: 0.2),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No Notes Yet',
                      style: TextStyle(
                        color: colors.text.withValues(alpha: 0.6),
                        fontSize: 22,
                        fontFamily: 'Urdu',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        'Tap and hold any text while reading to save your favorite lines here.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colors.text.withValues(alpha: 0.4),
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.notes.length,
              itemBuilder: (context, index) {
                final note = state.notes[index];
                final key = _shareKeys.putIfAbsent(note.id ?? index, () => GlobalKey());

                return RepaintBoundary(
                  key: key,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: colors.card,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: colors.headerBg.withValues(alpha: 0.5),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Text(
                                note.chapterTitle,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: colors.text,
                                  fontFamily: 'Urdu',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Positioned(
                                right: 0,
                                child: CircleAvatar(
                                  radius: 5,
                                  backgroundColor: Color(note.colorValue).withValues(alpha: 1.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    note.text,
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      color: colors.text,
                                      fontFamily: 'Urdu',
                                      fontSize: 18,
                                      height: 1.6,
                                    ),
                                  ),
                                ),
                              ),
                              // Vertical Color Indicator
                              Container(
                                width: 5,
                                margin: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: Color(note.colorValue).withValues(alpha: 1.0),
                                  borderRadius: const BorderRadius.horizontal(
                                    left: Radius.circular(4),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.share_outlined),
                                color: colors.icon,
                                iconSize: 20,
                                onPressed: () => NoteSharingService.shareNoteAsImage(key, note),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                color: Colors.redAccent.withValues(alpha: 0.7),
                                iconSize: 20,
                                onPressed: () {
                                  context.read<NotesBloc>().add(DeleteNote(note.id!));
                                },
                              ),
                              const Spacer(),
                              Text(
                                '${note.createdAt.day}/${note.createdAt.month}/${note.createdAt.year}',
                                style: TextStyle(
                                  color: colors.text.withValues(alpha: 0.4),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
