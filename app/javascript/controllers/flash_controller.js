import { Controller } from "@hotwired/stimulus";
import $ from "jquery";

// Connects to data-controller="flash"
 
export default class extends Controller {
  connect() {
    window.setTimeout(function() {
      $(".alert").fadeTo(500, 0).slideUp(500, function(){
          $(this).remove(); 
      });
    }, 4000);
  }

}
