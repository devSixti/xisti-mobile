import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/utils.dart';
import 'manage_address_dl.dart';

class ItemManageAddress extends StatelessWidget {
  final ItemManageAddressList addressListItem;
  final AddressType addressType;
  final Function()? onDeletePress;

  const ItemManageAddress({super.key, required this.addressListItem, required this.addressType, this.onDeletePress});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(getAddressTypeIcon(type: addressType.type), size: 15.sp, color: getCurrentTheme(context).colorIconCommon),
        SizedBox(width: 12.w),
        Expanded(child: Text(addressListItem.address, style: bodyText(context: context), maxLines: 2, overflow: TextOverflow.ellipsis)),
        if (onDeletePress != null) ...[
          SizedBox(width: 12.w),
          GestureDetector(onTap: onDeletePress, child: Icon(CustomIcons.deleteBin, size: 15.sp, color: getCurrentTheme(context).colorDeleteIcon)),
        ],
      ],
    );
  }
}
