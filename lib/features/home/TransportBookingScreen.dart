import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransportBookingScreen extends StatefulWidget {
  final String userName;
  final String userPhone;
  final String passengerType;
  final int passengersCount;
  final String currentLanguage;

  const TransportBookingScreen({
    super.key,
    required this.userName,
    required this.userPhone,
    required this.passengerType,
    required this.passengersCount,
    required this.currentLanguage,
  });

  @override
  State<TransportBookingScreen> createState() => _TransportBookingScreenState();
}

class _TransportBookingScreenState extends State<TransportBookingScreen> {
  final _formKey = GlobalKey<FormState>();

  String _selectedVehicle = 'private_car';
  String? _selectedDirection = 'border_to_amman_deadsea';
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  final TextEditingController _notesController = TextEditingController();

  bool _isLoading = false;

  // ثابت سعر المندوب والتأشيرة لكل شخص
  static const int visaAndEscortFeePerPerson = 45;

  // قائمة أسعار السيارات الخاصة (حتى 4 أشخاص)
  final Map<String, int> _carPrices = {
    'border_to_amman_deadsea': 50,
    'border_to_airport': 60,
    'border_to_aqaba': 150,
    'airport_to_border': 60,
    'amman_deadsea_to_border': 50,
    'aqaba_to_border': 150,
  };

  // قائمة أسعار الفان (حتى 10 أشخاص)
  final Map<String, int> _vanPrices = {
    'border_to_amman_deadsea': 120,
    'border_to_airport': 120,
    'border_to_aqaba': 200,
    'airport_to_border': 120,
    'amman_deadsea_to_border': 120,
    'aqaba_to_border': 200,
  };

  Map<String, Map<String, String>> get _localizedTexts => {
    'ar': {
      'page_title': 'حجز النقل والتأشيرة والمندوب VIP',
      'user_summary': 'بيانات المسافر:',
      'passengers_count': 'عدد المسافرين:',
      'mandatory_fee_notice': 'ملاحظة: خدمة المندوب VIP وتأشيرة الدخول إجبارية ($visaAndEscortFeePerPerson دينار/شخص)',
      'vehicle_type': 'وسيلة النقل',
      'private_car': 'سيارة خاصة (حتى 4 أشخاص)',
      'van_10': 'فان (حتى 10 أشخاص)',
      'none_vehicle': 'بدون وسيلة نقل',
      'direction': 'اتجاه الرحلة',
      'dir_border_to_amman_deadsea': 'من المعبر ⬅ إلى عمان / البحر الميت',
      'dir_border_to_airport': 'من المعبر ⬅ إلى مطار الملكة علياء',
      'dir_border_to_aqaba': 'من المعبر ⬅ إلى العقبة',
      'dir_airport_to_border': 'من مطار الملكة علياء ⬅ إلى المعبر',
      'dir_amman_deadsea_to_border': 'من عمان / البحر الميت ⬅ إلى المعبر',
      'dir_aqaba_to_border': 'من العقبة ⬅ إلى المعبر',
      'travel_date': 'تاريخ السفر / العبور',
      'notes_label': 'ملاحظات إضافية (اختياري)',
      'notes_hint': 'مثال: موعد الوصول، رقم الرحلة، عدد الحقائب...',
      'price_summary': 'ملخص التكلفة الإجمالية',
      'escort_visa_cost': 'المندوب VIP والتاشيرة ($visaAndEscortFeePerPerson × ${widget.passengersCount}):',
      'transport_cost': 'تكلفة النقل:',
      'free_drink': '🍹 مشمول: مشروب بارد مجاناً مع النقل',
      'total_cost': 'المجموع الكلي:',
      'jod': 'د.أ',
      'jod_full': 'دينار أردني',
      'btn_confirm': 'تأكيد وحفظ الحجز',
      'success_msg': 'تم حفظ الحجز بنجاح!',
      'error_msg': 'حدث خطأ أثناء حفظ البيانات، يرجى المحاولة لاحقاً.',
    },
    'en': {
      'page_title': 'Transport, Visa & VIP Escort Booking',
      'user_summary': 'Passenger Details:',
      'passengers_count': 'Passengers Count:',
      'mandatory_fee_notice': 'Note: VIP Escort & Entry Visa are mandatory ($visaAndEscortFeePerPerson JOD/person)',
      'vehicle_type': 'Vehicle Type',
      'private_car': 'Private Car (Up to 4 persons)',
      'van_10': 'Van (Up to 10 persons)',
      'none_vehicle': 'No Transport Required',
      'direction': 'Trip Direction',
      'dir_border_to_amman_deadsea': 'From Border ⬅ To Amman / Dead Sea',
      'dir_border_to_airport': 'From Border ⬅ To Queen Alia Airport',
      'dir_border_to_aqaba': 'From Border ⬅ To Aqaba',
      'dir_airport_to_border': 'From Queen Alia Airport ⬅ To Border',
      'dir_amman_deadsea_to_border': 'From Amman / Dead Sea ⬅ To Border',
      'dir_aqaba_to_border': 'From Aqaba ⬅ To Border',
      'travel_date': 'Travel Date',
      'notes_label': 'Additional Notes (Optional)',
      'notes_hint': 'e.g. Arrival time, flight number, luggage count...',
      'price_summary': 'Price Breakdown',
      'escort_visa_cost': 'VIP Escort & Visa ($visaAndEscortFeePerPerson × ${widget.passengersCount}):',
      'transport_cost': 'Transport Fee:',
      'free_drink': '🍹 Included: Complimentary Cold Drink with Transport',
      'total_cost': 'Total Price:',
      'jod': 'JOD',
      'jod_full': 'JOD',
      'btn_confirm': 'Confirm & Save Booking',
      'success_msg': 'Booking saved successfully!',
      'error_msg': 'An error occurred while saving, please try again.',
    },
    'he': {
      'page_title': 'הזמנת הסעות, ויזה ונציג מלווה VIP',
      'user_summary': 'פרטי הנוסע:',
      'passengers_count': 'מספר נוסעים:',
      'mandatory_fee_notice': 'הערה: נציג מלווה VIP וויזת כניסה הם חובה ($visaAndEscortFeePerPerson דינר לנוסע)',
      'vehicle_type': 'סוג רכב',
      'private_car': 'רכב פרטי (עד 4 נוסעים)',
      'van_10': 'ואן (עד 10 נוסעים)',
      'none_vehicle': 'ללא הסעה',
      'direction': 'כיוון הנסיעה',
      'dir_border_to_amman_deadsea': 'מהמעבר ⬅ לעמאן / ים המלח',
      'dir_border_to_airport': 'מהמעבר ⬅ לנמל התעופה קווין עליאה',
      'dir_border_to_aqaba': 'מהמעבר ⬅ לעקבה',
      'dir_airport_to_border': 'מנמל התעופה קווין עליאה ⬅ למעבר',
      'dir_amman_deadsea_to_border': 'מעמאן / ים המלח ⬅ למעבר',
      'dir_aqaba_to_border': 'מעקבה ⬅ למעבר',
      'travel_date': 'תאריך נסיעה',
      'notes_label': 'הערות נוספות (רשות)',
      'notes_hint': 'לדוגמה: שעת הגעה, מספר טיסה, מספר מזוודות...',
      'price_summary': 'סיכום עלויות',
      'escort_visa_cost': 'נציג מלווה VIP וויזה ($visaAndEscortFeePerPerson × ${widget.passengersCount}):',
      'transport_cost': 'עלות הסעה:',
      'free_drink': '🍹 כולל: שתייה קרה חינם עם ההסעה',
      'total_cost': 'סה"כ לתשלום:',
      'jod': 'דינר',
      'jod_full': 'דינר',
      'btn_confirm': 'אישור ושמירת הזמנה',
      'success_msg': 'ההזמנה נשמרה בהצלחה!',
      'error_msg': 'אירעה שגיאה בשמירת הנתונים, נסה שוב מאוחר יותר.',
    },
  };

  String _t(String key) => _localizedTexts[widget.currentLanguage]?[key] ?? key;

  int _getDirectionPrice(String dirKey) {
    if (_selectedVehicle == 'van_10') {
      return _vanPrices[dirKey] ?? 0;
    } else if (_selectedVehicle == 'private_car') {
      return _carPrices[dirKey] ?? 0;
    }
    return 0;
  }

  int get _visaAndEscortCost => widget.passengersCount * visaAndEscortFeePerPerson;

  int get _transportCost {
    if (_selectedVehicle == 'none' || _selectedDirection == null) {
      return 0;
    }
    return _getDirectionPrice(_selectedDirection!);
  }

  int get _totalPrice => _visaAndEscortCost + _transportCost;

  List<Map<String, String>> get _directionsList => [
    {'key': 'border_to_amman_deadsea', 'text': _t('dir_border_to_amman_deadsea')},
    {'key': 'border_to_airport', 'text': _t('dir_border_to_airport')},
    {'key': 'border_to_aqaba', 'text': _t('dir_border_to_aqaba')},
    {'key': 'airport_to_border', 'text': _t('dir_airport_to_border')},
    {'key': 'amman_deadsea_to_border', 'text': _t('dir_amman_deadsea_to_border')},
    {'key': 'aqaba_to_border', 'text': _t('dir_aqaba_to_border')},
  ];

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitBooking() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        await FirebaseFirestore.instance.collection('transport_bookings').add({
          'userName': widget.userName,
          'userPhone': widget.userPhone,
          'passengerType': widget.passengerType,
          'passengersCount': widget.passengersCount,
          'vehicleType': _selectedVehicle,
          'direction': _selectedVehicle == 'none' ? null : _selectedDirection,
          'visaAndEscortFee': _visaAndEscortCost,
          'transportFee': _transportCost,
          'totalPrice': _totalPrice,
          'travelDate': Timestamp.fromDate(_selectedDate),
          'notes': _notesController.text.trim(),
          'status': 'pending',
          'createdAt': FieldValue.serverTimestamp(),
        });

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_t('success_msg')),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_t('error_msg')),
            backgroundColor: Colors.red,
          ),
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
                          Text('👥 ${_t('passengers_count')} ${widget.passengersCount}'),
                          const Divider(height: 16),
                          Text(
                            _t('mandatory_fee_notice'),
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.indigo),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text(_t('vehicle_type'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E3A8A))),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedVehicle,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'private_car',
                        child: Text(_t('private_car'), overflow: TextOverflow.ellipsis),
                      ),
                      DropdownMenuItem(
                        value: 'van_10',
                        child: Text(_t('van_10'), overflow: TextOverflow.ellipsis),
                      ),
                      DropdownMenuItem(
                        value: 'none',
                        child: Text(_t('none_vehicle'), overflow: TextOverflow.ellipsis),
                      ),
                    ],
                    onChanged: (val) {
                      setState(() {
                        _selectedVehicle = val!;
                        if (_selectedVehicle == 'none') {
                          _selectedDirection = null;
                        } else if (_selectedDirection == null) {
                          _selectedDirection = 'border_to_amman_deadsea';
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 18),

                  Text(_t('direction'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E3A8A))),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedDirection,
                    isExpanded: true,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      filled: _selectedVehicle == 'none',
                      fillColor: Colors.grey.shade200,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                    items: _selectedVehicle == 'none'
                        ? null
                        : _directionsList.map((dir) {
                      final price = _getDirectionPrice(dir['key']!);
                      return DropdownMenuItem<String>(
                        value: dir['key'],
                        child: Text(
                          '${dir['text']} ($price ${_t('jod')})',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(fontSize: 13),
                        ),
                      );
                    }).toList(),
                    selectedItemBuilder: _selectedVehicle == 'none'
                        ? null
                        : (BuildContext context) {
                      return _directionsList.map((dir) {
                        final price = _getDirectionPrice(dir['key']!);
                        return Text(
                          '${dir['text']} ($price ${_t('jod')})',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        );
                      }).toList();
                    },
                    onChanged: _selectedVehicle == 'none'
                        ? null
                        : (val) => setState(() => _selectedDirection = val),
                  ),
                  const SizedBox(height: 18),

                  Text(_t('travel_date'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E3A8A))),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _pickDate,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}', style: const TextStyle(fontSize: 15)),
                          const Icon(Icons.calendar_today, color: Color(0xFF1E3A8A)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  Text(_t('notes_label'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E3A8A))),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: _t('notes_hint'),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),

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
                          Text(
                            _t('price_summary'),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A)),
                          ),
                          const Divider(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_t('escort_visa_cost')),
                              Text('$_visaAndEscortCost ${_t('jod_full')}', style: const TextStyle(fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_t('transport_cost')),
                              Text('$_transportCost ${_t('jod_full')}', style: const TextStyle(fontWeight: FontWeight.w600)),
                            ],
                          ),
                          if (_selectedVehicle != 'none') ...[
                            const SizedBox(height: 6),
                            Text(
                              _t('free_drink'),
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.blueGrey),
                            ),
                          ],
                          const Divider(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _t('total_cost'),
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                              ),
                              Text(
                                '$_totalPrice ${_t('jod_full')}',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

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
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                          : const Icon(Icons.check_circle_outline, size: 20),
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