import 'package:flutter/foundation.dart';
import '../models/portfolio_model.dart';
import '../services/firestore_service.dart';
import '../services/ai_service.dart';

class PortfolioProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final AIService _aiService = AIService();

  List<PortfolioModel> _portfolios = [];
  PortfolioModel? _currentPortfolio;
  bool _isLoading = false;
  String? _errorMessage;

  List<PortfolioModel> get portfolios => _portfolios;
  PortfolioModel? get currentPortfolio => _currentPortfolio;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Load all portfolios for a user
  Future<void> loadUserPortfolios(String uid) async {
    _isLoading = true;
    notifyListeners();

    try {
      _portfolios = await _firestoreService.getUserPortfolios(uid);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load a specific portfolio
  Future<void> loadPortfolio(String portfolioId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentPortfolio = await _firestoreService.getPortfolio(portfolioId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create new portfolio
  Future<String?> createPortfolio(PortfolioModel portfolio) async {
    _isLoading = true;
    notifyListeners();

    try {
      final portfolioId = await _firestoreService.createPortfolio(portfolio);
      await loadUserPortfolios(portfolio.uid);
      _isLoading = false;
      notifyListeners();
      return portfolioId;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  // Update portfolio
  Future<bool> updatePortfolio(PortfolioModel portfolio) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _firestoreService.updatePortfolio(portfolio);
      await loadUserPortfolios(portfolio.uid);
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

  // Delete portfolio
  Future<bool> deletePortfolio(String portfolioId, String uid) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _firestoreService.deletePortfolio(portfolioId);
      await loadUserPortfolios(uid);
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

  // Generate AI summary for portfolio
  Future<bool> generateAISummary(PortfolioModel portfolio) async {
    _isLoading = true;
    notifyListeners();

    try {
      final summary = await _aiService.generatePortfolioSummary(portfolio);
      final updatedPortfolio = portfolio.copyWith(aiSummary: summary);
      await _firestoreService.updatePortfolio(updatedPortfolio);
      _currentPortfolio = updatedPortfolio;
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

  // Set current portfolio
  void setCurrentPortfolio(PortfolioModel? portfolio) {
    _currentPortfolio = portfolio;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
