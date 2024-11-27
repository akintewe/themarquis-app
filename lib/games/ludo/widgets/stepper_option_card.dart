import 'package:flutter/material.dart';

class StepperOptionCard extends StatelessWidget {
  final bool _isVisible, _isDisabled;
  final int _cardIndex, _activeCardIndex;
  final Widget _child;
  const StepperOptionCard(
      {required int cardIndex, required int activeCardIndex, required bool isEnabled, bool isDisabled = false, required Widget child, super.key})
      : _cardIndex = cardIndex,
        _activeCardIndex = activeCardIndex,
        _child = child,
        _isVisible = isEnabled,
        _isDisabled = isDisabled;

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: _isDisabled,
      child: Visibility(
        maintainInteractivity: false,
        maintainSize: true,
        maintainState: true,
        visible: _isVisible || _cardIndex == _activeCardIndex,
        maintainAnimation: true,
        maintainSemantics: true,
        child: Container(
          margin: const EdgeInsets.only(bottom: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF21262B),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: _child,
        ),
      ),
    );
  }
}
