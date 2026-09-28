import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/session.dart';
import 'dart:async';

class ChatScreen extends StatefulWidget {
  final String otherUserEmail;
  final String otherUserName;

  const ChatScreen({
    super.key,
    required this.otherUserEmail,
    required this.otherUserName,
  });

  @override
  State<ChatScreen> createState() =>
      _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController =
      TextEditingController();

  final ScrollController scrollController =
      ScrollController();

  List<dynamic> messages = [];

  bool isLoading = true;
  bool isSending = false;
  Timer? chatRefreshTimer;

  @override
    void initState() {
      super.initState();

      loadMessages();

      chatRefreshTimer = Timer.periodic(
        const Duration(seconds: 5),
        (_) {
          loadMessages(
            silent: true,
          );
        },
      );
    }

  // ==================== Load Messages ====================

  Future<void> loadMessages({
    bool silent = false,
  }) async {
    try {
      final result =
        await ApiService.getChatConversation(
      otherUserEmail: widget.otherUserEmail,
    );

      if (!mounted) return;

      if (!mounted) return;

        setState(() {
          messages = result;
          isLoading = false;
        });

        if (!silent) {
          scrollToBottom();
        }

      scrollToBottom();
    } catch (e) {
      debugPrint(
        'CHAT LOAD ERROR: $e',
      );

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  // ==================== Send Message ====================

  Future<void> sendMessage() async {
    final message =
        messageController.text.trim();

    if (message.isEmpty) {
      return;
    }

    if (isSending) {
      return;
    }

    setState(() {
      isSending = true;
    });

    final result =
        await ApiService.sendChatMessage(
      receiverEmail: widget.otherUserEmail,
      message: messageController.text.trim(),
    );

    if (!mounted) return;

    if (result != null) {
      messageController.clear();

      await loadMessages();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Failed to send message.',
          ),
        ),
      );
    }

    if (!mounted) return;

    setState(() {
      isSending = false;
    });
  }

  // ==================== Scroll ====================

  void scrollToBottom() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      if (!scrollController.hasClients) {
        return;
      }

      scrollController.animateTo(
        scrollController
            .position
            .maxScrollExtent,
        duration:
            const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  // ==================== Message Bubble ====================

  Widget messageBubble(
    dynamic message,
  ) {
    final senderEmail =
        message['senderEmail']
                ?.toString() ??
            '';

    final text =
        message['message']
                ?.toString() ??
            '';

    final isMine =
        senderEmail == Session.email;

    final sentAt =
      message['sentAt']?.toString() ?? '';

    return Align(
      alignment: isMine
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        constraints:
            const BoxConstraints(
          maxWidth: 300,
        ),
        margin:
            const EdgeInsets.only(
          bottom: 10,
        ),
        padding:
            const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 11,
        ),
        decoration: BoxDecoration(
          color: isMine
              ? AppColors.primary
              : Colors.grey.shade200,
          borderRadius:
              BorderRadius.only(
            topLeft:
                const Radius.circular(18),
            topRight:
                const Radius.circular(18),
            bottomLeft:
                Radius.circular(
              isMine ? 18 : 4,
            ),
            bottomRight:
                Radius.circular(
              isMine ? 4 : 18,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: isMine
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 15,
                height: 1.3,
                color: isMine
                    ? Colors.white
                    : AppColors.textPrimary,
              ),
            ),
            if (sentAt.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                sentAt.length >= 16
                    ? sentAt.substring(11, 16)
                    : sentAt,
                style: TextStyle(
                  fontSize: 10.5,
                  color: isMine
                      ? Colors.white70
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
            
      ),
    );
  }

  // ==================== Build ====================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 19,
              backgroundColor:
                  AppColors.primary
                      .withValues(alpha: 0.1),
              child: const Icon(
                Icons.person_rounded,
                color: AppColors.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.otherUserName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? const Center(
                    child:
                        CircularProgressIndicator(),
                  )
                : messages.isEmpty
                    ? const Center(
                        child: Text(
                          'No messages yet.\nStart the conversation.',
                          textAlign:
                              TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColors
                                .textSecondary,
                          ),
                        ),
                      )
                    : ListView.builder(
                        controller:
                            scrollController,
                        padding:
                            const EdgeInsets.fromLTRB(
                          16,
                          20,
                          16,
                          10,
                        ),
                        itemCount:
                            messages.length,
                        itemBuilder:
                            (context, index) {
                          return messageBubble(
                            messages[index],
                          );
                        },
                      ),
          ),

          // ==================== Message Input ====================

          SafeArea(
            top: false,
            child: Container(
              padding:
                  const EdgeInsets.fromLTRB(
                12,
                8,
                12,
                8,
              ),
              decoration:
                  BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withValues(
                      alpha: 0.05,
                    ),
                    blurRadius: 8,
                    offset:
                        const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller:
                          messageController,
                      minLines: 1,
                      maxLines: 4,
                      textInputAction:
                          TextInputAction.newline,
                      decoration:
                          InputDecoration(
                        hintText:
                            'Type a message...',
                        filled: true,
                        fillColor:
                            Colors.grey.shade100,
                        contentPadding:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 16,
                          vertical: 11,
                        ),
                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            24,
                          ),
                          borderSide:
                              BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) {
                        sendMessage();
                      },
                    ),
                  ),

                  const SizedBox(width: 8),

                  SizedBox(
                    width: 48,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: isSending
                          ? null
                          : sendMessage,
                      style:
                          ElevatedButton.styleFrom(
                        shape:
                            const CircleBorder(),
                        padding:
                            EdgeInsets.zero,
                      ),
                      child: isSending
                          ? const SizedBox(
                              width: 19,
                              height: 19,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                                color:
                                    Colors.white,
                              ),
                            )
                          : const Icon(
                              Icons
                                  .send_rounded,
                              size: 20,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    chatRefreshTimer?.cancel();

    messageController.dispose();
    scrollController.dispose();

    super.dispose();
  }
}