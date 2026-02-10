import 'dart:io';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

/// Send license key email to customer after purchase
Future<void> sendLicenseEmail({
  required String toEmail,
  required String customerName,
  required String licenseKey,
  required String plan,
  required int maxDeployments,
}) async {
  final smtpHost = Platform.environment['SMTP_HOST'] ?? '';
  final smtpPort = int.tryParse(Platform.environment['SMTP_PORT'] ?? '587') ?? 587;
  final smtpUser = Platform.environment['SMTP_USER'] ?? '';
  final smtpPass = Platform.environment['SMTP_PASS'] ?? '';
  final fromEmail = Platform.environment['SMTP_FROM'] ?? 'hello@omnius.stream';

  if (smtpHost.isEmpty || smtpUser.isEmpty) {
    print('[Email] SMTP not configured, skipping email to $toEmail');
    return;
  }

  final smtpServer = SmtpServer(
    smtpHost,
    port: smtpPort,
    username: smtpUser,
    password: smtpPass,
    ssl: smtpPort == 465,
    allowInsecure: false,
  );

  final message = Message()
    ..from = Address(fromEmail, 'Omnius')
    ..recipients.add(toEmail)
    ..subject = 'Your Omnius License Key'
    ..html = '''
<!DOCTYPE html>
<html>
<head><meta charset="utf-8"></head>
<body style="margin:0;padding:0;background:#141414;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;">
  <div style="max-width:560px;margin:0 auto;padding:40px 24px;">
    <div style="text-align:center;margin-bottom:32px;">
      <span style="font-size:48px;font-weight:800;color:#FF2D55;">O</span>
    </div>
    <div style="background:#1a1a1a;border:1px solid rgba(255,255,255,0.1);border-radius:16px;padding:32px;">
      <h1 style="color:#fff;font-size:24px;font-weight:700;margin:0 0 8px;">Purchase Complete!</h1>
      <p style="color:#999;font-size:14px;margin:0 0 24px;">Hi ${_escapeHtml(customerName)}, thank you for your purchase.</p>

      <div style="background:rgba(255,255,255,0.05);border:1px solid rgba(255,255,255,0.1);border-radius:12px;padding:20px;margin-bottom:24px;">
        <p style="color:#999;font-size:12px;text-transform:uppercase;letter-spacing:0.05em;margin:0 0 4px;">Plan</p>
        <p style="color:#FF2D55;font-size:14px;font-weight:600;margin:0 0 16px;">${plan.toUpperCase()} &bull; $maxDeployments deployment(s)</p>
        <p style="color:#999;font-size:12px;text-transform:uppercase;letter-spacing:0.05em;margin:0 0 4px;">License Key</p>
        <p style="color:#fff;font-size:20px;font-weight:700;font-family:monospace;margin:0;letter-spacing:0.02em;">$licenseKey</p>
      </div>

      <div style="background:rgba(255,255,255,0.03);border:1px solid rgba(255,255,255,0.08);border-radius:12px;padding:16px;margin-bottom:24px;">
        <p style="color:#999;font-size:12px;margin:0 0 8px;">Deploy with Docker:</p>
        <code style="color:#ccc;font-size:12px;line-height:1.6;word-break:break-all;">docker run -d --name omnius -p 8080:8080 -e LICENSE_KEY=$licenseKey -v omnius-data:/app/data ghcr.io/omnius-stream/server:latest</code>
      </div>

      <div style="text-align:center;">
        <a href="https://omnius.stream/app/setup" style="display:inline-block;padding:12px 28px;background:#FF2D55;color:#fff;font-weight:600;font-size:14px;border-radius:8px;text-decoration:none;">Setup Guide</a>
      </div>
    </div>
    <p style="color:#555;font-size:12px;text-align:center;margin-top:24px;">Omnius &bull; <a href="https://omnius.stream" style="color:#555;">omnius.stream</a></p>
  </div>
</body>
</html>
''';

  try {
    final sendReport = await send(message, smtpServer);
    print('[Email] License key sent to $toEmail: $sendReport');
  } catch (e) {
    print('[Email] Failed to send to $toEmail: $e');
  }
}

String _escapeHtml(String text) {
  return text
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;');
}
