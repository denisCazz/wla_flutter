import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Input field ultra moderno con animazioni e validazione
class ModernInput extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconTap;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final ModernInputVariant variant;
  final String? semanticLabel;

  const ModernInput({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.focusNode,
    this.validator,
    this.variant = ModernInputVariant.outlined,
    this.semanticLabel,
  });

  @override
  State<ModernInput> createState() => _ModernInputState();
}

class _ModernInputState extends State<ModernInput>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _labelAnimation;
  late Animation<Color?> _borderColorAnimation;
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _hasContent = false;

  @override
  void initState() {
    super.initState();
    
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _labelAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _borderColorAnimation = ColorTween(
      begin: Theme.of(context).colorScheme.outline,
      end: AppColors.primary,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Check initial content
    if (widget.controller?.text.isNotEmpty == true) {
      _hasContent = true;
      _animationController.value = 1.0;
    }
    
    widget.controller?.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    widget.controller?.removeListener(_handleTextChange);
    _animationController.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    
    if (_isFocused || _hasContent) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _handleTextChange() {
    final hasContent = widget.controller?.text.isNotEmpty == true;
    if (hasContent != _hasContent) {
      setState(() {
        _hasContent = hasContent;
      });
      
      if (_hasContent || _isFocused) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasError = widget.errorText != null;
    
    return Semantics(
      label: widget.semanticLabel ?? widget.label,
      textField: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_getBorderRadius()),
                  border: _getBorder(colorScheme, hasError),
                  color: _getBackgroundColor(colorScheme),
                  boxShadow: _isFocused && !hasError
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Stack(
                  children: [
                    // Input field
                    TextFormField(
                      controller: widget.controller,
                      focusNode: _focusNode,
                      keyboardType: widget.keyboardType,
                      textInputAction: widget.textInputAction,
                      obscureText: widget.obscureText,
                      enabled: widget.enabled,
                      readOnly: widget.readOnly,
                      maxLines: widget.maxLines,
                      maxLength: widget.maxLength,
                      inputFormatters: widget.inputFormatters,
                      onChanged: widget.onChanged,
                      onFieldSubmitted: widget.onSubmitted,
                      onTap: widget.onTap,
                      validator: widget.validator,
                      style: AppTypography.bodyMedium.copyWith(
                        color: widget.enabled
                            ? colorScheme.onSurface
                            : colorScheme.onSurface.withOpacity(0.6),
                      ),
                      decoration: InputDecoration(
                        hintText: _shouldShowHint() ? widget.hint : null,
                        hintStyle: AppTypography.bodyMedium.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                        prefixIcon: widget.prefixIcon != null
                            ? Icon(
                                widget.prefixIcon,
                                color: _isFocused
                                    ? AppColors.primary
                                    : colorScheme.onSurface.withOpacity(0.6),
                              )
                            : null,
                        suffixIcon: widget.suffixIcon != null
                            ? GestureDetector(
                                onTap: widget.onSuffixIconTap,
                                child: Icon(
                                  widget.suffixIcon,
                                  color: _isFocused
                                      ? AppColors.primary
                                      : colorScheme.onSurface.withOpacity(0.6),
                                ),
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: _getContentPadding(),
                        counterText: '',
                      ),
                    ),
                    
                    // Animated label
                    if (widget.label != null) _buildAnimatedLabel(colorScheme, hasError),
                  ],
                ),
              );
            },
          ),
          
          // Helper and error text
          if (widget.helperText != null || widget.errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs, left: AppSpacing.md),
              child: Text(
                widget.errorText ?? widget.helperText!,
                style: AppTypography.bodySmall.copyWith(
                  color: hasError
                      ? AppColors.error
                      : colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAnimatedLabel(ColorScheme colorScheme, bool hasError) {
    return Positioned(
      left: widget.prefixIcon != null ? 48 : AppSpacing.md,
      child: AnimatedBuilder(
        animation: _labelAnimation,
        builder: (context, child) {
          final progress = _labelAnimation.value;
          final scale = 0.75 + (0.25 * (1 - progress));
          final translateY = -24 * progress;
          
          return Transform.translate(
            offset: Offset(0, translateY + 16),
            child: Transform.scale(
              scale: scale,
              alignment: Alignment.centerLeft,
              child: Text(
                widget.label!,
                style: AppTypography.bodyMedium.copyWith(
                  color: hasError
                      ? AppColors.error
                      : _isFocused
                          ? AppColors.primary
                          : colorScheme.onSurface.withOpacity(0.6),
                  fontWeight: _isFocused ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  bool _shouldShowHint() {
    return !_isFocused && !_hasContent && widget.label == null;
  }

  double _getBorderRadius() {
    switch (widget.variant) {
      case ModernInputVariant.outlined:
        return AppSpacing.borderRadius;
      case ModernInputVariant.filled:
        return AppSpacing.borderRadius;
      case ModernInputVariant.underlined:
        return 0;
    }
  }

  Border? _getBorder(ColorScheme colorScheme, bool hasError) {
    final borderColor = hasError
        ? AppColors.error
        : _isFocused
            ? AppColors.primary
            : colorScheme.outline;

    switch (widget.variant) {
      case ModernInputVariant.outlined:
        return Border.all(
          color: borderColor,
          width: _isFocused ? 2 : 1,
        );
      case ModernInputVariant.filled:
        return Border(
          bottom: BorderSide(
            color: borderColor,
            width: _isFocused ? 2 : 1,
          ),
        );
      case ModernInputVariant.underlined:
        return Border(
          bottom: BorderSide(
            color: borderColor,
            width: _isFocused ? 2 : 1,
          ),
        );
    }
  }

  Color _getBackgroundColor(ColorScheme colorScheme) {
    switch (widget.variant) {
      case ModernInputVariant.outlined:
        return Colors.transparent;
      case ModernInputVariant.filled:
        return colorScheme.surfaceVariant.withOpacity(0.5);
      case ModernInputVariant.underlined:
        return Colors.transparent;
    }
  }

  EdgeInsets _getContentPadding() {
    final hasLabel = widget.label != null;
    final verticalPadding = hasLabel ? AppSpacing.lg : AppSpacing.md;
    
    return EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: verticalPadding,
    );
  }
}

enum ModernInputVariant {
  outlined,
  filled,
  underlined,
}
