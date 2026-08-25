import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HotelBookingScreen extends StatefulWidget {
  final String userName;
  final String userPhone;
  final String passengerType;
  final int passengersCount;
  final String currentLanguage;

  const HotelBookingScreen({
    super.key,
    required this.userName,
    required this.userPhone,
    required this.passengerType,
    required this.passengersCount,
    required this.currentLanguage,
  });

  @override
  State<HotelBookingScreen> createState() => _HotelBookingScreenState();
}

class _HotelBookingScreenState extends State<HotelBookingScreen> {
  final _formKey = GlobalKey<FormState>();

  String _selectedHotel = 'siraj_amman';
  String _roomType = 'double';
  int _roomsCount = 1;

  DateTime _checkInDate = DateTime.now().add(const Duration(days: 1));
  DateTime _checkOutDate = DateTime.now().add(const Duration(days: 2));

  final TextEditingController _notesController = TextEditingController();
  bool _isLoading = false;

  // خريطة أسعار الغرف لكل فندق (بالدينار الأردني)
  final Map<String, Map<String, int>> _hotelRoomPrices = {
    'siraj_amman': {
      'single': 55,
      'double': 65,
      'triple': 75,
      'suite': 110,
    },
    'days_inn_amman': {
      'single': 70,
      'double': 80,
      'triple': 90,
      'suite': 120,
    },
    'mena_aqaba': {
      'single': 70,
      'double': 70,
      'triple': 90,
      'suite': 130,
    },
    'ajnadin_irbid': {
      'single': 40,
      'double': 55,
      'triple': 65,
      'suite': 90,
    },
    'moab_madaba': {
      'single': 50,
      'double': 60,
      'triple': 75,
      'suite': 90,
    },
  };

  Map<String, Map<String, String>> get _localizedTexts => {
    'ar': {
      'page_title': 'حجز الفنادق والإقامة',
      'user_summary': 'بيانات المسافر:',
      'hotel_select': 'اختر الفندق / المنطقة',
      'hotel_siraj': 'فندق سراج عمان (شامل الإفطار والضريبة)',
      'hotel_days_inn': 'فندق دايز إن عمان (شامل الإفطار والعشاء + بركة سباحة والضريبة)',
      'hotel_mena_aqaba': 'فندق مينا العقبة (شامل الإفطار والضريبة + بركة سباحة)',
      'hotel_ajnadin_irbid': 'فندق أجنادين إربد (قُرب المعبر الشمالي - شامل الإفطار والضريبة)',
      'hotel_moab_madaba': 'فندق موآب مأدبا (قريب مطار الملكة علياء - شامل الإفطار والضريبة)',
      'room_type': 'نوع الغرفة',
      'room_single': 'غرفة مفردة (Single)',
      'room_double': 'غرفة مزدوجة (Double)',
      'room_triple': 'غرفة ثلاثية (3 أشخاص)',
      'room_suite': 'غرفتين وصالة (سويت)',
      'rooms_count': 'عدد الغرف',
      'check_in': 'تاريخ الوصول (Check-in)',
      'check_out': 'تاريخ المغادرة (Check-out)',
      'notes_label': 'طلبات إضافية (اختياري)',
      'notes_hint': 'مثال: أسرة إضافية، طابق علوي...',
      'price_summary': 'ملخص التكلفة الإجمالية',
      'nights_count': 'عدد الليالي:',
      'night_price': 'سعر الغرفة/ليلة:',
      'total_cost': 'المجموع الكلي:',
      'jod': 'دينار أردني',
      'btn_confirm': 'تأكيد وحفظ حجز الفندق',
      'success_msg': 'تم حفظ حجز الفندق بنجاح!',
      'error_msg': 'حدث خطأ أثناء حفظ الحجز، يرجى المحاولة لاحقاً.',
      'date_error': 'تاريخ المغادرة يجب أن يكون بعد تاريخ الوصول',
    },
    'en': {
      'page_title': 'Hotel & Accommodation Booking',
      'user_summary': 'Passenger Details:',
      'hotel_select': 'Select Hotel / Area',
      'hotel_siraj': 'Siraj Amman Hotel (Breakfast & Tax Included)',
      'hotel_days_inn': 'Days Inn Hotel Amman (Half Board: Breakfast & Dinner + Pool Included)',
      'hotel_mena_aqaba': 'Mena Hotel Aqaba (Pool, Breakfast & Tax Included)',
      'hotel_ajnadin_irbid': 'Ajnadin Hotel Irbid (Near Border - Breakfast & Tax Included)',
      'hotel_moab_madaba': 'Moab Hotel Madaba (Near Airport - Breakfast & Tax Included)',
      'room_type': 'Room Type',
      'room_single': 'Single Room',
      'room_double': 'Double Room',
      'room_triple': 'Triple Room (3 Persons)',
      'room_suite': '2 Bedrooms & Living Room (Suite)',
      'rooms_count': 'Number of Rooms',
      'check_in': 'Check-in Date',
      'check_out': 'Check-out Date',
      'notes_label': 'Special Requests (Optional)',
      'notes_hint': 'e.g. Extra beds, high floor...',
      'price_summary': 'Price Summary',
      'nights_count': 'Nights Count:',
      'night_price': 'Room Rate / Night:',
      'total_cost': 'Total Price:',
      'jod': 'JOD',
      'btn_confirm': 'Confirm & Save Hotel Booking',
      'success_msg': 'Hotel booking saved successfully!',
      'error_msg': 'An error occurred, please try again.',
      'date_error': 'Check-out date must be after check-in date',
    },
    'he': {
      'page_title': 'הזמנת מלונות ואירוח',
      'user_summary': 'פרטי הנוסע:',
      'hotel_select': 'בחר מלון / אזור',
      'hotel_siraj': 'מלון סיראג\' עמאן (כולל ארוחת בוקר ומע"מ)',
      'hotel_days_inn': 'מלון דייז אין עמאן (כולל ארוחת בוקר, ערב ובריכה)',
      'hotel_mena_aqaba': 'מלון מנה עקבה (כולל בריכה, ארוחת בוקר ומע"מ)',
      'hotel_ajnadin_irbid': 'מלון אג\'נאדין אירביד (ליד המעבר הצפוני)',
      'hotel_moab_madaba': 'מלון מואב מדבא (קרוב לנמל התעופה)',
      'room_type': 'סוג חדר',
      'room_single': 'חדר יחיד',
      'room_double': 'חדר זוגי',
      'room_triple': 'חדר שלשה (3 אנשים)',
      'room_suite': 'סוויטה (2 חדרים וסלון)',
      'rooms_count': 'מספר חדרים',
      'check_in': 'תאריך כניסה',
      'check_out': 'תאריך יציאה',
      'notes_label': 'בקשות מיוחדות (רשות)',
      'notes_hint': 'לדוגמה: מיטות נוספות, קומה גבוהה...',
      'price_summary': 'סיכום עלויות',
      'nights_count': 'מספר לילות:',
      'night_price': 'מחיר ללילה:',
      'total_cost': 'סה"כ לתשלום:',
      'jod': 'דינר',
      'btn_confirm': 'אישור ושמירת הזמנת המלון',
      'success_msg': 'הזמנת המלון שנשמרה בהצלחה!',
      'error_msg': 'אירעה שגיאה, נסה שוב מאוחר יותר.',
      'date_error': 'תאריך היציאה חייב להיות אחרי תאריך הכניסה',
    },
  };

  String _t(String key) => _localizedTexts[widget.currentLanguage]?[key] ?? key;

  int get _currentRoomPrice {
    return _hotelRoomPrices[_selectedHotel]?[_roomType] ?? 50;
  }

  int get _nightsCount {
    final checkIn = DateTime(_checkInDate.year, _checkInDate.month, _checkInDate.day);
    final checkOut = DateTime(_checkOutDate.year, _checkOutDate.month, _checkOutDate.day);

    final difference = checkOut.difference(checkIn).inDays;
    return difference > 0 ? difference : 1;
  }

  int get _totalPrice {
    return _currentRoomPrice * _roomsCount * _nightsCount;
  }

  Future<void> _pickCheckInDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _checkInDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null) {
      setState(() {
        _checkInDate = picked;
        if (_checkOutDate.isBefore(_checkInDate) || _checkOutDate.isAtSameMomentAs(_checkInDate)) {
          _checkOutDate = _checkInDate.add(const Duration(days: 1));
        }
      });
    }
  }

  Future<void> _pickCheckOutDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _checkOutDate,
      firstDate: _checkInDate.add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null) {
      setState(() {
        _checkOutDate = picked;
      });
    }
  }

  Future<void> _submitBooking() async {
    if (_formKey.currentState!.validate()) {
      if (!_checkOutDate.isAfter(_checkInDate)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_t('date_error')), backgroundColor: Colors.orange),
        );
        return;
      }

      setState(() => _isLoading = true);

      try {
        await FirebaseFirestore.instance.collection('hotel_bookings').add({
          'userName': widget.userName,
          'userPhone': widget.userPhone,
          'passengerType': widget.passengerType,
          'passengersCount': widget.passengersCount,
          'hotelName': _selectedHotel,
          'roomType': _roomType,
          'roomsCount': _roomsCount,
          'checkInDate': Timestamp.fromDate(_checkInDate),
          'checkOutDate': Timestamp.fromDate(_checkOutDate),
          'nightsCount': _nightsCount,
          'roomPricePerNight': _currentRoomPrice,
          'totalPrice': _totalPrice,
          'notes': _notesController.text.trim(),
          'status': 'pending',
          'createdAt': FieldValue.serverTimestamp(),
        });

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_t('success_msg')), backgroundColor: Colors.green),
        );

        Navigator.pop(context);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_t('error_msg')), backgroundColor: Colors.red),
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: widget.currentLanguage == 'he' || widget.currentLanguage == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF1E3A8A),
          foregroundColor: Colors.white,
          title: Text(_t('page_title'), style: const TextStyle(fontSize: 18)),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // بيانات المسافر
                  Card(
                    color: Colors.blue.shade50,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_t('user_summary'), style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A))),
                          const SizedBox(height: 6),
                          Text('👤 ${widget.userName} | 📞 ${widget.userPhone}'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // اختيار الفندق
                  Text(_t('hotel_select'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E3A8A))),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedHotel,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                    items: [
                      DropdownMenuItem(value: 'siraj_amman', child: Text(_t('hotel_siraj'))),
                      DropdownMenuItem(value: 'days_inn_amman', child: Text(_t('hotel_days_inn'))),
                      DropdownMenuItem(value: 'mena_aqaba', child: Text(_t('hotel_mena_aqaba'))),
                      DropdownMenuItem(value: 'ajnadin_irbid', child: Text(_t('hotel_ajnadin_irbid'))),
                      DropdownMenuItem(value: 'moab_madaba', child: Text(_t('hotel_moab_madaba'))),
                    ],
                    onChanged: (val) {
                      setState(() {
                        _selectedHotel = val!;
                      });
                    },
                  ),
                  const SizedBox(height: 18),

                  // نوع الغرفة
                  Text(_t('room_type'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E3A8A))),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _roomType,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'single',
                        child: Text('${_t('room_single')} - (${_hotelRoomPrices[_selectedHotel]?['single']} ${_t('jod')})'),
                      ),
                      DropdownMenuItem(
                        value: 'double',
                        child: Text('${_t('room_double')} - (${_hotelRoomPrices[_selectedHotel]?['double']} ${_t('jod')})'),
                      ),
                      DropdownMenuItem(
                        value: 'triple',
                        child: Text('${_t('room_triple')} - (${_hotelRoomPrices[_selectedHotel]?['triple']} ${_t('jod')})'),
                      ),
                      DropdownMenuItem(
                        value: 'suite',
                        child: Text('${_t('room_suite')} - (${_hotelRoomPrices[_selectedHotel]?['suite']} ${_t('jod')})'),
                      ),
                    ],
                    onChanged: (val) => setState(() => _roomType = val!),
                  ),
                  const SizedBox(height: 18),

                  // عدد الغرف
                  Text(_t('rooms_count'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E3A8A))),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _roomsCount > 1 ? () => setState(() => _roomsCount--) : null,
                        icon: const Icon(Icons.remove_circle_outline, color: Color(0xFF1E3A8A)),
                      ),
                      Text('$_roomsCount', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(
                        onPressed: () => setState(() => _roomsCount++),
                        icon: const Icon(Icons.add_circle_outline, color: Color(0xFF1E3A8A)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // تواريخ الوصول والمغادرة
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_t('check_in'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E3A8A))),
                            const SizedBox(height: 6),
                            InkWell(
                              onTap: _pickCheckInDate,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                                decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(4)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${_checkInDate.year}-${_checkInDate.month}-${_checkInDate.day}', style: const TextStyle(fontSize: 13)),
                                    const Icon(Icons.calendar_today, size: 16, color: Color(0xFF1E3A8A)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_t('check_out'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E3A8A))),
                            const SizedBox(height: 6),
                            InkWell(
                              onTap: _pickCheckOutDate,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                                decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(4)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${_checkOutDate.year}-${_checkOutDate.month}-${_checkOutDate.day}', style: const TextStyle(fontSize: 13)),
                                    const Icon(Icons.calendar_today, size: 16, color: Color(0xFF1E3A8A)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // ملاحظات إضافية
                  Text(_t('notes_label'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E3A8A))),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: _t('notes_hint'),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ملخص الحساب
                  Card(
                    color: Colors.amber.shade50,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.amber.shade400, width: 1.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_t('price_summary'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A))),
                          const Divider(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_t('nights_count')),
                              Text('$_nightsCount', style: const TextStyle(fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_t('night_price')),
                              Text('$_currentRoomPrice ${_t('jod')}', style: const TextStyle(fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const Divider(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_t('total_cost'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                              Text('$_totalPrice ${_t('jod')}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // زر الحفظ
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: _isLoading ? null : _submitBooking,
                      icon: _isLoading
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Icon(Icons.hotel_class_outlined, size: 20),
                      label: Text(
                        _isLoading ? 'جاري الحفظ...' : _t('btn_confirm'),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
}