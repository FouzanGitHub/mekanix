import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/helpers/appcolors.dart';
import 'package:app/helpers/custom_text.dart';
import 'package:app/helpers/reusable_container.dart';
import 'package:get/get.dart';

class CustomCheckboxWidget extends StatelessWidget {
  final String heading;
  final List<String> options, selected;
  final bool showDeleteIcon;
  final VoidCallback? onDelete;
  final bool showEditIcon;
  final VoidCallback? onEdit;
   final bool showEditTitle;
  final VoidCallback? onEditTitle; 
   final Function(List<String>) onChange;
  final bool showAddIcon;
  final VoidCallback? onAddTap;
  const CustomCheckboxWidget({
    super.key,
    required this.options,
    required this.selected,
    required this.heading,
    required this.onChange,
    this.showDeleteIcon = false,
    this.onDelete,
    this.showEditIcon = false,
      this.onEditTitle,
    this.showEditTitle = false,
    this.onEdit,
    this.showAddIcon = false,
    this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    var selectedValues = <String>[...selected].obs;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             InkWell(
                  onTap: onEditTitle,
                  child: Row(
                 
                    children: [
                    Visibility(
                    visible: showEditTitle,
                    child: const Icon(Icons.edit,color: Colors.grey,size: 18,)),
                      const SizedBox(width: 1),
                      SizedBox(
                     
                    width: 270,
                        child: CustomTextWidget(
                        text: heading,
                        fontWeight: FontWeight.w500,
                        maxLines: 2,
                        fontSize:  12,
                                      ),
                      ),
                    ],
                  ),
                ),
            Visibility(
                visible: showAddIcon,
                child: InkWell(
                  onTap: onAddTap,
                  child: const Icon(
                    CupertinoIcons.add_circled_solid,
                    color: Color.fromARGB(255, 110, 110, 110),
                  ),
                ),
              ),      
           ],
         ),
        // InkWell(
        //   onTap: onEditTitle,
        //   child: CustomTextWidget(
        //     text: heading,
        //     fontWeight: FontWeight.w500,
        //     maxLines: 2,
        //     fontSize: 12,
        //   ),
        // ),
        Obx(
          () => ReUsableContainer(
            showDeleteIcon: showDeleteIcon,
            onDelete: onDelete,
            showEditIcon: showDeleteIcon,
            onEdit: onEdit,

            child: Column(
              children: options
                  .map((option) => CheckboxListTile(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        activeColor: AppColors.blueTextColor,
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        title: CustomTextWidget(text: option, fontSize: 11),
                        controlAffinity: ListTileControlAffinity.leading,
                        visualDensity: VisualDensity.compact,
                        value: selectedValues.contains(option),
                        onChanged: (bool? value) {
                          if (value != null) {
                            selectedValues.contains(option)
                                ? selectedValues.remove(option)
                                : selectedValues.add(option);
                            onChange(selectedValues);
                          }
                        },
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
