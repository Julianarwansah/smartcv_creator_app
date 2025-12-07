import 'package:flutter/foundation.dart';
import '../models/resume_model.dart';
import '../services/firestore_service.dart';
import '../services/ai_service.dart';

class ResumeProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final AIService _aiService = AIService();

  List<ResumeModel> _resumes = [];
  ResumeModel? _currentResume;
  bool _isLoading = false;
  String? _errorMessage;

  List<ResumeModel> get resumes => _resumes;
  ResumeModel? get currentResume => _currentResume;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Load all resumes for a user
  Future<void> loadUserResumes(String uid) async {
    _isLoading = true;
    notifyListeners();

    try {
      _resumes = await _firestoreService.getUserResumes(uid);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load a specific resume
  Future<void> loadResume(String resumeId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentResume = await _firestoreService.getResume(resumeId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create new resume
  Future<String?> createResume(ResumeModel resume) async {
    _isLoading = true;
    notifyListeners();

    try {
      final resumeId = await _firestoreService.createResume(resume);
      await loadUserResumes(resume.uid);
      _isLoading = false;
      notifyListeners();
      return resumeId;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  // Update resume
  Future<bool> updateResume(ResumeModel resume, {bool isSilent = false}) async {
    if (!isSilent) {
      _isLoading = true;
      notifyListeners();
    }

    // Optimistic update
    _currentResume = resume;
    if (isSilent) {
      notifyListeners();
    }

    try {
      await _firestoreService.updateResume(resume);

      // Update local list without triggering full reload
      final index = _resumes.indexWhere((r) => r.id == resume.id);
      if (index != -1) {
        _resumes[index] = resume;
      } else {
        _resumes.add(resume);
      }

      if (!isSilent) {
        _isLoading = false;
        notifyListeners();
      }
      return true;
    } catch (e) {
      if (!isSilent) {
        _errorMessage = e.toString();
        _isLoading = false;
        notifyListeners();
      }
      // Revert optimistic update if needed, but for now we keep it simple
      return false;
    }
  }

  // Delete resume
  Future<bool> deleteResume(String resumeId, String uid) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _firestoreService.deleteResume(resumeId);
      await loadUserResumes(uid);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Generate AI analysis for resume
  Future<bool> generateAIAnalysis(ResumeModel resume) async {
    _isLoading = true;
    notifyListeners();

    try {
      final analysis = await _aiService.analyzeSkills(resume);
      final updatedResume = resume.copyWith(aiAnalysis: analysis);
      await _firestoreService.updateResume(updatedResume);
      _currentResume = updatedResume;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Set current resume
  void setCurrentResume(ResumeModel? resume) {
    _currentResume = resume;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
