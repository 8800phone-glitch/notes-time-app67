import 'package:flutter/material.dart';

void main() {
  runApp(const NotesTimeTrackerApp());
}

class NotesTimeTrackerApp extends StatelessWidget {
  const NotesTimeTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Заметки и Время',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const NoteTrackerScreen(),
    );
  }
}

class NoteItem {
  final String text;
  final String startTime;
  final String stopTime;

  NoteItem({
    required this.text,
    required this.startTime,
    required this.stopTime,
  });
}

class NoteTrackerScreen extends StatefulWidget {
  const NoteTrackerScreen({super.key});

  @override
  State<NoteTrackerScreen> createState() => _NoteTrackerScreenState();
}

class _NoteTrackerScreenState extends State<NoteTrackerScreen> {
  final TextEditingController _noteController = TextEditingController();
  String _startTime = 'Не задано';
  String _stopTime = 'Не задано';
  final List<NoteItem> _savedNotes = [];

  // Форматирование текущего времени в ЧЧ:ММ:СС
  String _getCurrentFormattedTime() {
    final now = DateTime.now();
    final hours = now.hour.toString().padLeft(2, '0');
    final minutes = now.minute.toString().padLeft(2, '0');
    final seconds = now.second.toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  void _onStartPressed() {
    setState(() {
      _startTime = _getCurrentFormattedTime();
      _stopTime = 'В процессе...';
    });
  }

  void _onStopPressed() {
    setState(() {
      _stopTime = _getCurrentFormattedTime();
    });
  }

  void _saveNote() {
    final text = _noteController.text.trim();
    if (text.isEmpty && _startTime == 'Не задано') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите текст заметки или нажмите Старт')),
      );
      return;
    }

    setState(() {
      _savedNotes.insert(
        0,
        NoteItem(
          text: text.isEmpty ? 'Заметка без текста' : text,
          startTime: _startTime,
          stopTime: _stopTime,
        ),
      );
      _noteController.clear();
      _startTime = 'Не задано';
      _stopTime = 'Не задано';
    });
  }

  void _deleteNote(int index) {
    setState(() {
      _savedNotes.removeAt(index);
    });
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Заметки и Время',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Поле ввода заметки
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Введите текст заметки...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Кнопки Старт и Стоп
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _onStartPressed,
                    icon: const Icon(Icons.play_arrow, color: Colors.white),
                    label: const Text(
                      'Старт',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _onStopPressed,
                    icon: const Icon(Icons.stop, color: Colors.white),
                    label: const Text(
                      'Стоп',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Карточка отображения текущего времени Старт / Стоп
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Время старта:',
                        style: TextStyle(fontSize: 15, color: Colors.black54),
                      ),
                      Text(
                        _startTime,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade800,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Время стопа:',
                        style: TextStyle(fontSize: 15, color: Colors.black54),
                      ),
                      Text(
                        _stopTime,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Кнопка сохранения заметки
            FilledButton.icon(
              onPressed: _saveNote,
              icon: const Icon(Icons.save),
              label: const Text('Сохранить заметку', style: TextStyle(fontSize: 16)),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Сохранённые записи:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Список сохранённых заметок
            Expanded(
              child: _savedNotes.isEmpty
                  ? const Center(
                      child: Text(
                        'Пока нет сохранённых заметок',
                        style: TextStyle(color: Colors.black45),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _savedNotes.length,
                      itemBuilder: (context, index) {
                        final item = _savedNotes[index];
                        return Card(
                          color: Colors.white,
                          margin: const EdgeInsets.only(bottom: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(
                              item.text,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Text(
                                'Старт: ${item.startTime}  |  Стоп: ${item.stopTime}',
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.grey),
                              onPressed: () => _deleteNote(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
