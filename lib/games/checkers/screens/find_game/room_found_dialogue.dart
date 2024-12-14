import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class RoomFoundDialogue extends ConsumerStatefulWidget {
  const RoomFoundDialogue({super.key});

  @override
  ConsumerState<RoomFoundDialogue> createState() => RoomFoundDialogueState();
}

class RoomFoundDialogueState extends ConsumerState<RoomFoundDialogue> {
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
                _topBar(context),
                SizedBox(height: 16),
                _roomFoundDetails(context),
                SizedBox(height: 16),
                _buttons(context),
                SizedBox(height: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.all(0),
            onPressed: Navigator.of(context).pop,
            icon: const Icon(
              Icons.cancel_outlined,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
        const Text(
          'Room Found!',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
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
            child: const Text("Back"),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              foregroundColor: Colors.black,
              backgroundColor: const Color(0xFFF3B46E),
            ),
            child: isLoading
                ? const CircularProgressIndicator()
                : const Text("Join"),
          ),
        ),
      ],
    );
  }

  Widget _roomFoundDetails(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.orbitronTextTheme(),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.12,
        width: MediaQuery.of(context).size.width * 0.33,
        decoration: BoxDecoration(
          color: const Color(0x94181B25),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: Color(0xFF2E2E2E),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'ROOM 0028',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
              const Text(
                '1/2 Players',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8),
              Row(
               mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.043,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: const Color(0xFFF3B46E),
                    ),
                    child: Center(
                      child: Image.asset('assets/images/male.png'),
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.043,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      border: Border.all(
                        color: const Color(0xFF5D5D5D),
                      ),
                    ),
                    child: Center(
                        child: SvgPicture.asset('assets/svg/userCheckers.svg')),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
