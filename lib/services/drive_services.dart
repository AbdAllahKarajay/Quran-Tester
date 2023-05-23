import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart' as auth;

class DriveServices{
  static Future uploadFileToDrive(File toUploadFile, String tempPath) async {
    File file = _encodeFile(toUploadFile, tempPath);
    // Replace with your own service account key file path
    final serviceAccountFile = File(
        'assets/tactile-alloy-386113-ae7d303a42d0.json');

    // Load the service account key file and create a credentials object
    final credentials =
    auth.ServiceAccountCredentials.fromJson(
        await serviceAccountFile.readAsString());

    // Create an authorized client using the credentials
    final scopes = [drive.DriveApi.driveFileScope];
    final client = await auth.clientViaServiceAccount(credentials, scopes);

    try {
      // Create a Drive API client
      final driveApi = drive.DriveApi(client);

      final existingFileList = await driveApi.files.list();
      if (existingFileList.files!.isNotEmpty) {
        final existingFiles = existingFileList.files?.where(
                (f) =>
            f.name == file.path
                .split('/')
                .last);

        if (existingFiles!.isNotEmpty) {
          final existingFile = existingFiles.first;
          // If a file with the same name already exists, replace it
          final uploadMedia = drive.Media(
              http.ByteStream(file.openRead()), file.lengthSync());
          // final res = await driveApi.files.delete(existingFile.id);
          final response = await driveApi.files.update(
            drive.File(),
            existingFile.id!,
            uploadMedia: uploadMedia,
            uploadOptions: drive.ResumableUploadOptions(),
          );

          return response.id;
        }
      }
      // Create a file object with the name and type of the file to upload
      final fileToUpload = drive.File()
        ..name = file.path
            .split('/')
            .last
        ..mimeType = 'text/plain'
        ..parents = ['1ekg8FOYVDW2HMbeRD0JGT-iCokxLhS4B'];

      // Upload the file to Drive
      final mediaStream = http.ByteStream(file.openRead());
      final uploadMedia = drive.Media(mediaStream, file.lengthSync());
      final uploadedFile = await driveApi.files.create(fileToUpload,
        uploadMedia: uploadMedia,
        uploadOptions: drive.ResumableUploadOptions(),

        //
        //    headers: {'If-Match': existingFile.etag},:
      );
      return uploadedFile.id;
    } catch (_) {} finally {
      client.close();
    }
  }

  static Future<void> downloadFileFromDrive(String fileName, String downloadPath) async {

    final credentials =
    auth.ServiceAccountCredentials.fromJson({
      "type": "service_account",
      "project_id": "tactile-alloy-386113",
      "private_key_id": "ae7d303a42d000b6c0f05dcdee64ab32eb9ed51b",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDYvQFyBOMlTnG5\ne5EnhTWekpd/tuoDNmcLjv6/R95AsW+7ORSTJjwRkcRdpMkZw9luYffCzmCiRbpn\nBUrNR5eFPhYHk+avOvJblMD5yqgQJ425kt3QvXBb0Z9CXJpR814BxkNLCmN5R0IG\nx9069AAwBw0WFyTwhEw4qgALorShvdl5HEDWL10SOeRTEdOblErDT/vx8WgZPrdF\n02/+dijIOD8R0RCKwRNxIjRLMbJUPhbTEcaD8VNv6HLP+hp4rxYDzir8js6KAGbm\nFjsefBRRMuL3SEU5RVObiMRVB/ZISe+ajTUR+9XIqIbX4Y5RdYq6dAIoOTw4H0eI\nYckFBHh5AgMBAAECggEADcYtQlbHLMbIeXY96loP50z/rdEtHBkoAVcMH5HssQXV\nyPs+sH9cj+1Ion7nfOiyd85oFYxSHd36k7OFZnhnS8N/WOnwXjCL2IAip31Wovgw\njJul1y9C5cLzsR77e7vQvKIiArHdUobRzmaDS8zX+jVogn/kDBkMUwmSySqE+kZd\ni8RcjDPFN3Ip07L8kbqLflhfKP0jM6NTo0EAuuVsrWDPDXfNLK/WPljBtsll6Gq1\nhVjyUjR7lJPXupjpH01sb5j81WDkwHBrfSWYTZFBrnlIKTr0hMqeTYrLYDSNFBkc\n8mFwC94T66mTFxCfjkuLlKJNydcw5QvftbOnQhgykQKBgQDt85Hpb4ITKWTxvsmM\n4fPC0/DNsHieEL8jpI8w1McML5WinFCcuAdxsFRgoFQgPnkbGwrQt6jdNbkZuQti\naBxrvax+07I556qbxoSodEvoSTUmqX58w1QCCF0NTycnVNpgfGWDKpM+aWktlNGc\nV8mV+YFoJ06RODG5B4JQDljNTQKBgQDpLYdfLCSgj69QgWyV2PeNGtXmMnTIQ7e9\nBXnYRv4+KwOTaByIcfqqaIp1OXTakCtDoQK9TX5hJCeVqqdv9CSJY5vGsJeb/UrL\ntAAeu4xag9g0AWFuffxwHOgrnw1qDDG5EVjHZdVlik2/IYUudiGbX4iMmG2akvco\n/XB4TY2x3QKBgQDlUUICXQNXYiI1U++7hRo9XbGJGRP1CSCbwgB5R+YYGVe04b5S\neow6BXwbrwfEF1DxTWtr4EOuBBNB9fJBwSH6t02g4HW3lkr2WygHjCSHVN4TR29t\n33R7jQHYTLroDb9zEw9ljEdg84d4dR5Y9MWCcnVDIfZ2v1g0AEeWzWzJVQKBgQCG\nPssYNQ7lTbPuUoUUhHSJTXDmdhgcEDihX5y1srG/Uv5dCGyc9ZoOL9+++5RWHPh7\nmCA+onXnMWyE01pQryu12Z4etx6iFSLRwlDrYKi+l/eKgVz5wxjp5wqXyptreZfK\n57zIF83TBtwZ9Q97H1Hb5RV1dHBttL0NYVQ2PtgcFQKBgGPeIUsVIQ/3KonVjx/o\nky6tXN/NAbnuIU7ES66n9o1VYcU4w/tU3l10sMpTKir8sD3L4HMQ3LGgutHAJ3PV\n7Jwf1mcX1sC3pCr2GB0lrDexCTlKqvuBz9Vq8HueBvbhfSjur+eQEA7b07psV7mP\nLq8Gzd2ZojghRJbbNdWTYYOi\n-----END PRIVATE KEY-----\n",
      "client_email": "drive-downloader@tactile-alloy-386113.iam.gserviceaccount.com",
      "client_id": "109790873828433573956",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/drive-downloader%40tactile-alloy-386113.iam.gserviceaccount.com"
    }
    );

    // Create an authorized client using the credentials
    final scopes = [drive.DriveApi.driveFileScope];
    final client = await auth.clientViaServiceAccount(credentials, scopes);

    try {
      // Create a Drive API client
      final driveApi = drive.DriveApi(client);

      // Download the file from Drive
      final existingList = (await driveApi.files.list());
      if (existingList.files!.isEmpty) return;
      final fileId = existingList.files
          ?.firstWhere((element) => element.name == fileName)
          .id;
      if (fileId == null) return;
      drive.Media response = await driveApi.files.get(
        fileId, downloadOptions: drive.DownloadOptions.fullMedia,
        acknowledgeAbuse: true,
        supportsAllDrives: true,
      ) as drive.Media;

      final bytes = <int>[];
      await response.stream.forEach((chunk) => bytes.addAll(chunk));
      final responseBytes = Uint8List.fromList(bytes);
      _decodeFile(responseBytes, downloadPath);

    } catch (e) {
      rethrow;
    } finally {
      client.close();
    }
  }

  static _encodeFile(File file, path) {
    final plainText = file.readAsBytesSync();

    final encrypter = Encrypter(AES(key));

    final encrypted = encrypter.encryptBytes(plainText, iv: iv);
    return File(path)
      ..writeAsBytesSync(encrypted.bytes);
  }

  static _decodeFile(encrypted, path) {
    // final encrypted = file.readAsBytesSync();
    final encrypter = Encrypter(AES(key));

    final decrypted = encrypter.decryptBytes(Encrypted(encrypted), iv: iv);
    return File(path)
      ..writeAsBytesSync(decrypted);
  }

  static final key = Key.fromUtf8('CeNeZ4s1OvVBTfFlZmOpPQqD1YecJeZp');
  static final iv = IV.fromLength(16);
}

//to update file before writing
// await DriveServices.downloadFileFromDrive("students.txt", 'assets/students.hive');
// await hive.init(first: false);

