import { Controller } from "@hotwired/stimulus"
import $ from "jquery";
import select2 from "select2";

export default class extends Controller {

  static targets = [ "workload", "inputWorkload", "selectedSubDepartment", "selectExecutor" ]
  
  initialize() {

    select2();

  }

  selectedSubDepartmentTargetConnected(element) {
    this.element.setAttribute("data-action", "change->select2#loadExecutors");

    $('#single-select-sub-department-task').on('select2:select', function () {
      let event = new Event('change', { bubbles: true }); // fire a native event
      this.dispatchEvent(event);
    });  
  }

  selectExecutorTargetConnected() {
    if ( this.element.value === "") {
      this.element.disabled = true
    } else { 
      this.element.disabled = false
    };     
  }

  connect() {
    $.fn.select2.defaults.set( 'language', { 
      // You can find all of the options in the language files provided in the
      // build. They all must be functions that return the string that should be
      // displayed.
      noResults: function () { return "Совпадений не найдено" },
      
      errorLoading: function() { return"Невозможно загрузить результаты" },
      
      inputTooLong: function(e) { 
        var r = e.input.length-e.maximum, 
        u = "Пожалуйста, введите на " + r + " символ";
        return u += n(r, "", "a", "ов"), u += " меньше" },
      
      inputTooShort:  function(e) {
        var r = e.minimum-e.input.length,
        u = "Пожалуйста, введите ещё хотя бы " + r + " символ";
        return u += n(r,"","a","ов") },
      
      loadingMore: function() { return"Загрузка данных…" },
      
      maximumSelected: function(e) { 
        var r = "Вы можете выбрать не более " + e.maximum + " элемент";
        return r += n(e.maximum,"","a","ов") },
      
      searching: function() { return "Поиск…" },
      
      removeAllItems: function() { return "Удалить все элементы" }      

    });

    $('#single-select-division-completed').select2();
    $('#single-select-division-task').select2({ dropdownParent: $('#modalNewEdit') });
    $('#single-select-subcategory-completed').select2();

    $('#single-select-subcategory-completed').on('select2:select', function () {
      let event = new Event('change', { bubbles: true }); // fire a native event
      this.dispatchEvent(event);
    });

    $('#single-select-subcategory-work').select2({ dropdownParent: $('#modalTask') }); 
    $('#single-select-division-task-search').select2();
    $('#single-select-division-comp_task-search').select2();
    $('#single-select-user-comp_task-search').select2(); 
    $('#single-select-sub_category-comp_task-search').select2(); 
    $('#single-select-category-comp_task-search').select2(); 
    $('#single-select-user-missions-search').select2(); 
    $('#single-select-sub_category-task-search').select2();
    $('#single-select-executor-task').select2();
    $('#single-select-sub-department-task').select2();
    $('#single-select-division-mission').select2(); 
    
    
    
    this.showWorkload();   

  }

  showWorkload(e) {
    let $isWorkload = $('#single-select-subcategory-completed').find(':selected').attr('status');
    
    if ( this.hasInputWorkloadTarget ) {
      if ( $isWorkload === 'true' ) { 
        this.inputWorkloadTarget.classList.remove('d-none'); 
      } else { 
        this.inputWorkloadTarget.classList.add('d-none');
      }
    }
  }
  
  loadExecutors() {

    const selectedSubDepartment = this.element.options[this.element.selectedIndex].value
        
    if ( selectedSubDepartment ) {
      $.ajax({
        url: `/users/fetch_department?sub_department=${selectedSubDepartment}`,
        method: 'GET',
        success: function(usersDeratment) {
          // console.log(usersDeratment)
          const $select = $('#single-select-executor-task');
  
          $select.html('');
          $select.append("<option value=''>" + "</option>");
  
          for(let i = 0; i <= usersDeratment.length - 1; i++) {
            $select.append("<option value=\"" + usersDeratment[i].id + "\">" + usersDeratment[i].text + "</option>");
          }
  
          $select.attr("disabled", false);
  
        },
        error: function (data) {
            console.log(data);
        }
      })
    } else {
      $select.attr("disabled", true);
    }
  }  
}



