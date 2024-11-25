import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:riu_society/roles/admin/home/events/controllers/create_event_controller.dart';
import 'package:riu_society/utils/app_colors.dart';
import 'package:riu_society/utils/app_textstyle.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:riu_society/utils/functions.dart';

class ScanQrCode extends StatefulWidget {
  const ScanQrCode({super.key, required this.eventC, required this.docID});
  final CreateEventController eventC;
  final String docID;
  @override
  State<ScanQrCode> createState() => _ScanQrCodeState();
}

class _ScanQrCodeState extends State<ScanQrCode> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? qrC;
  final userUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      qrC!.pauseCamera();
    } else {
      qrC!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Scan QR Code',
          style: AppTextStyle.regularWhite18,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: QRView(
              key: qrKey,
              overlay: QrScannerOverlayShape(
                borderColor: AppColors.secondary,
                borderRadius: 15,
                borderWidth: 7,
              ),
              onQRViewCreated: onQRViewCreated,
            )),
          ],
        ),
      ),
    );
  }

  onQRViewCreated(QRViewController controller) {
    qrC = controller;
    return controller.scannedDataStream.listen(
      (data) async {
        await controller.pauseCamera();
        result = data;
        DocumentSnapshot docs = await FirebaseFirestore.instance
            .collection('events')
            .doc(widget.docID)
            .get();
        List id = List.from(docs['attendance']);
        if (result!.code!.isNotEmpty && !id.contains(result!.code)) {
          // ignore: use_build_context_synchronously
          widget.eventC
              .addAttendance(widget.docID, result!.code!, mounted, context);
        } else {
          if (mounted) {
            Navigator.pop(context);
          }
          rawSackbar('Attendance already taken');
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    qrC!.dispose();
  }
}
