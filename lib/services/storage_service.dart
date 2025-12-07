import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class StorageService {
  // Get app documents directory
  Future<Directory> _getAppDirectory() async {
    return await getApplicationDocumentsDirectory();
  }

  // Create directory if not exists
  Future<Directory> _createDirectory(String folderPath) async {
    final appDir = await _getAppDirectory();
    final directory = Directory('${appDir.path}/$folderPath');

    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    return directory;
  }

  // Save file locally and return local path
  Future<String> saveFile({
    required File file,
    required String folder,
    String? fileName,
  }) async {
    try {
      final String fileExtension = path.extension(file.path);
      final String saveFileName =
          fileName ?? '${DateTime.now().millisecondsSinceEpoch}$fileExtension';

      final directory = await _createDirectory(folder);
      final String savePath = '${directory.path}/$saveFileName';

      // Copy file to app directory
      final savedFile = await file.copy(savePath);

      return savedFile.path;
    } catch (e) {
      throw Exception('Gagal menyimpan file: $e');
    }
  }

  // Save PDF locally
  Future<String> savePDF({
    required File file,
    required String userId,
    required String resumeId,
  }) async {
    return await saveFile(
      file: file,
      folder: 'resumes/$userId',
      fileName: '${resumeId}_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
  }

  // Save image locally
  Future<String> saveImage({
    required File file,
    required String userId,
    required String folder,
  }) async {
    return await saveFile(file: file, folder: '$folder/$userId');
  }

  // Save profile photo locally
  Future<String> saveProfilePhoto({
    required File file,
    required String userId,
  }) async {
    return await saveFile(
      file: file,
      folder: 'profile_photos',
      fileName: '$userId.jpg',
    );
  }

  // Save portfolio banner locally
  Future<String> savePortfolioBanner({
    required File file,
    required String userId,
    required String portfolioId,
  }) async {
    return await saveFile(
      file: file,
      folder: 'portfolios/$userId',
      fileName: '${portfolioId}_banner.jpg',
    );
  }

  // Save project image locally
  Future<String> saveProjectImage({
    required File file,
    required String userId,
    required String projectId,
  }) async {
    return await saveFile(
      file: file,
      folder: 'projects/$userId',
      fileName: '${projectId}_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
  }

  // Delete file by path
  Future<void> deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      throw Exception('Gagal menghapus file: $e');
    }
  }

  // Get file from path
  Future<File?> getFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        return file;
      }
      return null;
    } catch (e) {
      throw Exception('Gagal mengambil file: $e');
    }
  }

  // Get all files in a folder
  Future<List<File>> getFilesInFolder(String folder) async {
    try {
      final directory = await _createDirectory(folder);
      final files = directory.listSync().whereType<File>().toList();
      return files;
    } catch (e) {
      throw Exception('Gagal mengambil daftar file: $e');
    }
  }

  // Get file size
  Future<int> getFileSize(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        return await file.length();
      }
      return 0;
    } catch (e) {
      throw Exception('Gagal mengambil ukuran file: $e');
    }
  }

  // Clear all files in a folder
  Future<void> clearFolder(String folder) async {
    try {
      final directory = await _createDirectory(folder);
      if (await directory.exists()) {
        await directory.delete(recursive: true);
      }
    } catch (e) {
      throw Exception('Gagal menghapus folder: $e');
    }
  }
}
