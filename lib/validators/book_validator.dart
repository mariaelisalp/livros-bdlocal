import 'package:flutter/material.dart';

class BookValidator {

  BookValidator();

  String? validateField(TextEditingController controller) {
    if (controller.text.isEmpty) {
      return 'Este campo é obrigatório';
    } 
    return null;
  }

  String? validateYear(TextEditingController controller, int now) {
    final year = int.tryParse(controller.text);

    
    String? error = validateField(controller);

    if (error != null) {
      return error;
    }

    if (year == null || year < 1300 || year > now) {
      return "Ano de publicação inválido.";
    }
    
    return null;
  }

  String? validateSelect(String? controller){

    if(controller == null){
      return "Este campo é obrigatório";
    }

    return null;
  }
}
