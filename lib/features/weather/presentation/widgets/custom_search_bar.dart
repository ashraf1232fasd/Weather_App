import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/l10n/app_localizations.dart';
import 'package:weather_app/injection_container.dart' as di;
import '../../domain/repositories/weather_repository.dart';
import '../bloc/weather_bloc.dart';

/// A custom search bar with autocomplete functionality and history management.
class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({super.key});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textController = TextEditingController();

  /// Controls the visibility of the clear 'X' button.
  final ValueNotifier<bool> _showClearButton = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      _showClearButton.value = _textController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textController.dispose();
    _showClearButton.dispose();
    super.dispose();
  }

  /// Executes the search logic: updates UI, triggers Bloc, and saves history.
  void _performSearch(String cityName) {
    if (cityName.isNotEmpty) {
      _focusNode.unfocus();
      _textController.text = cityName;

      final currentLocale = Localizations.localeOf(context).languageCode;
      context.read<WeatherBloc>().add(
        GetWeatherForCity(cityName, currentLocale),
      );

      di.sl<WeatherRepository>().addCityToHistory(cityName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return RawAutocomplete<String>(
            textEditingController: _textController,
            focusNode: _focusNode,

            /// 1. Fetches and filters search history suggestions.
            optionsBuilder: (TextEditingValue textEditingValue) async {
              final history = await di
                  .sl<WeatherRepository>()
                  .getSearchHistory();
              if (textEditingValue.text.isEmpty) return history;
              return history.where((String option) {
                return option.toLowerCase().contains(
                  textEditingValue.text.toLowerCase(),
                );
              });
            },

            onSelected: (String selection) => _performSearch(selection),

            /// 2. Builds the modern input field with shadow and rounded corners.
            fieldViewBuilder:
                (context, controller, focusNode, onEditingComplete) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  style: TextStyle(fontSize: 16.sp, color: Colors.black87),
                  decoration: InputDecoration(
                    hintText: l10n.searchHint,
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: Colors.blueAccent,
                    ),

                    // Displays a clear button only when text is present.
                    suffixIcon: ValueListenableBuilder<bool>(
                      valueListenable: _showClearButton,
                      builder: (context, show, child) {
                        return show
                            ? IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                                onPressed: () {
                                  controller.clear();
                                  di
                                      .sl<WeatherRepository>()
                                      .getSearchHistory();
                                },
                              )
                            : const SizedBox();
                      },
                    ),

                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 16.h,
                      horizontal: 20.w,
                    ),
                  ),
                  onSubmitted: (value) => _performSearch(value),
                ),
              );
            },

            /// 3. Builds the floating suggestions dropdown card.
            optionsViewBuilder: (context, onSelected, options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: constraints.maxWidth,
                    margin: EdgeInsets.only(top: 8.h),
                    constraints: BoxConstraints(
                      maxHeight: 220.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        20.r,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(
                            0.15,
                          ),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    clipBehavior:
                        Clip.antiAlias,
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: options.length,
                      separatorBuilder: (context, index) => Divider(
                        height: 1,
                        color: Colors.grey[100],
                        indent: 16,
                        endIndent: 16,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        final String option = options.elementAt(index);
                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 0,
                          ),
                          dense: true,
                          leading: Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.history,
                              size: 16.sp,
                              color: Colors.blue,
                            ),
                          ),
                          title: Text(
                            option,
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                            ),
                          ),
                          onTap: () => onSelected(option),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}