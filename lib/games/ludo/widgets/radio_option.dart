import 'package:flutter/material.dart';

class RadioOption<T> extends StatelessWidget {
  final T? _value, _globalValue;
  final void Function(T) _onTap;
  final Color _selectedBackgroundColor, _unSelectedBackgroundColor, _borderColor;
  final BoxShadow? _activeShadow;
  final double _width;
  final EdgeInsetsGeometry _padding;
  final Widget _child;

  const RadioOption({
    required T? value,
    required T? globalValue,
    required void Function(T) onTap,
    required Color selectedBackgroundColor,
    required Color unSelectedBackgroundColor,
    required Color borderColor,
    required double width,
    required EdgeInsetsGeometry padding,
    BoxShadow? activeShadow,
    required Widget child,
    super.key,
  })  : _value = value,
        _globalValue = globalValue,
        _onTap = onTap,
        _selectedBackgroundColor = selectedBackgroundColor,
        _unSelectedBackgroundColor = unSelectedBackgroundColor,
        _borderColor = borderColor,
        _activeShadow = activeShadow,
        _width = width,
        _padding = padding,
        _child = child;

  bool get _isActive => _globalValue == _value && _value != null;

  Color get _backgroundColor => _isActive ? _selectedBackgroundColor : _unSelectedBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _value == null ? null : () => _onTap(_value as T),
      child: Container(
        width: _width,
        padding: _padding,
        decoration: BoxDecoration(
          color: _backgroundColor,
          border: _isActive ? null : Border.all(color: _borderColor),
          boxShadow: [if (_isActive && _activeShadow != null) _activeShadow],
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: _child,
      ),
    );
  }
}
