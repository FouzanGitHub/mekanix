import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/helpers/appcolors.dart';
import 'package:app/helpers/custom_text.dart';
import 'package:app/helpers/reusable_container.dart';
import 'package:get/get.dart';

class CustomRadioButton extends StatelessWidget {
  final String heading;
  final List<String> options;
  final String? selected;
  final bool showDeleteIcon;
  final VoidCallback? onDelete;
  final bool showEditIcon;
  final VoidCallback? onEdit;
    final bool showEditTitle;
  final VoidCallback? onEditTitle;
  final Function(String) onChange;
   final bool showAddIcon;
  final VoidCallback? onAddTap;

  const CustomRadioButton({
    super.key,
    required this.heading,
    required this.options,
    required this.selected,
    this.showDeleteIcon = false,
    this.onDelete,
    this.showEditIcon = false,
    this.onEdit, 
    this.showEditTitle = false,
    this.onEditTitle,  
    required this.onChange,
     this.showAddIcon = false,
    this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    final selectedOption = Rx<String?>(selected);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const SizedBox(height: 6.0),
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
            showEditIcon: showEditIcon,
            onEdit: onEdit,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: options.map((option) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    children: [
                      Radio(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        activeColor: AppColors.blueTextColor,
                        value: option,
                        groupValue: selectedOption.value,
                        onChanged: (value) {
                          selectedOption.value = value;
                          if (value is String) onChange(value);
                        },
                      ),
                      CustomTextWidget(
                        text: option,
                        fontSize: 11.0,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
