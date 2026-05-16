// lib/features/chatbot/chatbot_screen.dart

import 'package:flutter/material.dart';
import '../service/chatbot_service.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<ChatMessage> _messages  = [];
  final TextEditingController _ctrl  = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  bool _isLoading = false;

  static const Color _accent = Color(0xFF6C63FF);

  @override
  void initState() {
    super.initState();
    _messages.add(ChatMessage(
      role:      'assistant',
      content:   'Halo! Aku SleepBot 🌙\nAda yang bisa aku bantu seputar kesehatan tidurmu?',
      timestamp: DateTime.now(),
    ));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _ctrl.text.trim();
    if (text.isEmpty || _isLoading) return;

    final userMsg = ChatMessage(
      role:      'user',
      content:   text,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMsg);
      _isLoading = true;
    });
    _ctrl.clear();
    _scrollToBottom();

    try {
      final reply = await ChatbotService.instance.sendMessage(_messages);
      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(
          role:      'assistant',
          content:   reply,
          timestamp: DateTime.now(),
        ));
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(
          role:      'assistant',
          content:   'Maaf, terjadi kesalahan: ${e.toString().replaceAll('Exception: ', '')}',
          timestamp: DateTime.now(),
        ));
        _isLoading = false;
      });
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: false, // ← handle manual lewat AnimatedPadding
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 18),
          color: const Color(0xFF0F172A),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _accent.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.bedtime_rounded, color: _accent, size: 18),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SleepBot',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
                Text(
                  _isLoading ? 'sedang mengetik...' : 'Asisten Kesehatan Tidur',
                  style: TextStyle(
                    fontSize: 11,
                    color: _isLoading ? _accent : const Color(0xFF94A3B8),
                    fontWeight: _isLoading ? FontWeight.w500 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
        titleSpacing: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFE2E8F0)),
        ),
      ),
      body: SafeArea(
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(bottom: bottomInset), // ← naik sesuai keyboard
          child: Column(
            children: [
              // ── Chat list ──────────────────────────────────────────────
              Expanded(
                child: ListView.builder(
                  controller: _scrollCtrl,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: _messages.length + (_isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _messages.length) {
                      return const _TypingIndicator();
                    }
                    return _ChatBubble(
                      message:     _messages[index],
                      accentColor: _accent,
                    );
                  },
                ),
              ),

              // ── Input bar ──────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: TextField(
                          controller: _ctrl,
                          maxLines: null,
                          textCapitalization: TextCapitalization.sentences,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF0F172A),
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Tanya seputar tidurmu...',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF94A3B8),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                          ),
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _sendMessage,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: _isLoading
                              ? const Color(0xFFE2E8F0)
                              : _accent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isLoading
                              ? Icons.hourglass_empty_rounded
                              : Icons.send_rounded,
                          color: _isLoading
                              ? const Color(0xFF94A3B8)
                              : Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Chat bubble ───────────────────────────────────────────────────────────────
class _ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final Color accentColor;

  const _ChatBubble({required this.message, required this.accentColor});

  bool get _isUser => message.role == 'user';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            _isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!_isUser) ...[
            Container(
              width: 30,
              height: 30,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.bedtime_rounded, color: accentColor, size: 15),
            ),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.72,
              ),
              decoration: BoxDecoration(
                color: _isUser ? accentColor : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft:     const Radius.circular(16),
                  topRight:    const Radius.circular(16),
                  bottomLeft:  Radius.circular(_isUser ? 16 : 4),
                  bottomRight: Radius.circular(_isUser ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.content,
                style: TextStyle(
                  fontSize: 13.5,
                  height: 1.55,
                  color: _isUser ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ),
          ),
          if (_isUser) const SizedBox(width: 4),
        ],
      ),
    );
  }
}

// ── Typing indicator ──────────────────────────────────────────────────────────
class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 30,
            height: 30,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF6C63FF).withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.bedtime_rounded,
              color: Color(0xFF6C63FF),
              size: 15,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft:     Radius.circular(16),
                topRight:    Radius.circular(16),
                bottomRight: Radius.circular(16),
                bottomLeft:  Radius.circular(4),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: AnimatedBuilder(
              animation: _ctrl,
              builder: (_, __) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (i) {
                    final delay   = i * 0.3;
                    final val     = ((_ctrl.value - delay) % 1.0).clamp(0.0, 1.0);
                    final opacity = val < 0.5
                        ? val / 0.5
                        : 1.0 - ((val - 0.5) / 0.5);
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(108, 99, 255, 0.3 + opacity * 0.7),
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}