import '../ui_imports.dart';

class TextFormFieldWidget extends StatefulWidget {
  const TextFormFieldWidget({
    super.key,
    required this.onChanged,
    this.onShowPasswordIconSelected,
    this.prefixIconBoxConstraints,
    this.padding,
    this.autofillHints,
    this.keyboardType,
    required this.hintText,
    required this.isPassword,
    this.icon,
    this.controller,
  });

  final VoidCallback? onShowPasswordIconSelected;
  final BoxConstraints? prefixIconBoxConstraints;
  final ValueChanged<String> onChanged;
  final Iterable<String>? autofillHints;
  final EdgeInsetsGeometry? padding;
  final TextInputType? keyboardType;
  final String hintText;
  final bool isPassword;
  final Widget? icon;
  final TextEditingController? controller;

  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  final FocusNode focusNode = FocusNode();
  late bool isShown;

  @override
  void initState() {
    isShown = widget.isPassword;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: AppColors.darkDefault,
            borderRadius: BorderRadius.circular(26)),
        height: 48,
        child: TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          autofillHints: widget.autofillHints,
          autocorrect: false,
          style: AppTextTheme.textStyleDMSanse14W400(),
          obscureText: isShown,
          focusNode: focusNode,
          onTapOutside: (event) {
            focusNode.unfocus();
          },
          obscuringCharacter: '*',
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            suffixIcon: widget.isPassword
                ? Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isShown = !isShown;
                          });
                        },
                        child: SvgPicture.asset(
                          isShown
                              ? 'assets/icons/eye-password-hide-svgrepo-com.svg'
                              : 'assets/icons/eye-password-show-svgrepo-com.svg',
                          colorFilter: ColorFilter.mode(
                            AppColors.white,
                            BlendMode.srcIn,
                          ),
                        )),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: AppColors.grey,
            hintText: widget.hintText,
            hintStyle: AppTextTheme.textStyleDMSanse14W400(
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(
                bottom: 8,
                left: 9,
                right: 11,
                top: 6,
              ),
              child: widget.icon,
            ),
            prefixIconConstraints: widget.prefixIconBoxConstraints,
          ),
        ));
  }
}
