import { Controller } from "@hotwired/stimulus"
import * as bootstrap from "bootstrap"

// Connects to data-controller="modal-task"
export default class extends Controller {
  static targets = ['modalMission']
  connect() {
    this.modal = new bootstrap.Modal(this.modalMissionTarget)
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
