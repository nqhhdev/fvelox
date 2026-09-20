import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment.dart';

import 'package:fvelox/features/payment_approval/presentation/widgets/approval_sheet_state.dart';

class ApprovalSheet extends ConsumerStatefulWidget {
  const ApprovalSheet({required this.request, super.key});

  final Payment request;

  @override
  ConsumerState<ApprovalSheet> createState() => ApprovalSheetState();
}
