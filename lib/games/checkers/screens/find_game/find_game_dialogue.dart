import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquis_v2/games/checkers/screens/find_game/room_found_dialogue.dart';

class CheckersFindRoomDialog extends ConsumerStatefulWidget {
  const CheckersFindRoomDialog({super.key});

  @override
  ConsumerState<CheckersFindRoomDialog> createState() =>
      CheckersFindRoomDialogState();
}

class CheckersFindRoomDialogState
    extends ConsumerState<CheckersFindRoomDialog> {
  final _roomIdController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _roomIdController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context)
          .copyWith(textTheme: GoogleFonts.montserratTextTheme()),
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        backgroundColor: const Color(0xFF21262B),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.80,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Find Game',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),
                _textField(),
                const SizedBox(height: 16),
                _buttons(context),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _textField() {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Room ID",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(
          height: 41,
          child: TextField(
            style: const TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
              hintText: "Please enter room ID",
              hintStyle: const TextStyle(
                  color: Color(0xFF8B8B8B),
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
              fillColor: const Color(0xFF363D43),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
            ),
            controller: _roomIdController,
          ),
        ),
      ],
    );
  }

  Widget _buttons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: Navigator.of(context).pop,
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              foregroundColor: const Color(0xFFF3B46E),
              side: const BorderSide(
                color: Color(0xFFF3B46E),
              ),
            ),
            child: const Text("Cancel"),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _roomFoundDialog(ctx: context);
            },
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              foregroundColor: Colors.black,
              backgroundColor: const Color(0xFFF3B46E),
            ),
            child: isLoading
                ? const CircularProgressIndicator()
                : const Text("Confirm"),
          ),
        ),
      ],
    );
  }

  Future<void> _roomFoundDialog({required BuildContext ctx}) {
    return showDialog(
      context: ctx,
      builder: (BuildContext context) {
        return RoomFoundDialogue();
      },
    );
  }
}
