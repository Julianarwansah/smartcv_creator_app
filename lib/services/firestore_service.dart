import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/resume_model.dart';
import '../models/portfolio_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ==================== RESUME OPERATIONS ====================

  // Create resume
  Future<String> createResume(ResumeModel resume) async {
    try {
      final docRef = await _firestore.collection('resumes').add(resume.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Gagal membuat resume: $e');
    }
  }

  // Get resume by ID
  Future<ResumeModel?> getResume(String resumeId) async {
    try {
      final doc = await _firestore.collection('resumes').doc(resumeId).get();
      if (doc.exists) {
        return ResumeModel.fromMap({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      throw Exception('Gagal mengambil resume: $e');
    }
  }

  // Get all resumes for a user
  Future<List<ResumeModel>> getUserResumes(String uid) async {
    try {
      print('DEBUG: Querying resumes for uid: $uid');

      final querySnapshot = await _firestore
          .collection('resumes')
          .where('uid', isEqualTo: uid)
          .get();

      print('DEBUG: Found ${querySnapshot.docs.length} resumes');

      final resumes = querySnapshot.docs.map((doc) {
        print('DEBUG: Resume doc id: ${doc.id}, uid: ${doc.data()['uid']}');
        return ResumeModel.fromMap({...doc.data(), 'id': doc.id});
      }).toList();

      // Sort in memory to avoid Firestore composite index requirement
      resumes.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      print('DEBUG: Parsed ${resumes.length} resumes');
      return resumes;
    } catch (e) {
      print('DEBUG: Error getting resumes: $e');
      throw Exception('Gagal mengambil daftar resume: $e');
    }
  }

  // Update resume
  Future<void> updateResume(ResumeModel resume) async {
    try {
      await _firestore
          .collection('resumes')
          .doc(resume.id)
          .update(resume.copyWith(updatedAt: DateTime.now()).toMap());
    } catch (e) {
      throw Exception('Gagal update resume: $e');
    }
  }

  // Delete resume
  Future<void> deleteResume(String resumeId) async {
    try {
      await _firestore.collection('resumes').doc(resumeId).delete();
    } catch (e) {
      throw Exception('Gagal menghapus resume: $e');
    }
  }

  // ==================== PORTFOLIO OPERATIONS ====================

  // Create portfolio
  Future<String> createPortfolio(PortfolioModel portfolio) async {
    try {
      final docRef = await _firestore
          .collection('portfolios')
          .add(portfolio.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Gagal membuat portfolio: $e');
    }
  }

  // Get portfolio by ID
  Future<PortfolioModel?> getPortfolio(String portfolioId) async {
    try {
      final doc = await _firestore
          .collection('portfolios')
          .doc(portfolioId)
          .get();
      if (doc.exists) {
        return PortfolioModel.fromMap({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      throw Exception('Gagal mengambil portfolio: $e');
    }
  }

  // Get all portfolios for a user
  Future<List<PortfolioModel>> getUserPortfolios(String uid) async {
    try {
      final querySnapshot = await _firestore
          .collection('portfolios')
          .where('uid', isEqualTo: uid)
          .orderBy('created_at', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => PortfolioModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil daftar portfolio: $e');
    }
  }

  // Update portfolio
  Future<void> updatePortfolio(PortfolioModel portfolio) async {
    try {
      await _firestore
          .collection('portfolios')
          .doc(portfolio.id)
          .update(portfolio.copyWith(updatedAt: DateTime.now()).toMap());
    } catch (e) {
      throw Exception('Gagal update portfolio: $e');
    }
  }

  // Delete portfolio
  Future<void> deletePortfolio(String portfolioId) async {
    try {
      await _firestore.collection('portfolios').doc(portfolioId).delete();
    } catch (e) {
      throw Exception('Gagal menghapus portfolio: $e');
    }
  }
}
