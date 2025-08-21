import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/adm_strings.dart';
import '../modal/adm_faq_modal.dart';

class AdmFaqController extends GetxController {
  final searchController = TextEditingController().obs;

  List detail = ['General', 'Cuenta', 'Servicios', 'Pagos'];
  RxInt selectedIndex = 0.obs;




  void selection(int index) {
    selectedIndex.value = index;
    update();
  }
  List<AdmFaqData> getCurrentFaqs() {
    switch (selectedIndex.value) {
      case 0:
        return generalFaqs;
      case 1:
        return account;
      case 2:
        return service;
      case 3:
        return adoption;
      default:
        return [];
    }
  }

  void toggleExpansion(AdmFaqData faq) {
    faq.isExpanded.value = !faq.isExpanded.value;

    List<AdmFaqData> faqsInCategory = getCurrentFaqs();

    for (int i = 0; i < faqsInCategory.length; i++) {
      if (faq != faqsInCategory[i]) {
        faqsInCategory[i].isExpanded.value = false;
      }
    }
  }
  final List<AdmFaqData> generalFaqs = [
    AdmFaqData(
      question: '¿Qué es Administra?',
      answer: admText,
    ),
    AdmFaqData(
      question: '¿Cómo funciona Administra?',
      answer: admText,
    ),
    AdmFaqData(
      question: '¿Es Administra un servicio gratuito?',
      answer: admText,
    ),
    AdmFaqData(
      question:  '¿Cómo solicito un apartamento?',
      answer: admText,
    ),
    AdmFaqData(
      question:  '¿Puedo rentar en cualquier edificio?',
      answer: admText,
    ),
    AdmFaqData(
      question:  '¿Cómo me comunico con un administrador?',
      answer: admText,
    ),
    AdmFaqData(
      question:  '¿Como gestiono mis pagos?',
      answer: admText,
    ),
    AdmFaqData(
      question:  '¿Que pasa si me atraso en mis cuotas?',
      answer: admText,
    ),
    AdmFaqData(
      question:  '¿Como finalizo un contrato de renta?',
      answer: admText,
    ),
  ];
  final List<AdmFaqData> account = [
    AdmFaqData(
      question:  '¿Cómo solicito un apartamento?',
      answer: admText,
    ),
    AdmFaqData(
      question:  '¿Puedo rentar en cualquier edificio?',
      answer: admText,
    ),
    AdmFaqData(
      question:  '¿Cómo me comunico con un administrador?',
      answer: admText,
    ),
  ];
  final List<AdmFaqData> service = [
AdmFaqData(
      question: '¿Qué es Administra?',
      answer: admText,
    ),
    AdmFaqData(
      question: '¿Cómo funciona Administra?',
      answer: admText,
    ),
    AdmFaqData(
      question: '¿Es Administra un servicio gratuito?',
      answer: admText,
    ),
    AdmFaqData(
      question:  '¿Cómo me comunico con un administrador?',
      answer: admText,
    ),
  ];
  final List<AdmFaqData> adoption = [
    AdmFaqData(
      question:  '¿Como gestiono mis pagos?',
      answer: admText,
    ),
    AdmFaqData(
      question:  '¿Que pasa si me atraso en mis cuotas?',
      answer: admText,
    ),
    AdmFaqData(
      question:  '¿Como finalizo un contrato de renta?',
      answer: admText,
    ),
  ];
}

