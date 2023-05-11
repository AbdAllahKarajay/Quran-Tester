import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart' as auth;

import '../models/afif_test.dart';
import 'hive_services.dart';


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
      print(existingFileList.files);
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

          print('File replaced on Drive: ${response.id}');
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
      print('File uploaded: ${uploadedFile.id}');
      return uploadedFile.id;
    } catch (e) {
      print('Error uploading file: $e');
    } finally {
      client.close();
    }
  }

  static Future<void> downloadFileFromDrive(String fileName, String downloadPath) async {
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

      print('File downloaded: $downloadPath');
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

