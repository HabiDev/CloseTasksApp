import { Controller } from "@hotwired/stimulus"
import * as bootstrap from "bootstrap"

export default class extends Controller {
  static targets = ['modalSmall']
  connect() {      
    this.modal = new bootstrap.Modal(this.modalSmallTarget)
  }

  open() {
    if (!this.modal.isOpened) {
      this.modal.show()
    }
  }

  close(event) {
    if (event.detail.success) {
      this.modal.hide()
    }
  }

  hideModal() {
    this.modal.hide()
  }
}