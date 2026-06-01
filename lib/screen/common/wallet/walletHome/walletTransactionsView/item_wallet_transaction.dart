import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../utils/utils.dart';
import '../wallet_home_dl.dart';

class ItemWalletTransaction extends StatelessWidget {
  final TransactionsItem item;

  const ItemWalletTransaction({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10.w,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          item.transactionType == WalletTransactionType.credit ? CustomIcons.credit : CustomIcons.debit,
          color: item.transactionType == WalletTransactionType.credit ? getCurrentTheme(context).colorCreditIcon : getCurrentTheme(context).colorDebitIcon,
          size: 28.sp,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                item.subject,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: bodyText(context: context, fontSize: textSize18px, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10.h),
              Text(getDateTime(item.dateTime), maxLines: 1, overflow: TextOverflow.ellipsis, style: bodyText(context: context, fontSize: textSize14px)),
            ],
          ),
        ),
        Flexible(
          flex: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                getAmountWithCurrency(item.amount),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: bodyText(context: context, fontSize: textSize18px, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10.h),
              if (item.orderNo.isNotEmpty)
                Text("#${item.orderNo}", maxLines: 1, overflow: TextOverflow.ellipsis, style: bodyText(context: context, fontSize: textSize14px)),
            ],
          ),
        ),
      ],
    );
  }
}
