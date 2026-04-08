import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import '../services/api_service.dart';
import '../l10n/translations.dart';
import '../main.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = RsvpService();
  final ScrollController _scrollController = ScrollController();

  String _name = '';
  String _email = '';
  String _attendance = 'attending';
  int _partySize = 1;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    ui_web.platformViewRegistry.registerViewFactory(
      'gmap-embed',
      (int viewId) => html.IFrameElement()
        ..style.border = 'none'
        ..style.height = '100%'
        ..style.width = '100%'
        ..src = 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d155458.12563345156!2d13.25055209731454!3d52.50650997184282!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x47a84e373f035901%3A0x42120465b5e3b70!2sBerlin%2C%20Germany!5e0!3m2!1sen!2sus!4v1712610582845!5m2!1sen!2sus',
    );
  }

  Future<void> _submitRsvp() async {
    final lang = ref.read(languageProvider);
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _isSubmitting = true);

    final success = await _apiService.submitRsvp({
      'guestName': _name,
      'message': 'Email: $_email',
      'attendance': _attendance,
      'partySize': _partySize,
      'side': 'groom',
    });

    setState(() => _isSubmitting = false);

    if (success) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t('success_msg', lang))),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t('error_msg', lang))),
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  final Color pastelGreen = const Color(0xFFB1C4B5);
  final Color pastelPink = const Color(0xFFF1B7B5);
  final Color pastelPurple = const Color(0xFFC0AEE0);
  final Color bgOffWhite = const Color(0xFFFAF7F6);
  final Color textDark = const Color(0xFF2E2E2E);

  @override
  Widget build(BuildContext context) {
    // Watch language
    final lang = ref.watch(languageProvider);

    return Scaffold(
      backgroundColor: bgOffWhite,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildNavHeader(lang),
            _buildHeroSection(lang),
            _buildGallerySection(lang),
            _buildProcessSection(lang),
            _buildCoordinatesSection(lang),
            _buildRsvpSection(lang),
            _buildFooter(lang),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageToggle(String lang) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => ref.read(languageProvider.notifier).state = 'en',
          child: Text(
            "EN",
            style: TextStyle(
              fontWeight: lang == 'en' ? FontWeight.bold : FontWeight.w300,
              color: lang == 'en' ? pastelPink : Colors.grey[500],
            ),
          ),
        ),
        const Text(" | ", style: TextStyle(color: Colors.grey)),
        GestureDetector(
          onTap: () => ref.read(languageProvider.notifier).state = 'vi',
          child: Text(
            "VI",
            style: TextStyle(
              fontWeight: lang == 'vi' ? FontWeight.bold : FontWeight.w300,
              color: lang == 'vi' ? pastelGreen : Colors.grey[500],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavHeader(String lang) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "ALICE      JACK",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
              color: textDark,
            ),
          ),
          Row(
            children: [
              _buildLanguageToggle(lang),
              const SizedBox(width: 24),
              Icon(Icons.menu, color: textDark),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildHeroSection(String lang) {
    return SizedBox(
      height: 480,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 40,
            left: -50,
            child: Container(width: 180, height: 180, color: pastelGreen),
          ),
          Positioned(
            top: -20,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(color: pastelPink, shape: BoxShape.circle),
            ),
          ),
          Positioned(
            bottom: 60,
            left: 32,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t('hero_sub', lang),
                  style: const TextStyle(
                    color: Color(0xFFDD7D6A),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 4.0,
                  ),
                ),
                const SizedBox(height: 8),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: -10,
                      left: 100,
                      child: CustomPaint(
                        size: const Size(60, 60),
                        painter: TrianglePainter(color: pastelPurple),
                      ),
                    ),
                    Text(
                      "ALICE\n& JACK",
                      style: TextStyle(
                        fontSize: 68,
                        height: 0.9,
                        letterSpacing: -2,
                        fontWeight: FontWeight.w900,
                        color: textDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "08",
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w800,
                        height: 0.8,
                        color: pastelGreen,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t('month', lang),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2.0,
                            color: textDark,
                          ),
                        ),
                        Text(
                          "2024",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGallerySection(String lang) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: _ScrollLinkedSlide(
                scrollController: _scrollController,
                slideDistance: 200,
                slideFromLeft: true,
                child: Image.asset(
                  'assets/images/gallery-1.jpg',
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(height: 180, color: Colors.grey[400]),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: 180,
                color: pastelPink,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.centerRight,
                child: Text(
                  t('gallery_text', lang),
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 8, letterSpacing: 2, height: 1.5),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(height: 280, color: pastelPurple),
            ),
            Expanded(
              flex: 2,
              child: _ScrollLinkedSlide(
                scrollController: _scrollController,
                slideDistance: 200,
                slideFromLeft: false,
                child: Image.asset(
                  'assets/images/gallery-2.jpg',
                  height: 280,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(height: 280, color: Colors.grey[600]),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProcessSection(String lang) {
    final processes = [
      {'time': "15:00", 'title': t('reception_title', lang), 'desc': t('reception_desc', lang), 'color': pastelPink},
      {'time': "18:00", 'title': t('buffet_title', lang), 'desc': t('buffet_desc', lang), 'color': pastelGreen},
      {'time': "19:00", 'title': t('ceremony_title', lang), 'desc': t('ceremony_desc', lang), 'color': pastelPurple},
      {'time': "21:00", 'title': t('party_title', lang), 'desc': t('party_desc', lang), 'color': pastelPink},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 4, height: 28, color: pastelGreen),
              const SizedBox(width: 16),
              Text(
                t('process_title', lang),
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                  color: textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 48),
          Stack(
            children: [
              Positioned(
                left: 10,
                top: 0,
                bottom: 0,
                child: Container(width: 1, color: Colors.grey[300]),
              ),
              Column(
                children: processes.map((proc) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(top: 6, left: 6, right: 26),
                          color: proc['color'] as Color,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (proc['time'] as String).toUpperCase(),
                                style: TextStyle(fontSize: 10, letterSpacing: 2, color: Colors.grey[500]),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                proc['title'] as String,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: textDark,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                proc['desc'] as String,
                                style: TextStyle(fontSize: 12, height: 1.5, color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCoordinatesSection(String lang) {
    return Container(
      color: const Color(0xFFF5EFEF),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t('location_title', lang),
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
              color: textDark,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            t('location_desc', lang),
            style: const TextStyle(
              color: Color(0xFFDE7C70),
              fontSize: 12,
              letterSpacing: 4.0,
              fontWeight: FontWeight.w600,
              height: 1.8,
            ),
          ),
          const SizedBox(height: 40),
          Container(
            width: double.infinity,
            height: 350,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300, width: 8),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, 10))
              ],
            ),
            child: const HtmlElementView(viewType: 'gmap-embed'),
          )
        ],
      ),
    );
  }

  Widget _buildRsvpSection(String lang) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 80),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t('rsvp_title', lang),
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w900,
                letterSpacing: -1.0,
                color: textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              t('rsvp_subtitle', lang),
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 2.0,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 48),

            TextFormField(
              decoration: InputDecoration(
                labelText: t('name_label', lang),
                labelStyle: const TextStyle(fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.bold),
              ),
              validator: (v) => v!.isEmpty ? t('required_err', lang) : null,
              onSaved: (v) => _name = v!,
            ),
            const SizedBox(height: 24),

            TextFormField(
              decoration: InputDecoration(
                labelText: t('email_label', lang),
                labelStyle: const TextStyle(fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.bold),
              ),
              onSaved: (v) => _email = v ?? '',
            ),
            const SizedBox(height: 40),

            Text(
              t('attendance_label', lang),
              style: const TextStyle(fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => setState(() => _attendance = 'attending'),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(
                        color: _attendance == 'attending' ? Colors.black : Colors.grey[300]!,
                      ),
                    ),
                    child: Text(
                      t('im_in', lang),
                      style: TextStyle(
                        color: _attendance == 'attending' ? textDark : Colors.grey,
                        letterSpacing: 2,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextButton(
                    onPressed: () => setState(() => _attendance = 'declined'),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(
                        color: _attendance == 'declined' ? Colors.black : Colors.grey[300]!,
                      ),
                    ),
                    child: Text(
                      t('maybe_later', lang),
                      style: TextStyle(
                        color: _attendance == 'declined' ? textDark : Colors.grey,
                        letterSpacing: 2,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            DropdownButtonFormField<int>(
              value: _partySize,
              decoration: InputDecoration(
                labelText: t('party_size_label', lang),
                labelStyle: const TextStyle(fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.bold),
              ),
              items: List.generate(10, (index) {
                return DropdownMenuItem(
                  value: index,
                  child: Text(index.toString(), style: const TextStyle(fontSize: 12)),
                );
              }),
              onChanged: (val) => setState(() => _partySize = val!),
            ),
            const SizedBox(height: 60),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitRsvp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDA8A81),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  elevation: 0,
                ),
                child: _isSubmitting
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text(
                        t('confirm_btn', lang),
                        style: const TextStyle(letterSpacing: 2, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(String lang) {
    return Container(
      color: textDark, // dark grey
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "A+J",
            style: TextStyle(
              color: Colors.white24,
              fontSize: 32,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Text(
            "2024",
            style: TextStyle(
              color: Colors.white24,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 32),
          _buildLanguageToggle(lang),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 16, height: 16, color: pastelPink),
              const SizedBox(width: 8),
              Container(width: 16, height: 16, color: pastelGreen),
              const SizedBox(width: 8),
              Container(width: 16, height: 16, color: pastelPurple),
            ],
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}

class _ScrollLinkedSlide extends StatelessWidget {
  final Widget child;
  final ScrollController scrollController;
  final double slideDistance;
  final bool slideFromLeft;

  const _ScrollLinkedSlide({
    super.key,
    required this.child,
    required this.scrollController,
    required this.slideDistance,
    this.slideFromLeft = true,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scrollController,
      builder: (context, childWidget) {
        double offset = 0;
        final renderObject = context.findRenderObject();
        
        if (renderObject is RenderBox && renderObject.hasSize) {
          try {
            final positionY = renderObject.localToGlobal(Offset.zero).dy;
            final height = renderObject.size.height;
            final screenHeight = MediaQuery.of(context).size.height;
            
            double clamped = 0.0;

            if (positionY >= screenHeight) {
              clamped = 1.0;
            } else if (positionY > screenHeight - height) {
              clamped = (positionY - (screenHeight - height)) / height;
            } else if (positionY <= -height) {
              clamped = 1.0;
            } else if (positionY < 0) {
              clamped = -positionY / height;
            } else {
              clamped = 0.0;
            }
            
            final multiplier = slideFromLeft ? -1.0 : 1.0;
            offset = clamped * slideDistance * multiplier;
          } catch (e) {
            // ignore
          }
        }
        
        return Transform.translate(
          offset: Offset(offset, 0),
          child: childWidget,
        );
      },
      child: child,
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
      
    final path = Path();
    path.moveTo(size.width / 2, 0); 
    path.lineTo(size.width, size.height); 
    path.lineTo(0, size.height); 
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
