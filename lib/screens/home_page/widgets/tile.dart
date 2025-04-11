import 'package:audio_player/core/models/song_model.dart';
import 'package:audio_player/screens/audio_page/audio_page.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final SongModel song;

  const CustomListTile({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayPage(song: song), // إرسال الكائن
          ),
        );
      },
      contentPadding: EdgeInsets.symmetric(
          vertical: 10, horizontal: 15), // حواف داخلية للقائمة
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          song.image,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        song.songName,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18, // تغيير الحجم لجعل النص أكبر
        ),
      ),
      subtitle: Text(
        song.artistName,
        style: TextStyle(
          color: Colors.grey[400],
          fontSize: 14, // حجم النص للمغني
        ),
      ),
      trailing: IconButton(
        icon: Icon(
          Icons
              .favorite_border, // يمكنك تغييرها إلى Icons.favorite لتمثيل حالة الإعجاب
          color: Colors.red, // اللون الأحمر لقلب الإعجاب
        ),
        onPressed: () {
          // هنا يمكنك إضافة الوظيفة المطلوبة مثل تغيير حالة الإعجاب
          // مثل تخزين حالة الإعجاب باستخدام SharedPreferences أو قاعدة بيانات
        },
      ),
    );
  }
}
