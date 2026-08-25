import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'home_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passengersCountController = TextEditingController(text: '1');

  String _passengerType = 'ordinary';
  String _selectedLanguage = 'ar'; // اللغات: ar, en, he

  // قاموس النصوص لجميع اللغات
  Map<String, Map<String, String>> get _localizedTexts => {
    'ar': {
      'app_title': 'منصة معبر الشيخ حسين',
      'contact_us': 'اتصل بنا',
      'welcome_title': 'أهلاً بك في منصة معبر الشيخ حسين',
      'welcome_sub': 'يرجى إدخال معلوماتك الأساسية للاطلاع على كافة خدمات السفر والنقل المتوفرة.',
      'name_label': 'الاسم الكامل',
      'name_error': 'يرجى إدخال الاسم',
      'phone_label': 'رقم الهاتف / الواتساب مع رمز الدولة',
      'phone_hint': 'مثال: 962790000000+ أو 00962790000000',
      'phone_error_empty': 'يرجى إدخال رقم الهاتف',
      'phone_error_invalid': 'رمز الدولة مطلوب (أرقام فقط، مثال: 962790000000+)',
      'phone_error_short': 'رقم الهاتف قصير جداً، يرجى كتابة الرقم مع رمز الدولة الكامل',
      'passenger_type': 'صفة المسافر',
      'type_ordinary': 'مسافر (إسرائيلي، عرب 48)',
      'type_jerusalem': 'مواطن مقدسي (بطاقات خاصة)',
      'passengers_count': 'عدد المسافرين',
      'passengers_count_error': 'يرجى إدخال عدد المسافرين (1 أو أكثر)',
      'btn_next': 'الاطلاع على المنصة والخدمات',
      'badge': 'المعبر الشمالي الأردني',
      'bridge_name': 'جسر الشيخ حسين\n(معبر نهر الأردن)',
      'bridge_desc': 'البوابة الشمالية الرئيسية للربط والنقل بين الأردن وإسرائيل. توفر المنصة خدمات حجز السيارات الخاصة، VIP، واستقبال الجروبات بكفاءة وسرعة.',
      'close': 'إغلاق',
    },
    'en': {
      'app_title': 'Sheikh Hussein Border Platform',
      'contact_us': 'Contact Us',
      'welcome_title': 'Welcome to Sheikh Hussein Platform',
      'welcome_sub': 'Please enter your basic info to explore available travel & transport services.',
      'name_label': 'Full Name',
      'name_error': 'Please enter your name',
      'phone_label': 'Phone / WhatsApp with Country Code',
      'phone_hint': 'e.g. +962790000000 or 00962790000000',
      'phone_error_empty': 'Please enter phone number',
      'phone_error_invalid': 'Country code required (Numbers only, e.g. +962790000000)',
      'phone_error_short': 'Phone number too short, include country code',
      'passenger_type': 'Passenger Category',
      'type_ordinary': 'Passenger (Israeli / 48 Arabs)',
      'type_jerusalem': 'Jerusalem Resident (Special IDs)',
      'passengers_count': 'Number of Passengers',
      'passengers_count_error': 'Please enter valid passengers count (1 or more)',
      'btn_next': 'Explore Platform & Services',
      'badge': 'Northern Jordan Border',
      'bridge_name': 'Sheikh Hussein Bridge\n(Jordan River Crossing)',
      'bridge_desc': 'The main northern border connecting Jordan and Israel. Providing private transport, VIP, and group services efficiently.',
      'close': 'Close',
    },
    'he': {
      'app_title': 'פלטפורמת מעבר שייח חוסיין',
      'contact_us': 'צור קשר',
      'welcome_title': 'ברוכים הבאים למעבר שייח חוסיין',
      'welcome_sub': 'אנא הזן את פרטיך הבסיסיים כדי לצפות בכל שירותי הנסיעות והתחבורה.',
      'name_label': 'שם מלא',
      'name_error': 'נא להזין שם',
      'phone_label': 'מספר טלפון / וואטסאפ כולל קידומת בינלאומית',
      'phone_hint': 'לדוגמה: 962790000000+ או 00962790000000',
      'phone_error_empty': 'נא להזין מספר טלפון',
      'phone_error_invalid': 'חובה לכלול קידומת מדינה (מספרים בלבד)',
      'phone_error_short': 'מספר הטלפון קצר מדי, נא לכלול קידומת בינלאומית מלאה',
      'passenger_type': 'סוג נוסע',
      'type_ordinary': 'נוסע (ישראלי / ערביי 48)',
      'type_jerusalem': 'תושב ירושלים (תעודות מיוחדות)',
      'passengers_count': 'מספר נוסעים',
      'passengers_count_error': 'נא להזין מספר נוסעים תקין (1 ומעלה)',
      'btn_next': 'לצפייה בשירותי הפלטפורמה',
      'badge': 'מעבר גבול צפון ירדן',
      'bridge_name': 'גשר שייח חוסיין\n(מעבר נהר הירדן)',
      'bridge_desc': 'מעבר הגבול הצפוני הראשי המחבר בין ירדן לישראל. מספק שירותי הסעות פרטיות, VIP וקבוצות ביעילות.',
      'close': 'סגור',
    },
  };

  String _t(String key) => _localizedTexts[_selectedLanguage]?[key] ?? key;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passengersCountController.dispose();
    super.dispose();
  }

  // دالة المساعدة لفتح الاتصال الهاتفي أو تطبيق واتساب
  Future<void> _launchUrl(String urlString) async {
    final Uri uri = Uri.parse(urlString);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $urlString');
    }
  }

  void _showContactUsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.support_agent, color: Color(0xFF1E3A8A)),
            const SizedBox(width: 8),
            Text(_t('contact_us')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('تواصل معنا / Contact Us / צור קשר:'),
            const SizedBox(height: 16),

            // خيار الاتصال الهاتفي المباشر
            InkWell(
              onTap: () => _launchUrl('tel:+962772932636'),
              borderRadius: BorderRadius.circular(8),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                child: Row(
                  children: [
                    Icon(Icons.phone, color: Colors.green, size: 22),
                    SizedBox(width: 12),
                    Text(
                      '📞 +962 772932636',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 16),

            // خيار المراسلة عبر واتساب
            InkWell(
              onTap: () => _launchUrl('https://wa.me/972525980725'),
              borderRadius: BorderRadius.circular(8),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                child: Row(
                  children: [
                    Icon(Icons.chat_bubble, color: Color(0xFF25D366), size: 22),
                    SizedBox(width: 12),
                    Text(
                      '💬 +972 525980725 (WhatsApp)',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_t('close')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Directionality(
      textDirection: _selectedLanguage == 'he' || _selectedLanguage == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF1E3A8A),
          foregroundColor: Colors.white,
          elevation: 0,
          title: Text(_t('app_title'), style: const TextStyle(fontSize: 18)),
          actions: [
            TextButton.icon(
              onPressed: () => _showContactUsDialog(context),
              icon: const Icon(Icons.headset_mic, color: Colors.white, size: 20),
              label: Text(_t('contact_us'), style: const TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              icon: const Row(
                children: [
                  Icon(Icons.language, color: Colors.white),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_drop_down, color: Colors.white),
                ],
              ),
              onSelected: (String lang) {
                setState(() {
                  _selectedLanguage = lang;
                });
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(value: 'ar', child: Text('🇸🇦 العربية')),
                const PopupMenuItem<String>(value: 'en', child: Text('🇬🇧 English')),
                const PopupMenuItem<String>(value: 'he', child: Text('🇮🇱 עברית')),
              ],
            ),
            const SizedBox(width: 12),
          ],
        ),
        body: SafeArea(
          child: isDesktop
              ? Row(
            children: [
              Expanded(flex: 5, child: _buildRegistrationSection(context)),
              Expanded(flex: 7, child: _buildBridgeInfoSection()),
            ],
          )
              : SingleChildScrollView(
            child: Column(
              children: [
                _buildBridgeInfoSection(height: 250),
                _buildRegistrationSection(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegistrationSection(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.stars_rounded, size: 38, color: Color(0xFF1E3A8A)),
                  const SizedBox(height: 8),
                  Text(
                    _t('welcome_title'),
                    style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _t('welcome_sub'),
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 14),

                  // الاسم
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: _t('name_label'),
                      prefixIcon: const Icon(Icons.person_outline),
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    validator: (value) => value == null || value.trim().isEmpty ? _t('name_error') : null,
                  ),
                  const SizedBox(height: 10),

                  // رقم الهاتف
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: _t('phone_label'),
                      hintText: _t('phone_hint'),
                      hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                      prefixIcon: const Icon(Icons.phone_android),
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return _t('phone_error_empty');
                      }

                      final cleanPhone = value.trim();

                      // التحقق من صيغة الهاتف مع الرمز الدولي (+ أو أرقام فقط)
                      final phoneRegex = RegExp(r'^(\+|\d)[0-9]{7,15}$');
                      if (!phoneRegex.hasMatch(cleanPhone) || RegExp(r'[a-zA-Z\u0600-\u06FF]').hasMatch(cleanPhone)) {
                        return _t('phone_error_invalid');
                      }

                      // التحقق من أن الطول يحتوي على رمز الدولة بالإضافة للرقم المحلي (8 أرقام على الأقل)
                      if (cleanPhone.replaceAll('+', '').length < 8) {
                        return _t('phone_error_short');
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // صفة المسافر
                  DropdownButtonFormField<String>(
                    value: _passengerType,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: _t('passenger_type'),
                      prefixIcon: const Icon(Icons.badge_outlined),
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'ordinary',
                        child: Text(_t('type_ordinary'), overflow: TextOverflow.ellipsis),
                      ),
                      DropdownMenuItem(
                        value: 'jerusalem',
                        child: Text(_t('type_jerusalem'), overflow: TextOverflow.ellipsis),
                      ),
                    ],
                    onChanged: (val) => setState(() => _passengerType = val!),
                  ),
                  const SizedBox(height: 10),

                  // عدد المسافرين
                  TextFormField(
                    controller: _passengersCountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: _t('passengers_count'),
                      prefixIcon: const Icon(Icons.group_outlined),
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return _t('passengers_count_error');
                      }
                      final count = int.tryParse(value.trim());
                      if (count == null || count < 1) {
                        return _t('passengers_count_error');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // زر الانتقال لتمرير البيانات إلى HomeScreen
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(
                                userName: _nameController.text.trim(),
                                userPhone: _phoneController.text.trim(),
                                passengerType: _passengerType,
                                passengersCount: int.parse(_passengersCountController.text.trim()),
                                initialLanguage: _selectedLanguage,
                              ),
                            ),
                          );
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_t('btn_next'), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          Icon(
                            _selectedLanguage == 'en' ? Icons.arrow_forward : Icons.arrow_back,
                            size: 18,
                          ),
                        ],
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

  Widget _buildBridgeInfoSection({double? height}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF1E3A8A), Colors.blue.shade900],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      child: Stack(
        children: [
          Opacity(
            opacity: 0.25,
            child: Image.network(
              'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?q=80&w=1200',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(color: Colors.blueGrey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD97706),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(_t('badge'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 16),
                Text(
                  _t('bridge_name'),
                  style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, height: 1.2),
                ),
                const SizedBox(height: 14),
                Text(
                  _t('bridge_desc'),
                  style: const TextStyle(color: Colors.white70, fontSize: 15, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}