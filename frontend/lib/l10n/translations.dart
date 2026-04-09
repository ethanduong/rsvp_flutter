const Map<String, Map<String, String>> _dictionary = {
  'hero_sub': {
    'en': 'WE ARE GETTING MARRIED',
    'vi': 'CHÚNG TÔI SẮP KẾT HÔN'
  },
  'month': {
    'en': 'SEPTEMBER',
    'vi': 'THÁNG CHÍN'
  },
  'gallery_text': {
    'en': 'A MATCH\nMADE IN\nHEAVEN',
    'vi': 'MỘT CẶP\nTRỜI SINH'
  },
  'process_title': {
    'en': 'THE PROCESS',
    'vi': 'LỊCH TRÌNH'
  },
  'reception_title': {
    'en': 'RECEPTION',
    'vi': 'ĐÓN KHÁCH'
  },
  'reception_desc': {
    'en': 'Gathering, drinks & snacks. Embrace the wonderful spirit.',
    'vi': 'Gặp gỡ, đồ uống & thức ăn nhẹ. Cùng hòa mình vào không khí tuyệt vời.'
  },
  'buffet_title': {
    'en': 'BUFFET',
    'vi': 'TIỆC ĐỨNG'
  },
  'buffet_desc': {
    'en': 'Join us for a lovely family dinner and warm toasts by the river.',
    'vi': 'Cùng tham gia bữa tối gia đình ấm áp và nâng ly chúc mừng.'
  },
  'ceremony_title': {
    'en': 'CEREMONY',
    'vi': 'XUẤT GIÁ'
  },
  'ceremony_desc': {
    'en': 'The time for true love words to be spoken. Promises sealed with a sweet kiss.',
    'vi': 'Khoảnh khắc trao lời yêu thương. Những lời hứa được kết phong bằng nụ hôn ngọt ngào.'
  },
  'party_title': {
    'en': 'PARTY',
    'vi': 'DẠ TIỆC'
  },
  'party_desc': {
    'en': "Let's party! DJ and cocktails awaited. Dance all the night away.",
    'vi': "Sẵn sàng quẩy! DJ và cocktail đang chờ. Cùng khiêu vũ thâu đêm."
  },
  'location_title': {
    'en': 'COORDINATES',
    'vi': 'TỌA ĐỘ'
  },
  'location_desc': {
    'en': '12:00 - 15:00 O\'CLOCK\nBERLIN, GERMANY',
    'vi': '12:00 - 15:00 GIỜ\nBERLIN, ĐỨC'
  },
  'rsvp_title': {
    'en': 'RSVP',
    'vi': 'PHÚC ĐÁP'
  },
  'rsvp_subtitle': {
    'en': 'Hurry up! RSVP below',
    'vi': 'Nhanh lên nào! Phản hồi ngay bên dưới'
  },
  'name_label': {
    'en': 'NAME *',
    'vi': 'HỌ VÀ TÊN *'
  },
  'contact_label': {
    'en': 'CONTACT (PHONE/EMAIL)',
    'vi': 'LIÊN HỆ (ĐIỆN THOẠI/EMAIL)'
  },
  'relationship_label': {
    'en': 'RELATIONSHIP *',
    'vi': 'MỐI QUAN HỆ *'
  },
  'to_label': {
    'en': 'TO',
    'vi': 'VỚI'
  },
  'side_groom': {
    'en': 'GROOM',
    'vi': 'CHÚ RỂ'
  },
  'side_bride': {
    'en': 'BRIDE',
    'vi': 'CÔ DÂU'
  },
  'side_both': {
    'en': 'BOTH',
    'vi': 'CẢ HAI'
  },
  'attendance_label': {
    'en': 'ATTENDANCE OPTIONS',
    'vi': 'LỰA CHỌN THAM DỰ'
  },
  'im_in': {
    'en': 'I\'M IN',
    'vi': 'TÔI SẼ ĐẾN'
  },
  'maybe_later': {
    'en': 'MAYBE LATER',
    'vi': 'CÓ THỂ LÚC KHÁC'
  },
  'party_size_label': {
    'en': 'TOTAL NUMBER OF GUESTS',
    'vi': 'TỔNG SỐ KHÁCH'
  },
  'confirm_btn': {
    'en': 'CONFIRM ATTENDANCE   ➝',
    'vi': 'XÁC NHẬN THAM DỰ   ➝'
  },
  'success_msg': {
    'en': 'RSVP Submitted Successfully!',
    'vi': 'Gửi phản hồi thành công!'
  },
  'error_msg': {
    'en': 'Failed to submit RSVP. Please try again.',
    'vi': 'Không thể gửi phản hồi. Vui lòng thử lại.'
  },
  'required_err': {
    'en': 'Required',
    'vi': 'Bắt buộc'
  }
};

String t(String key, String lang) {
  return _dictionary[key]?[lang] ?? key;
}
