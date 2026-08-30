import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'TransportBookingScreen.dart'; // <--- تم تعديل حالة الأحرف هنا
import 'HotelBookingScreen.dart';     // <--- تم تعديل حالة الأحرف هنا

class HomeScreen extends StatefulWidget {
  final String userName;
  final String userPhone;
  final String passportNumber;
  final String passengerType;
  final int passengersCount;
  final String initialLanguage;

  const HomeScreen({
    super.key,
    required this.userName,
    required this.userPhone,
    required this.passportNumber,
    required this.passengerType,
    required this.passengersCount,
    this.initialLanguage = 'ar',
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.initialLanguage;
  }

  Map<String, Map<String, String>> get _localizedTexts => {
    'ar': {
      'app_title': 'منصة معبر الشيخ حسين',
      'contact_us': 'اتصل بنا',
      'welcome_user': 'أهلاً بك، ',
      'home_sub': 'تصفح كافة الخدمات المتاحة لمعبر الشيخ حسين وقم بتقديم طلبك بسهولة.',
      'passengers_info': 'عدد المسافرين المسجل: ',
      'passport_info': 'رقم الجواز: ',
      'services_title': 'الخدمات المتاحة',
      'transport_visa_escort_service': 'خدمة تأشيرة الدخول مع مندوب ووسيلة النقل',
      'transport_visa_escort_desc': 'توفير خدمات المندوب، إصدار التأشيرات، وحجز وسائط النقل (سيارات خاصة، فان) أو بدون نقل.',
      'hotel_service': 'حجز الفنادق والإقامة',
      'hotel_desc': 'عروض وحجوزات مميزة لأفضل الفنادق وأماكن الإقامة القريبة.',
      'book_now': 'طلب الخدمة الآن',
      'close': 'إغلاق',
    },
    'en': {
      'app_title': 'Sheikh Hussein Border Platform',
      'contact_us': 'Contact Us',
      'welcome_user': 'Welcome, ',
      'home_sub': 'Browse all available services for Sheikh Hussein crossing and submit your request.',
      'passengers_info': 'Registered Passengers: ',
      'passport_info': 'Passport No: ',
      'services_title': 'Available Services',
      'transport_visa_escort_service': 'Entry Visa, Escort & Transport Service',
      'transport_visa_escort_desc': 'Providing escort assistance, entry visa processing, and transport bookings (private cars, vans) or visa only.',
      'hotel_service': 'Hotel & Accommodation Bookings',
      'hotel_desc': 'Exclusive deals and reservations for top nearby hotels.',
      'book_now': 'Request Service Now',
      'close': 'Close',
    },
    'he': {
      'app_title': 'פלטפורמת מעבר שייח חוסיין',
      'contact_us': 'צור קשר',
      'welcome_user': 'ברוך הבא, ',
      'home_sub': 'עיין בכל השירותים הזמינים במעבר שייח חוסיין ושלח את בקשתך בקלות.',
      'passengers_info': 'מספר נוסעים רשום: ',
      'passport_info': 'מספר דרכון: ',
      'services_title': 'שירותים זמינים',
      'transport_visa_escort_service': 'שירות ויזת כניסה, נציג מלווה ותחבורה',
      'transport_visa_escort_desc': 'אספקת שירותי נציג מלווה, הנפקת ויזות והזמנת הסעות (רכבים פרטיים, ואנים) או ללא הסעה.',
      'hotel_service': 'הזמנת מלונות ואירוח',
      'hotel_desc': 'מבצעים והזמנות בלעדיות למלונות המובילים באזור.',
      'book_now': 'בצע הזמנה עכשיו',
      'close': 'סגור',
    },
  };

  String _t(String key) => _localizedTexts[_selectedLanguage]?[key] ?? key;

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
            style: TextStyle(
              fontSize: screenWidth < 380 ? 13 : 15,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.headset_mic, color: Colors.white, size: 20),
              tooltip: _t('contact_us'),
              onPressed: () => _showContactUsDialog(context),
            ),
            PopupMenuButton<String>(
              padding: EdgeInsets.zero,
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
            const SizedBox(width: 4),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E3A8A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_t('welcome_user')}${widget.userName}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _t('home_sub'),
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${_t('passengers_info')}${widget.passengersCount}',
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${_t('passport_info')}${widget.passportNumber}',
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Text(
                  _t('services_title'),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
                const SizedBox(height: 14),

                _buildResponsiveServiceCard(
                  icon: Icons.assignment_ind_rounded,
                  title: _t('transport_visa_escort_service'),
                  description: _t('transport_visa_escort_desc'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransportBookingScreen(
                          userName: widget.userName,
                          userPhone: widget.userPhone,
                          passportNumber: widget.passportNumber,
                          passengerType: widget.passengerType,
                          passengersCount: widget.passengersCount,
                          currentLanguage: _selectedLanguage,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),

                _buildResponsiveServiceCard(
                  icon: Icons.hotel_rounded,
                  title: _t('hotel_service'),
                  description: _t('hotel_desc'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HotelBookingScreen(
                          userName: widget.userName,
                          userPhone: widget.userPhone,
                          passportNumber: widget.passportNumber,
                          passengerType: widget.passengerType,
                          passengersCount: widget.passengersCount,
                          currentLanguage: _selectedLanguage,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResponsiveServiceCard({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onPressed,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 450;

            if (isNarrow) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E3A8A).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(icon, color: const Color(0xFF1E3A8A), size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E3A8A),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    description,
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: onPressed,
                      child: Text(_t('book_now'), style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E3A8A).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: const Color(0xFF1E3A8A), size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3A8A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(color: Colors.grey.shade700, fontSize: 13, height: 1.3),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3A8A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: onPressed,
                  child: Text(_t('book_now')),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}