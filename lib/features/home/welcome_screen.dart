import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_screen.dart';
import 'UserDashboardScreen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passportController = TextEditingController(); // controller رقم الجواز
  final TextEditingController _passengersCountController = TextEditingController(text: '1');

  String _passengerType = 'ordinary';
  String _selectedLanguage = 'ar';
  String _selectedCountryCode = '+972';

  final List<Map<String, String>> _countryCodes = [
    {'code': '+972', 'flag': '🇮🇱', 'name_ar': 'إسرائيل', 'name_en': 'Israel', 'name_he': 'ישראל'},
    {'code': '+962', 'flag': '🇯🇴', 'name_ar': 'الأردن', 'name_en': 'Jordan', 'name_he': 'ירדן'},
    {'code': '+970', 'flag': '🇵🇸', 'name_ar': 'فلسطين', 'name_en': 'Palestine', 'name_he': 'רשות פלסטינית'},
    {'code': '+1', 'flag': '🇺🇸', 'name_ar': 'أمريكا', 'name_en': 'USA', 'name_he': 'ארה"ב'},
  ];

  Map<String, Map<String, String>> get _localizedTexts => {
    'ar': {
      'app_title': 'منصة معبر الشيخ حسين',
      'contact_us': 'اتصل بنا',
      'welcome_title': 'أهلاً بك في منصة معبر الشيخ حسين',
      'welcome_sub': 'يرجى إدخال معلوماتك الأساسية للاطلاع على كافة خدمات السفر والنقل المتوفرة.',
      'name_label': 'الاسم الكامل',
      'name_error': 'يرجى إدخال الاسم',
      'passport_label': 'رقم جواز السفر',
      'passport_error': 'يرجى إدخال رقم جواز السفر',
      'phone_label': 'رقم الهاتف (9 أرقام)',
      'phone_hint': '525980725',
      'phone_error_empty': 'يرجى إدخال رقم الهاتف',
      'phone_error_invalid': 'رقم الهاتف يجب أن يتكون من 9 أرقام فقط',
      'passenger_type': 'صفة المسافر',
      'type_ordinary': 'مسافر (إسرائيلي، عرب 48)',
      'type_jerusalem': 'مواطن مقدسي (بطاقات خاصة)',
      'passengers_count': 'عدد المسافرين',
      'passengers_count_error': 'يرجى إدخال عدد المسافرين (1 أو أكثر)',
      'btn_next': 'الاطلاع على المنصة والخدمات',
      'btn_dashboard': 'متابعة وإدارة حجوزاتي السابقة',
      'badge': 'المعبر الشمالي الأردني',
      'bridge_name': 'جسر الشيخ حسين\n(معبر نهر الأردن)',
      'bridge_desc': 'البوابة الشمالية الرئيسية للربط والنقل بين الأردن وإسرائيل. توفر المنصة خدمات حجز السيارات الخاصة، VIP، واستقبال الجروبات بكفاءة وسرعة.',
      'close': 'إغلاق',
      'visitor_count': 'الزوار:',
    },
    'en': {
      'app_title': 'Sheikh Hussein Platform',
      'contact_us': 'Contact',
      'welcome_title': 'Welcome to Sheikh Hussein Platform',
      'welcome_sub': 'Please enter your basic info to explore available travel & transport services.',
      'name_label': 'Full Name',
      'name_error': 'Please enter your name',
      'passport_label': 'Passport Number',
      'passport_error': 'Please enter passport number',
      'phone_label': 'Phone Number (9 digits)',
      'phone_hint': '525980725',
      'phone_error_empty': 'Please enter phone number',
      'phone_error_invalid': 'Phone number must be exactly 9 digits',
      'passenger_type': 'Passenger Category',
      'type_ordinary': 'Passenger (Israeli / 48 Arabs)',
      'type_jerusalem': 'Jerusalem Resident (Special IDs)',
      'passengers_count': 'Number of Passengers',
      'passengers_count_error': 'Please enter valid passengers count (1 or more)',
      'btn_next': 'Explore Platform & Services',
      'btn_dashboard': 'My Bookings & Dashboard',
      'badge': 'Northern Jordan Border',
      'bridge_name': 'Sheikh Hussein Bridge\n(Jordan River Crossing)',
      'bridge_desc': 'The main northern border connecting Jordan and Israel. Providing private transport, VIP, and group services efficiently.',
      'close': 'Close',
      'visitor_count': 'Visitors:',
    },
    'he': {
      'app_title': 'מעבר שייח חוסיין',
      'contact_us': 'צור קשר',
      'welcome_title': 'ברוכים הבאים למעבר שייח חוסיין',
      'welcome_sub': 'אנא הזן את פרטיך הבסיסיים כדי לצפות בכל שירותי הנסיעות והתחבורה.',
      'name_label': 'שם מלא',
      'name_error': 'נא להזין שם',
      'passport_label': 'מספר דרכון',
      'passport_error': 'נא להזין מספר דרכון',
      'phone_label': 'מספר טלפון (9 ספרות)',
      'phone_hint': '525980725',
      'phone_error_empty': 'נא להזין מספר טלפון',
      'phone_error_invalid': 'מספר הטלפון חייב להכיל 9 ספרות בדיוק',
      'passenger_type': 'סוג נוסע',
      'type_ordinary': 'נוסע (ישראלי / ערביי 48)',
      'type_jerusalem': 'תושב ירושלים (תעודות מיוחדות)',
      'passengers_count': 'מספר נוסעים',
      'passengers_count_error': 'נא להזין מספר נוסעים תקין (1 ומעלה)',
      'btn_next': 'לצפייה בשירותי הפלטפורמה',
      'btn_dashboard': 'ניהול ומעקב אחר ההזמנות שלי',
      'badge': 'מעבר גבול צפון ירדן',
      'bridge_name': 'גשר שייח חוסיין\n(מעבר נהר הירדן)',
      'bridge_desc': 'מעבר הגבול הצפוני הראשי המחבר בין ירדן לישראל. מספק שירותי הסעות פרטיות, VIP וקבוצות ביעילות.',
      'close': 'סגור',
      'visitor_count': 'מבקרים:',
    },
  };

  String _t(String key) => _localizedTexts[_selectedLanguage]?[key] ?? key;

  @override
  void initState() {
    super.initState();
    _incrementVisitorCount();
  }

  Future<void> _incrementVisitorCount() async {
    try {
      final docRef = FirebaseFirestore.instance.collection('analytics').doc('visitors');
      await docRef.set({
        'count': FieldValue.increment(1),
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error updating visitors count: $e');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passportController.dispose();
    _passengersCountController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri uri = Uri.parse(urlString);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $urlString');
    }
  }

  void _navigateToDashboard() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserDashboardScreen(
          currentLanguage: _selectedLanguage,
        ),
      ),
    );
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    return Directionality(
      textDirection: _selectedLanguage == 'he' || _selectedLanguage == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF1E3A8A),
          foregroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 8,
          title: Text(
            _t('app_title'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: screenWidth < 400 ? 13 : 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.dashboard_outlined, color: Colors.white, size: 22),
              tooltip: _t('btn_dashboard'),
              onPressed: _navigateToDashboard,
            ),
            if (screenWidth > 400)
              Flexible(
                fit: FlexFit.loose,
                child: _buildAppBarVisitorBadge(compact: screenWidth < 480),
              ),
            IconButton(
              icon: const Icon(Icons.headset_mic, color: Colors.white, size: 20),
              tooltip: _t('contact_us'),
              onPressed: () => _showContactUsDialog(context),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.language, color: Colors.white, size: 20),
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
                _buildBridgeInfoSection(height: screenWidth < 380 ? 220 : 250),
                _buildRegistrationSection(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBarVisitorBadge({bool compact = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('analytics')
            .doc('visitors')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              width: 10,
              height: 10,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            );
          }

          final data = snapshot.data?.data() as Map<String, dynamic>?;
          final int count = data?['count'] ?? 0;

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.remove_red_eye_outlined, size: 12, color: Colors.white),
              const SizedBox(width: 4),
              if (!compact) ...[
                Text(
                  '${_t('visitor_count')} ',
                  style: const TextStyle(fontSize: 10, color: Colors.white70),
                ),
              ],
              Text(
                '$count',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRegistrationSection(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.stars_rounded, size: 36, color: Color(0xFF1E3A8A)),
                  const SizedBox(height: 8),
                  Text(
                    _t('welcome_title'),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A)),
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

                  // رقم جواز السفر (الحقل الجديد)
                  TextFormField(
                    controller: _passportController,
                    decoration: InputDecoration(
                      labelText: _t('passport_label'),
                      prefixIcon: const Icon(Icons.menu_book_outlined),
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    validator: (value) => value == null || value.trim().isEmpty ? _t('passport_error') : null,
                  ),
                  const SizedBox(height: 10),

                  // رقم الهاتف
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 110,
                        child: DropdownButtonFormField<String>(
                          value: _selectedCountryCode,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                          ),
                          items: _countryCodes.map((country) {
                            return DropdownMenuItem<String>(
                              value: country['code'],
                              child: Text(
                                '${country['flag']} ${country['code']}',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                textDirection: TextDirection.ltr,
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _selectedCountryCode = val);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.left,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(9),
                            ],
                            decoration: InputDecoration(
                              labelText: _t('phone_label'),
                              hintText: _t('phone_hint'),
                              hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return _t('phone_error_empty');
                              }
                              final cleanPhone = value.trim();
                              if (cleanPhone.length != 9) {
                                return _t('phone_error_invalid');
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
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
                        child: Text(_t('type_ordinary'), overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13)),
                      ),
                      DropdownMenuItem(
                        value: 'jerusalem',
                        child: Text(_t('type_jerusalem'), overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13)),
                      ),
                    ],
                    onChanged: (val) => setState(() => _passengerType = val!),
                  ),
                  const SizedBox(height: 10),

                  // عدد المسافرين
                  TextFormField(
                    controller: _passengersCountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
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

                  // زر الانتقال للصفحة الرئيسية
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
                          final fullPhoneNumber = '$_selectedCountryCode${_phoneController.text.trim()}';

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(
                                userName: _nameController.text.trim(),
                                userPhone: fullPhoneNumber,
                                passportNumber: _passportController.text.trim(), // تم تمرير رقم الجواز هنا
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
                          Text(_t('btn_next'), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          Icon(
                            _selectedLanguage == 'en' ? Icons.arrow_forward : Icons.arrow_back,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // زر متابعة الحجوزات
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF1E3A8A),
                        side: const BorderSide(color: Color(0xFF1E3A8A)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: _navigateToDashboard,
                      icon: const Icon(Icons.confirmation_number_outlined, size: 18),
                      label: Text(
                        _t('btn_dashboard'),
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
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
      width: double.infinity,
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
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD97706),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(_t('badge'), style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _t('bridge_name'),
                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, height: 1.2),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _t('bridge_desc'),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}