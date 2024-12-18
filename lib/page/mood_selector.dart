import 'package:flutter/material.dart';
import 'diary_page.dart';

class MoodSelector extends StatefulWidget {
  final DateTime selectedDate;

  const MoodSelector({Key? key, required this.selectedDate}) : super(key: key);

  @override
  _MoodSelectorState createState() => _MoodSelectorState();
}

class _MoodSelectorState extends State<MoodSelector> {
  final List<Map<String, dynamic>> moods = [
    {'label': 'SAD', 'imagePath': 'assets/sad.jpg', 'color': Colors.blueGrey},
    {'label': 'ANGRY', 'imagePath': 'assets/angry.jpg', 'color': Colors.red},
    {'label': 'CONFIDENCE', 'imagePath': 'assets/confidence.jpg', 'color': Colors.green},
    {'label': 'EXCITED', 'imagePath': 'assets/excited.jpg', 'color': Colors.orange},
    {'label': 'ANXIETY', 'imagePath': 'assets/anxiety.jpg', 'color': Colors.purple},
    {'label': 'HAPPY', 'imagePath': 'assets/happy.jpg', 'color': Colors.yellow},
  ];

  Future<void> _showSplashAndNavigate(String label, String imagePath, Color color) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
            ),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.7,
                ),
              ),
            ),
          ),
        );
      },
    );

    await Future.delayed(Duration(seconds: 1));
    Navigator.pop(context); // 스플래시 화면 닫기

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiaryPage(
          selectedDate: widget.selectedDate,
          backgroundColor: color,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        // leading 속성 제거하여 기본 뒤로 가기 버튼 표시
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              print("Settings button pressed");
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Today's",
              style: TextStyle(fontSize: 28, color: Colors.purple),
            ),
            Text(
              "MOOD",
              style: TextStyle(fontSize: 36, color: Colors.purple, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: moods.length,
                itemBuilder: (context, index) {
                  final mood = moods[index];
                  return GestureDetector(
                    onTap: () {
                      _showSplashAndNavigate(
                        mood['label'] as String,
                        mood['imagePath'] as String,
                        mood['color'] as Color,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.purple[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          mood['imagePath'] as String,
                          fit: BoxFit.cover,
                        ),
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
