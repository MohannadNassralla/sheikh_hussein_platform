import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDashboardScreen extends StatefulWidget {
  final String currentLanguage;
  const UserDashboardScreen({super.key, required this.currentLanguage});

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passportController = TextEditingController();

  late String _selectedLanguage;
  String _selectedCountryCode = '+972';
  String? _searchedFullPhone;
  String? _searchedPassport;

  TabController? _tabController;

  final List<Map<String, String>> _countryCodes = [
    {'code': '+972', 'flag': '🇮🇱'},
    {'code': '+962', 'flag': '🇯🇴'},
    {'code': '+970', 'flag': '🇵🇸'},
  ];

  final Map<String, Map<String, String>> _localizedStrings = {
    'ar': {
      'title': 'لوحة تحكم الحجوزات',
      'passportLabel': 'رقم الجواز *',
      'passportHint': 'أدخل رقم الجواز',
      'phoneLabel': 'رقم الهاتف (9 أرقام) *',
      'searchBtn': 'بحث عن الحجوزات',
      'tabTransport': 'حجوزات النقل',
      'tabHotel': 'حجوزات الفنادق',
      'errEmpty': 'يرجى إدخال رقم الجواز ورقم الهاتف معاً لاستكمال البحث',
      'errPhoneLen': 'يرجى إدخال رقم هاتف صحيح مكون من 9 أرقام بالضبط',
      'cancelSuccess': 'تم إلغاء الحجز بنجاح',
      'cancelError': 'حدث خطأ أثناء إلغاء الحجز',
      'noBookingsHotel': 'لا توجد حجوزات فنادق مطابقة لهذه البيانات',
      'noBookingsTransport': 'لا توجد حجوزات نقل مطابقة لهذه البيانات',
      'total': 'الإجمالي',
      'confirmed': 'مؤكد',
      'cancelled': 'ملغى',
      'rejected': 'مرفوض',
      'pending': 'قيد الانتظار',
      'dateArrival': 'تاريخ الوصول: ',
      'dateTravel': 'تاريخ السفر: ',
      'passengerName': 'اسم المسافر: ',
      'passportNum': 'رقم الجواز: ',
      'phoneNum': 'رقم الهاتف: ',
      'hotelName': 'الفندق: ',
      'roomsCount': 'عدد الغرف: ',
      'nightsCount': ' | عدد الليالي: ',
      'passengersCount': 'المسافرين: ',
      'vehicleType': ' | وسيلة النقل: ',
      'totalPrice': 'المجموع: ',
      'currency': ' دينار أردني',
      'rejectionReason': 'سبب الرفض: ',
      'btnCancel': 'إلغاء الحجز',
      'cantCancel': '⚠️ لا يمكن الإلغاء (أقل من 48 ساعة على الموعد)',
      'confirmCancelTitle': 'تأكيد الإلغاء',
      'confirmCancelBody': 'هل أنت تأكد من رغبتك في إلغاء هذا الحجز؟',
      'back': 'تراجع',
      'yesCancel': 'نعم، إلغاء',
      'notSpecified': 'غير محدد',
      'notAvailable': 'غير متوفر',
      'private': 'خاصة',
    },
    'en': {
      'title': 'Bookings Dashboard',
      'passportLabel': 'Passport Number *',
      'passportHint': 'Enter Passport Number',
      'phoneLabel': 'Phone Number (9 digits) *',
      'searchBtn': 'Search Bookings',
      'tabTransport': 'Transport Bookings',
      'tabHotel': 'Hotel Bookings',
      'errEmpty': 'Please enter both Passport Number and Phone Number',
      'errPhoneLen': 'Please enter a valid 9-digit phone number',
      'cancelSuccess': 'Booking cancelled successfully',
      'cancelError': 'Error cancelling booking',
      'noBookingsHotel': 'No hotel bookings found for provided details',
      'noBookingsTransport': 'No transport bookings found for provided details',
      'total': 'Total',
      'confirmed': 'Confirmed',
      'cancelled': 'Cancelled',
      'rejected': 'Rejected',
      'pending': 'Pending',
      'dateArrival': 'Check-in Date: ',
      'dateTravel': 'Travel Date: ',
      'passengerName': 'Passenger Name: ',
      'passportNum': 'Passport No: ',
      'phoneNum': 'Phone No: ',
      'hotelName': 'Hotel: ',
      'roomsCount': 'Rooms: ',
      'nightsCount': ' | Nights: ',
      'passengersCount': 'Passengers: ',
      'vehicleType': ' | Vehicle: ',
      'totalPrice': 'Total Price: ',
      'currency': ' JOD',
      'rejectionReason': 'Rejection Reason: ',
      'btnCancel': 'Cancel Booking',
      'cantCancel': '⚠️ Cannot cancel (less than 48 hours remaining)',
      'confirmCancelTitle': 'Confirm Cancellation',
      'confirmCancelBody': 'Are you sure you want to cancel this booking?',
      'back': 'Go Back',
      'yesCancel': 'Yes, Cancel',
      'notSpecified': 'Not specified',
      'notAvailable': 'N/A',
      'private': 'Private',
    },
    'he': {
      'title': 'לוח בקרה להזמנות',
      'passportLabel': 'מספר דרכון *',
      'passportHint': 'הזן מספר דרכון',
      'phoneLabel': 'מספר טלפון (9 ספרות) *',
      'searchBtn': 'חפש הזמנות',
      'tabTransport': 'הזמנות תחבורה',
      'tabHotel': 'הזמנות מלונות',
      'errEmpty': 'יש להזין מספר דרכון ומספר טלפון יחד',
      'errPhoneLen': 'יש להזין מספר טלפון תקין בן 9 ספרות בדיוק',
      'cancelSuccess': 'ההזמנה בוטלה בהצלחה',
      'cancelError': 'אירעה שגיאה בביטול ההזמנה',
      'noBookingsHotel': 'לא נמצאו הזמנות מלון התואמות לפרטים',
      'noBookingsTransport': 'לא נמצאו הזמנות תחבורה התואמות לפרטים',
      'total': 'סה"כ',
      'confirmed': 'מאושר',
      'cancelled': 'מבוטל',
      'rejected': 'נדחה',
      'pending': 'ממתין',
      'dateArrival': 'תאריך הגעה: ',
      'dateTravel': 'תאריך נסיעה: ',
      'passengerName': 'שם הנוסע: ',
      'passportNum': 'מספר דרכון: ',
      'phoneNum': 'מספר טלפון: ',
      'hotelName': 'מלון: ',
      'roomsCount': 'מספר חדרים: ',
      'nightsCount': ' | מספר לילות: ',
      'passengersCount': 'נוסעים: ',
      'vehicleType': ' | סוג רכב: ',
      'totalPrice': 'סה"כ לתשלום: ',
      'currency': ' JOD',
      'rejectionReason': 'סיבת הדחייה: ',
      'btnCancel': 'בטל הזמנה',
      'cantCancel': '⚠️ לא ניתן לבטל (פחות מ-48 שעות למועד)',
      'confirmCancelTitle': 'אישור ביטול',
      'confirmCancelBody': 'האם אתה בטוח שברצונך לבטל הזמנה זו?',
      'back': 'חזור',
      'yesCancel': 'כן, בטל',
      'notSpecified': 'לא צוין',
      'notAvailable': 'לא זמין',
      'private': 'פרטי',
    },
  };

  String _getText(String key) {
    return _localizedStrings[_selectedLanguage]?[key] ?? _localizedStrings['ar']![key]!;
  }

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.currentLanguage;
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passportController.dispose();
    _tabController?.dispose();
    super.dispose();
  }

  bool _canCancelBooking(DateTime bookingDate) {
    final now = DateTime.now();
    final difference = bookingDate.difference(now);
    return difference.inHours >= 48;
  }

  Future<void> _cancelBooking(String collectionName, String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(docId)
          .update({'status': 'cancelled'});

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_getText('cancelSuccess')), backgroundColor: Colors.green),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_getText('cancelError')), backgroundColor: Colors.red),
      );
    }
  }

  void _handleSearch() {
    final phone = _phoneController.text.trim();
    final passport = _passportController.text.trim();

    if (passport.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_getText('errEmpty')),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (phone.length != 9 || int.tryParse(phone) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_getText('errPhoneLen')),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _searchedFullPhone = '$_selectedCountryCode$phone';
      _searchedPassport = passport;
    });
  }

  TextDirection _getTextDirection() {
    return (_selectedLanguage == 'ar' || _selectedLanguage == 'he')
        ? TextDirection.rtl
        : TextDirection.ltr;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: _getTextDirection(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(_getText('title')),
          backgroundColor: const Color(0xFF1E3A8A),
          foregroundColor: Colors.white,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedLanguage,
                  dropdownColor: const Color(0xFF1E3A8A),
                  icon: const Icon(Icons.language, color: Colors.white),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  items: const [
                    DropdownMenuItem(value: 'ar', child: Text('العربية')),
                    DropdownMenuItem(value: 'en', child: Text('English')),
                    DropdownMenuItem(value: 'he', child: Text('עברית')),
                  ],
                  onChanged: (lang) {
                    if (lang != null) {
                      setState(() {
                        _selectedLanguage = lang;
                      });
                    }
                  },
                ),
              ),
            ),
          ],
        ),
        // تم استخدام SingleChildScrollView لتفعيل السكرول على الشاشة كاملة
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _passportController,
                        decoration: InputDecoration(
                          labelText: _getText('passportLabel'),
                          hintText: _getText('passportHint'),
                          border: const OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        ),
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.number,
                              maxLength: 9,
                              decoration: InputDecoration(
                                labelText: _getText('phoneLabel'),
                                hintText: '000000000',
                                counterText: '',
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedCountryCode,
                                items: _countryCodes.map((item) {
                                  return DropdownMenuItem<String>(
                                    value: item['code'],
                                    child: Text('${item['flag']} ${item['code']}'),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() {
                                      _selectedCountryCode = val;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E3A8A),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: _handleSearch,
                          icon: const Icon(Icons.search),
                          label: Text(_getText('searchBtn'), style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              if (_searchedFullPhone != null && _searchedPassport != null) ...[
                TabBar(
                  controller: _tabController,
                  labelColor: const Color(0xFF1E3A8A),
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: const Color(0xFF1E3A8A),
                  tabs: [
                    Tab(icon: const Icon(Icons.directions_car), text: _getText('tabTransport')),
                    Tab(icon: const Icon(Icons.hotel), text: _getText('tabHotel')),
                  ],
                ),
                const SizedBox(height: 12),

                // تم استخدام SizedBox بارتفاع محدد يحتوي TabBarView مع تمرير القائمة
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildBookingsList(collectionName: 'transport_bookings', isHotel: false),
                      _buildBookingsList(collectionName: 'hotel_bookings', isHotel: true),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookingsList({required String collectionName, required bool isHotel}) {
    Query query = FirebaseFirestore.instance
        .collection(collectionName)
        .where('passportNumber', isEqualTo: _searchedPassport)
        .where('userPhone', isEqualTo: _searchedFullPhone);

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(isHotel ? _getText('noBookingsHotel') : _getText('noBookingsTransport')),
          );
        }

        final docs = snapshot.data!.docs;

        int total = docs.length;
        int confirmed = docs.where((d) => (d.data() as Map<String, dynamic>)['status'] == 'confirmed').length;
        int cancelled = docs.where((d) => (d.data() as Map<String, dynamic>)['status'] == 'cancelled').length;
        int rejected = docs.where((d) => (d.data() as Map<String, dynamic>)['status'] == 'rejected').length;

        return Column(
          children: [
            Row(
              children: [
                _buildStatCard(_getText('total'), '$total', Colors.blue),
                _buildStatCard(_getText('confirmed'), '$confirmed', Colors.green),
                _buildStatCard(_getText('cancelled'), '$cancelled', Colors.orange),
                _buildStatCard(_getText('rejected'), '$rejected', Colors.red),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(), // تفعيل السكرول بداخل القائمة
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;
                  final docId = docs[index].id;

                  final dynamic dateRaw = isHotel ? (data['checkInDate'] ?? data['createdAt']) : data['travelDate'];
                  final DateTime bookingDate = dateRaw is Timestamp ? dateRaw.toDate() : DateTime.now();

                  final String status = data['status'] ?? 'pending';
                  final bool canCancel = status != 'cancelled' &&
                      status != 'rejected' &&
                      _canCancelBooking(bookingDate);

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${isHotel ? _getText('dateArrival') : _getText('dateTravel')}${bookingDate.year}-${bookingDate.month}-${bookingDate.day}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              _buildStatusBadge(status),
                            ],
                          ),
                          const Divider(),
                          Text('${_getText('passengerName')}${data['userName'] ?? _getText('notSpecified')}'),
                          Text('${_getText('passportNum')}${data['passportNumber'] ?? _getText('notAvailable')}'),
                          Text('${_getText('phoneNum')}${data['userPhone'] ?? _getText('notAvailable')}'),
                          const SizedBox(height: 4),

                          if (isHotel) ...[
                            Text('${_getText('hotelName')}${data['hotelName'] ?? _getText('notSpecified')}'),
                            Text('${_getText('roomsCount')}${data['roomsCount'] ?? 1}${_getText('nightsCount')}${data['nightsCount'] ?? 1}'),
                          ] else ...[
                            Text('${_getText('passengersCount')}${data['passengersCount'] ?? 1}${_getText('vehicleType')}${data['vehicleType'] ?? _getText('private')}'),
                          ],

                          if (data['totalPrice'] != null)
                            Text('${_getText('totalPrice')}${data['totalPrice']}${_getText('currency')}', style: const TextStyle(fontWeight: FontWeight.w600)),

                          if (status == 'rejected' && data['rejectionReason'] != null) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(8),
                              width: double.infinity,
                              color: Colors.red.shade50,
                              child: Text(
                                '${_getText('rejectionReason')}${data['rejectionReason']}',
                                style: TextStyle(color: Colors.red.shade900, fontSize: 13),
                              ),
                            ),
                          ],

                          const SizedBox(height: 10),

                          if (status != 'cancelled' && status != 'rejected')
                            Align(
                              alignment: Alignment.centerLeft,
                              child: canCancel
                                  ? OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                                onPressed: () => _confirmCancelDialog(collectionName, docId),
                                icon: const Icon(Icons.cancel, size: 18),
                                label: Text(_getText('btnCancel')),
                              )
                                  : Text(
                                _getText('cantCancel'),
                                style: const TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(String title, String count, Color color) {
    return Expanded(
      child: Card(
        color: color.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            children: [
              Text(count, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
              Text(title, style: TextStyle(fontSize: 12, color: color)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Map<String, dynamic> statusMap = {
      'pending': {'text': _getText('pending'), 'color': Colors.orange},
      'confirmed': {'text': _getText('confirmed'), 'color': Colors.green},
      'cancelled': {'text': _getText('cancelled'), 'color': Colors.grey},
      'rejected': {'text': _getText('rejected'), 'color': Colors.red},
    };
    final item = statusMap[status] ?? statusMap['pending'];
    return Chip(
      label: Text(item['text'], style: const TextStyle(color: Colors.white, fontSize: 11)),
      backgroundColor: item['color'],
    );
  }

  void _confirmCancelDialog(String collectionName, String docId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(_getText('confirmCancelTitle')),
        content: Text(_getText('confirmCancelBody')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(_getText('back'))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              _cancelBooking(collectionName, docId);
            },
            child: Text(_getText('yesCancel'), style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}