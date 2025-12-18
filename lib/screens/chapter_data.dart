import 'package:flutter/material.dart';

const String prefaceText =
    ''' میں نہیں چاہتا کہ قارئین اور اس کتاب کے درمیان رکاوٹ بنوں جو بہت سے لوگوں کی زندگیاں بدل چکی ہے۔ لیکن ایک دو گزارشات نظر ثانی کے حوالے سے عرض کرنی ہیں۔ پہلی یہ کہ کتاب پر نظر ثانی کے دوران میں متعدد چھوٹی بڑی تبدیلیاں کی گئی ہیں۔ ان میں سب سے اہم ناول کا اختتام ہے۔ اس کی وجہ بعض قارئین کی یہ رائے تھی کہ سابقہ اختتام پر ان کے یقین کی کیفیت قدرے کم ہوئی ہے۔ جبکہ میرا بنیادی مقصد ہی آخرت پر یقین پیدا کرنا تھا۔ نئے اختتام میں انشاء اللہ یقین کی یہ کیفیت برقرار رہے گی۔ جبکہ دوسرا سبب یہ ہے کہ ناول کا اگلا حصہ (Sequel) ”قسم اُس وقت کی“ لکھنا میرے پیش نظر ہے۔ یہ اختتام اس پہلو سے بھی مددگار ثابت ہوگا۔
قارئین بہت سے سوالات پوچھتے رہے ہیں۔اس حوالے سے ایک مفصل تحریر لکھ کر ناول کی ویب سائٹ inzaar.orgلوڈ کر دی گئی ہے۔ اسی طرح نظر ثانی شدہ ایڈیشن کا تفصیلی دیباچہ بھی قارئین وہیں ملاحظہ کر سکتے ہیں۔ کتاب میں ان چیزوں کو شامل نہ کرنے کی وجہ ناول کی ضخامت اور نتیجتاً قیمت کو اس ہوشربا مہنگائی کے دور میں بڑھنے سے روکنا ہے۔
اللہ تعالیٰ سے دعا ہے کہ وہ ہماری خطاؤں کو درگزر کرتے ہوئے اس کاوش کو قبول فرمائے،آمین۔
ابو یحییٰ
یوم العرفہ 1432ھ بمطابق 6 نومبر 2011''';

final List<Map<String, dynamic>> chapterItems = [
  {
    "title": "دنیا پر نظر ثانی شدہ ایڈیشن",
    "icon": Icons.menu_book,
    "progress": 0.05,
    "readingText": prefaceText,
  },
  {
    "title": "کچھ وضاحتیں، کچھ حدیثیں",
    "icon": Icons.library_books,
    "progress": 0.07,
  },
  {"title": "روزِ قیامت", "icon": Icons.balance, "progress": 0.12},
  {"title": "عرش کے سائے میں", "icon": Icons.shield, "progress": 0.18},
  {"title": "میدانِ حشر", "icon": Icons.public, "progress": 0.25},
  {"title": "نامۂ اعمال", "icon": Icons.assignment, "progress": 0.30},
  {"title": "دوزخ", "icon": Icons.local_fire_department, "progress": 0.35},
  {
    "title": "آج بادشاہی کس کی ہے؟",
    "icon": Icons.emoji_events,
    "progress": 0.40,
  },
  {
    "title": "حضرت عیسیٰؑ کی گواہی",
    "icon": Icons.person_2_outlined,
    "progress": 0.45,
  },
  {"title": "حوضِ کوثر", "icon": Icons.water_drop_outlined, "progress": 0.50},
  {
    "title": "قومِ نوح اور دین کو بدلنے والے",
    "icon": Icons.groups,
    "progress": 0.60,
  },
  {
    "title": "حسابِ کتاب اور اہلِ جہنم",
    "icon": Icons.calculate,
    "progress": 0.70,
  },
  {"title": "آخرت کا سفر", "icon": Icons.route, "progress": 0.78},
  {"title": "نبی ﷺ اسرائیل اور مسلمان", "icon": Icons.star, "progress": 0.85},
  {
    "title": "ابدیت انجام کی طرف روانگی",
    "icon": Icons.timeline,
    "progress": 0.92,
  },
  {
    "title": "جنت کی بادشاہی میں داخلہ",
    "icon": Icons.king_bed,
    "progress": 0.97,
  },
  {"title": "جب زندگی شروع ہوگی", "icon": Icons.auto_stories, "progress": 1.0},
];
