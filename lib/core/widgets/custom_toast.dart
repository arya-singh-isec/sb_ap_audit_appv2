import 'package:flutter/material.dart';
import 'package:sb_ap_audit_appv2/core/widgets/custom_text.dart';

class CustomToast {
  static show(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
        bottom: 50.0,
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: IntrinsicWidth(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.8,
                  ),
                  child: CustomText.labelMedium(
                    message,
                    textColor: TextColor.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 5), () => overlayEntry.remove());
  }
}
