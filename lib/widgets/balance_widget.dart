part of '../bytebank_balance.dart';

class BytebankBalance extends StatefulWidget {
  const BytebankBalance({
    super.key,
    required this.color,
    required this.userId,
  });

  final String userId;
  final Color color;

  @override
  State<BytebankBalance> createState() => _BytebankBalanceState();
}

class _BytebankBalanceState extends State<BytebankBalance> {
  final BalanceServices _balanceServices = BalanceServices();

  bool _isBalanceVisible = false;
  double balance = 0.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Saldo",
              style: TextStyle(
                fontSize: 20,
                color: widget.color,
                fontWeight: FontWeight.w600,
              ),
            ),
            IconButton(
              onPressed: () async => await onVisibilityBalanceChanged(),
              icon: Icon(
                _isBalanceVisible ? Icons.visibility : Icons.visibility_off,
                color: widget.color,
                size: 20,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Divider(color: widget.color, thickness: 2),
        ),
        Text(
          "Conta Corrente",
          style: TextStyle(
            color: widget.color,
            fontSize: 16,
          ),
        ),
        Text(
          _isBalanceVisible
              ? "R\$ ${balance.toStringAsFixed(2).replaceAll('.', ',')}"
              : 'R\$ - - -',
          style: TextStyle(
            color: widget.color,
            fontSize: 32,
          ),
        )
      ],
    );
  }

  Future<void> onVisibilityBalanceChanged() async {
    if (_isBalanceVisible) {
      setState(() {
        _isBalanceVisible = false;
      });
    } else {
      bool hasPin = await _balanceServices.hasPin(
        userId: widget.userId,
      );

      if (mounted) {
        showPinDialog(context, isRegister: !hasPin).then(
          (String? pin) {
            if (pin != null) {
              if (hasPin) {
                _balanceServices
                    .getBalance(
                  userId: widget.userId,
                  pin: pin,
                )
                    .then((double b) {
                  setState(() {
                    _isBalanceVisible = true;

                    balance = b;
                  });
                }).catchError((error) {
                  if (mounted) {
                    showErrorSnackbar(
                      context: context,
                      message: error.message,
                    );
                  }
                });
              } else {
                _balanceServices
                    .createPin(
                  userId: widget.userId,
                  pin: pin,
                )
                    .then((double b) {
                  setState(() {
                    _isBalanceVisible = true;

                    balance = b;
                  });
                }).catchError((error) {
                  if (mounted) {
                    showErrorSnackbar(
                      context: context,
                      message: error.message,
                    );
                  }
                });
              }
            }
          },
        );
      }
    }
  }
}
