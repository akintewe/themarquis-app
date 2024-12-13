import 'package:flutter/material.dart';

class RadioOption<T> extends StatelessWidget {
  final T? _value, _globalValue;
  final void Function(T) _onTap;
  final Color _selectedBackgroundColor, _unSelectedBackgroundColor, _borderColor;
  final double _width;
  final EdgeInsetsGeometry _padding;
  final Widget _child;
  final bool _useGradient;

  const RadioOption({
    required T? value,
    required T? globalValue,
    required void Function(T) onTap,
    required Color selectedBackgroundColor,
    required Color unSelectedBackgroundColor,
    required Color borderColor,
    required double width,
    required EdgeInsetsGeometry padding,
    required Widget child,
    bool useGradient = true,
    super.key,
  })  : _value = value,
        _globalValue = globalValue,
        _onTap = onTap,
        _selectedBackgroundColor = selectedBackgroundColor,
        _unSelectedBackgroundColor = unSelectedBackgroundColor,
        _borderColor = borderColor,
        _width = width,
        _padding = padding,
        _useGradient = useGradient,
        _child = child;

  bool get _isActive => _globalValue == _value && _value != null;

  Color get _backgroundColor => _isActive ? _selectedBackgroundColor : _unSelectedBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: GestureDetector(
        onTap: _value == null ? null : () => _onTap(_value as T),
        child: Container(
          width: _width,
          decoration: BoxDecoration(
            border: Border.all(color: _isActive ? _backgroundColor : _borderColor),
            gradient: !_isActive || !_useGradient ? null : RadialGradient(colors: [Colors.transparent, Color(0xFF00ECFF).withOpacity(0.6)], radius: 1.7),
            borderRadius: BorderRadius.circular(8),
          ),
          clipBehavior: Clip.antiAlias,
          alignment: Alignment.center,
          child: Container(
            padding: _padding,
            width: _width,
            decoration: BoxDecoration(
              gradient: !_isActive || !_useGradient
                  ? null
                  : LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF00ECFF).withOpacity(0.6),
                        Colors.transparent,
                        Color(0xFF00ECFF).withOpacity(0.6),
                      ],
                      stops: [0.05, 0.4, 1],
                    ),
            ),
            alignment: Alignment.center,
            child: _child,
          ),
        ),
      ),
    );
  }
}
