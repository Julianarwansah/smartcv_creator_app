import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload file and return download URL
  Future<String> uploadFile({
    required File file,
    required String folder,
    String? fileName,
  }) async {
    try {
      final String fileExtension = path.extension(file.path);
      final String uploadFileName =
          fileName ?? '${DateTime.now().millisecondsSinceEpoch}$fileExtension';
      final String filePath = '$folder/$uploadFileName';

      final ref = _storage.ref().child(filePath);
      final uploadTask = await ref.putFile(file);

      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Gagal upload file: $e');
    }
  }

  // Upload PDF
  Future<String> uploadPDF({
    required File file,
    required String userId,
    required String resumeId,
  }) async {
    return await uploadFile(
      file: file,
      folder: 'resumes/$userId',
      fileName: '${resumeId}_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
  }

  // Upload image
  Future<String> uploadImage({
    required File file,
    required String userId,
    required String folder,
  }) async {
    return await uploadFile(file: file, folder: '$folder/$userId');
  }

  // Upload profile photo
  Future<String> uploadProfilePhoto({
    required File file,
    required String userId,
  }) async {
    return await uploadFile(
      file: file,
      folder: 'profile_photos',
      fileName: '$userId.jpg',
    );
  }

  // Upload portfolio banner
  Future<String> uploadPortfolioBanner({
    required File file,
    required String userId,
    required String portfolioId,
  }) async {
    return await uploadFile(
      file: file,
      folder: 'portfolios/$userId',
      fileName: '${portfolioId}_banner.jpg',
    );
  }

  // Upload project image
  Future<String> uploadProjectImage({
    required File file,
    required String userId,
    required String projectId,
  }) async {
    return await uploadFile(
      file: file,
      folder: 'projects/$userId',
      fileName: '${projectId}_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
  }

  // Delete file by URL
  Future<void> deleteFile(String fileUrl) async {
    try {
      final ref = _storage.refFromURL(fileUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Gagal menghapus file: $e');
    }
  }

  // Get file metadata
  Future<FullMetadata> getFileMetadata(String fileUrl) async {
    try {
      final ref = _storage.refFromURL(fileUrl);
      return await ref.getMetadata();
    } catch (e) {
      throw Exception('Gagal mengambil metadata file: $e');
    }
  }
}
