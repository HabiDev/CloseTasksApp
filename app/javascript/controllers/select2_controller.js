import { Controller } from "@hotwired/stimulus"
import $ from "jquery";
import select2 from "select2";

export default class extends Controller {
  connect() {
    
    select2();

    $.fn.select2.defaults.set( 'language', { 
      // You can find all of the options in the language files provided in the
      // build. They all must be functions that return the string that should be
      // displayed.
      noResults: function () { return "Совпадений не найдено" },
      
      errorLoading: function() { return"Невозможно загрузить результаты" },
      
      inputTooLong: function(e) { 
        var r = e.input.length-e.maximum, 
        u="Пожалуйста, введите на "+r+" символ";
        return u+=n(r,"","a","ов"),u+=" меньше" },
      
      inputTooShort:  function(e) {
        var r = e.minimum-e.input.length,
        u = "Пожалуйста, введите ещё хотя бы " + r + " символ";
        return u += n(r,"","a","ов") },
      
      loadingMore: function() { return"Загрузка данных…" },
      
      maximumSelected: function(e) { 
        var r = "Вы можете выбрать не более " + e.maximum + " элемент";
        return r+=n(e.maximum,"","a","ов") },
      
      searching:function() { return "Поиск…" },
      
      removeAllItems: function() { return "Удалить все элементы" }

    })
    
    $('#single-select-division-completed').select2()
    $('#single-select-division-task').select2({ dropdownParent: $('#modalNewEdit') })
    $('#single-select-subcategory-completed').select2() 
    $('#single-select-subcategory-work').select2({ dropdownParent: $('#modalTask') })     
  }
}

