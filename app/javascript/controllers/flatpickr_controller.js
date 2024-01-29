import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr";
import $ from "jquery";

import { Russian } from "flatpickr/dist/l10n/ru.js";

// Connects to data-controller="flatpickr"
 
export default class extends Controller {
  connect() {
    let config = {
      locale: Russian,
      altFormat: "d.m.Y",
      altInput: true
      // static: true
    }

    flatpickr("#start_search_date", config)
    flatpickr("#end_search_date", config)
    flatpickr("#mission_executor_limit_date", config)
    flatpickr("#mission_mission_executors_limit_date", config)
    flatpickr("#start_search_limit_date", config)
    flatpickr("#end_search_limit_date", config)

  }
}
