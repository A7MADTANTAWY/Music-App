import 'dart:ui'; // لاستخدام ImageFilter
import 'package:audio_player/core/data/play_list.dart';
import 'package:audio_player/screens/home_page/widgets/tile.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/image/BACK.jpg', // استبدل بمسار الصورة الخاصة بك
            fit: BoxFit.cover,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // تأثير التمويه
            child: Container(
              color: Colors.black.withOpacity(0.5), // إضافة شفافية
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.all(15.0), // إضافة بعض المسافات حول المحتوى
            child: ListView.separated(
              itemCount: songs.length + 1, // إضافة عنصر "Favourite" في البداية
              itemBuilder: (context, index) {
                if (index == 0) {
                  // عرض الـ Container عند بداية الـ ListView
                  return Container(
                    height: 100,
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.red,
                          Colors.pinkAccent,
                        ], // استخدام تدرجات لونية عصرية
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius:
                          BorderRadius.circular(30), // جعل الحواف دائرية أكثر
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: Offset(0, 6), // رفع الظل قليلًا
                          blurRadius: 10, // زيادة ضبابية الظل
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // محاذاة المحتوى في المنتصف
                      children: [
                        Text(
                          'Favourite Songs',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize:
                                28, // زيادة حجم الخط قليلاً ليبدو أكثر وضوحاً
                            fontWeight: FontWeight.w600, // جعل الخط ثقيل قليلاً
                            letterSpacing: 1.5, // إضافة تباعد بين الحروف
                          ),
                        ),
                        SizedBox(width: 15), // مسافة بين النص والرمز
                        Icon(
                          Icons.favorite, // رمز القلب
                          color: Colors.white,
                          size: 35, // زيادة حجم الرمز قليلاً
                        ),
                      ],
                    ),
                  );
                } else {
                  // باقي العناصر (الأغاني)
                  final song =
                      songs[index - 1]; // استخدام index - 1 للوصول للأغاني
                  return CustomListTile(song: song);
                }
              },
              separatorBuilder: (context, index) {
                // لا تضع Divider عندما يكون العنصر الأول (Favourite)
                if (index == 0) {
                  return SizedBox.shrink(); // لا شيء تحت عنصر Favourite
                } else {
                  return Divider(
                    color: Colors.grey[400], // لون الخط الفاصل
                    height: 1, // ارتفاع الخط
                    thickness: 1, // سمك الخط
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
