import 'package:chat_rooms/core/consts/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LivelyActionButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final String tooltip;
  final Color backgroundColor;
  final Color? borderColor;

  const LivelyActionButton({
    super.key,
    required this.child,
    required this.onPressed,
    required this.tooltip,
    required this.backgroundColor,
    this.borderColor,
  });

  @override
  State<LivelyActionButton> createState() => _LivelyActionButtonState();
}

class _LivelyActionButtonState extends State<LivelyActionButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    return Tooltip(
      message: widget.tooltip,
      child: GestureDetector(
        onTapDown: enabled ? (_) => setState(() => _isPressed = true) : null,
        onTapUp: enabled ? (_) => setState(() => _isPressed = false) : null,
        onTapCancel: enabled ? () => setState(() => _isPressed = false) : null,
        onTap: enabled
            ? () {
                HapticFeedback.lightImpact();
                widget.onPressed!();
              }
            : null,
        child: AnimatedScale(
          scale: _isPressed ? 0.86 : 1.0,
          duration: const Duration(milliseconds: 130),
          curve: Curves.easeOutBack,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: 36.r,
            height: 36.r,
            decoration: BoxDecoration(
              color: enabled
                  ? widget.backgroundColor
                  : widget.backgroundColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color:
                    widget.borderColor ??
                    Colors.white.withValues(alpha: enabled ? 0.28 : 0.12),
                width: 1,
              ),
              boxShadow: _isPressed
                  ? []
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Center(child: widget.child),
          ),
        ),
      ),
    );
  }
}

class LivelySendButton extends StatefulWidget {
  final VoidCallback onPressed;

  const LivelySendButton({
    super.key,
    required this.onPressed,
  });

  @override
  State<LivelySendButton> createState() => _LivelySendButtonState();
}

class _LivelySendButtonState extends State<LivelySendButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onPressed();
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.88 : 1.0,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOutBack,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 46.r,
          height: 46.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF2B6FFF), AppColors.primiary],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primiary.withValues(
                  alpha: _isPressed ? 0.2 : 0.4,
                ),
                blurRadius: _isPressed ? 4 : 10,
                offset: Offset(0, _isPressed ? 2 : 4),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.send_rounded,
              color: Colors.white,
              size: 20.r,
            ),
          ),
        ),
      ),
    );
  }
}
