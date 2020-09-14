import 'package:flutter/material.dart';
import '../util/multi_select_list_type.dart';
import '../util/multi_select_item.dart';
import '../chip_display/multi_select_chip_display.dart';
import 'mult_select_dialog.dart';

/// A customizable InkWell widget that opens the MultiSelectDialog
// ignore: must_be_immutable
class MultiSelectDialogField<V> extends StatefulWidget {
  /// An enum that determines which type of list to render.
  final MultiSelectListType listType;

  /// Style the Container that makes up the field.
  final BoxDecoration decoration;

  /// Set text that is displayed on the button.
  final Text buttonText;

  /// Specify the button icon.
  final Icon buttonIcon;

  /// The text at the top of the dialog.
  final Text title;

  /// List of items to select from.
  final List<MultiSelectItem<V>> items;

  /// Fires when the an item is selected / unselected.
  final void Function(List<V>) onSelectionChanged;

  /// Attach a MultiSelectChipDisplay to this field.
  final MultiSelectChipDisplay chipDisplay;

  /// The list of selected values before interaction.
  final List<V> initialValue;

  /// Fires when confirm is tapped.
  final void Function(List<V>) onConfirm;

  /// Toggles search functionality.
  final bool searchable;

  /// Text on the confirm button.
  final Text confirmText;

  /// Text on the cancel button.
  final Text cancelText;

  /// Set the color of the space outside the BottomSheet.
  final Color barrierColor;

  /// Sets the color of the checkbox or chip when it's selected.
  final Color selectedColor;

  /// Give the dialog a fixed height
  final double height;

  /// Set the placeholder text of the search field.
  final String searchPlaceholder;

  /// A function that sets the color of selected items based on their value.
  /// It will either set the chip color, or the checkbox color depending on the list type.
  final Color Function(V) colorator;

  final Color backgroundColor;

  final Color chipColor;

  final Icon searchIcon;

  final Icon closeSearchIcon;

  /// Style the text on the chips or list tiles.
  final TextStyle itemsTextStyle;

  /// Style the text on the selected chips or list tiles.
  final TextStyle selectedItemsTextStyle;

  final TextStyle searchTextStyle;

  final TextStyle searchHintStyle;

  /// This FormFieldState is set when using a MultiSelectBottomSheetFormField.
  FormFieldState<List<V>> state;

  MultiSelectDialogField({
    @required this.items,
    this.title,
    this.buttonText,
    this.buttonIcon,
    this.listType,
    this.decoration,
    this.onSelectionChanged,
    this.onConfirm,
    this.chipDisplay,
    this.initialValue,
    this.searchable,
    this.confirmText,
    this.cancelText,
    this.barrierColor,
    this.selectedColor,
    this.height,
    this.searchPlaceholder,
    this.colorator,
    this.backgroundColor,
    this.chipColor,
    this.searchIcon,
    this.closeSearchIcon,
    this.itemsTextStyle,
    this.searchTextStyle,
    this.searchHintStyle,
    this.selectedItemsTextStyle,
  });

  /// This constructor allows a FormFieldState to be passed in. Called by MultiSelectDialogFormField.
  MultiSelectDialogField.withState(
      MultiSelectDialogField field, FormFieldState<List<V>> state)
      : items = field.items,
        title = field.title,
        buttonText = field.buttonText,
        buttonIcon = field.buttonIcon,
        listType = field.listType,
        decoration = field.decoration,
        onSelectionChanged = field.onSelectionChanged,
        onConfirm = field.onConfirm,
        chipDisplay = field.chipDisplay,
        initialValue = field.initialValue,
        searchable = field.searchable,
        confirmText = field.confirmText,
        cancelText = field.cancelText,
        barrierColor = field.barrierColor,
        selectedColor = field.selectedColor,
        height = field.height,
        searchPlaceholder = field.searchPlaceholder,
        colorator = field.colorator,
        backgroundColor = field.backgroundColor,
        chipColor = field.chipColor,
        searchIcon = field.searchIcon,
        closeSearchIcon = field.closeSearchIcon,
        itemsTextStyle = field.itemsTextStyle,
        searchHintStyle = field.searchHintStyle,
        searchTextStyle = field.searchTextStyle,
        selectedItemsTextStyle = field.selectedItemsTextStyle,
        state = state;

  @override
  _MultiSelectDialogFieldState createState() =>
      _MultiSelectDialogFieldState<V>();
}

class _MultiSelectDialogFieldState<V> extends State<MultiSelectDialogField<V>> {
  List<V> _selectedItems = List<V>();
  MultiSelectChipDisplay _inheritedDisplay;

  Widget _buildInheritedChipDisplay() {
    if (widget.chipDisplay != null && widget.colorator != null) {
      _inheritedDisplay = MultiSelectChipDisplay<V>(
        items: widget.chipDisplay.items,
        colorator: widget.colorator,
        onTap: widget.chipDisplay.onTap,
        decoration: widget.chipDisplay.decoration,
        chipColor: widget.chipDisplay.chipColor,
        opacity: widget.chipDisplay.opacity,
        alignment: widget.chipDisplay.alignment,
        textStyle: widget.chipDisplay.textStyle,
        icon: widget.chipDisplay.icon,
        shape: widget.chipDisplay.shape,
      );
    }
    return _inheritedDisplay;
  }

  /// Calls showDialog() and renders a MultiSelectDialog.
  _showDialog(BuildContext ctx) async {
    await showDialog(
      barrierColor: widget.barrierColor,
      context: context,
      builder: (ctx) {
        return MultiSelectDialog<V>(
          selectedItemsTextStyle: widget.selectedItemsTextStyle,
          searchHintStyle: widget.searchHintStyle,
          searchTextStyle: widget.searchTextStyle,
          itemsTextStyle: widget.itemsTextStyle,
          searchIcon: widget.searchIcon,
          closeSearchIcon: widget.closeSearchIcon,
          chipColor: widget.chipColor,
          backgroundColor: widget.backgroundColor,
          colorator: widget.colorator,
          searchPlaceholder: widget.searchPlaceholder,
          selectedColor: widget.selectedColor,
          onSelectionChanged: widget.onSelectionChanged,
          height: widget.height,
          listType: widget.listType,
          items: widget.items,
          title: widget.title != null ? widget.title : Text("Select"),
          initialValue: widget.initialValue ?? _selectedItems,
          searchable: widget.searchable ?? false,
          confirmText: widget.confirmText,
          cancelText: widget.cancelText,
          onConfirm: (selected) {
            if (widget.state != null) {
              widget.state.didChange(selected);
            }
            _selectedItems = selected;
            widget.onConfirm(selected);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        InkWell(
          onTap: () {
            _showDialog(context);
          },
          child: Container(
            decoration: widget.state != null
                ? widget.decoration ??
                    BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: widget.state != null && widget.state.hasError
                              ? Colors.red.shade800.withOpacity(0.6)
                              : _selectedItems.isNotEmpty
                                  ? widget.selectedColor ??
                                      Theme.of(context).primaryColor
                                  : Colors.black45,
                          width: _selectedItems.isNotEmpty
                              ? (widget.state != null && widget.state.hasError)
                                  ? 1.4
                                  : 1.8
                              : 1.2,
                        ),
                      ),
                    )
                : widget.decoration,
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                widget.buttonText ?? Text("Select"),
                widget.buttonIcon ?? Icon(Icons.arrow_downward),
              ],
            ),
          ),
        ),
        widget.chipDisplay != null &&
                (widget.chipDisplay.items != null &&
                    widget.chipDisplay.items.length > 0)
            ? widget.chipDisplay.colorator != null
                ? widget.chipDisplay
                : widget.colorator != null
                    ? _buildInheritedChipDisplay()
                    : widget.chipDisplay
            : Container(),
        widget.state != null && widget.state.hasError
            ? SizedBox(height: 5)
            : Container(),
        widget.state != null && widget.state.hasError
            ? Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      widget.state.errorText,
                      style: TextStyle(
                        color: Colors.red[800],
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                ],
              )
            : Container(),
      ],
    );
  }
}
