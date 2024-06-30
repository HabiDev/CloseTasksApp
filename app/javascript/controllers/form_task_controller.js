import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flatpickr"
 
export default class extends Controller {
  connect() {
    console.log(this.element)
    }

  showPrice(e) {
    // e.preventDefault()
    let el = e.target
    // console.log(el.options[el.selectedIndex].getAttribute('status'))
    console.log(e)
  }
}
