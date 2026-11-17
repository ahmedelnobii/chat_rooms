import 'package:chat_rooms/core/consts/app_colors.dart';
import 'package:flutter/material.dart';

class DeleteRoomDialog extends StatelessWidget {
  final String roomName;

  const DeleteRoomDialog({super.key, required this.roomName});

  static Future<bool?> show(BuildContext context, {required String roomName}) {
    return showDialog<bool>(
      context: context,
      builder: (_) => DeleteRoomDialog(roomName: roomName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      title: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.redAccent.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.delete_outline_rounded,
              color: Colors.redAccent,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Delete room',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Text(
        'Are you sure you want to delete "$roomName"? All messages will be permanently removed and this action cannot be undone.',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.grey.shade600,
          height: 1.4,
          fontSize: 14,
        ),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(false),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primiary,
                  minimumSize: const Size(0, 48),
                  side: BorderSide(
                    color: AppColors.primiary.withValues(alpha: 0.25),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text('Cancel'),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(0, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text('Delete room'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
