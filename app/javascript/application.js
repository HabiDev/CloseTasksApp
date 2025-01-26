// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import "./direct_uploads"
import * as bootstrap from "bootstrap"
import * as ActiveStorage from "@rails/activestorage"
ActiveStorage.start()

const popoverTriggerList = document.querySelectorAll('[data-bs-toggle="popover"]')
const popoverList = [...popoverTriggerList].map(popoverTriggerEl => new bootstrap.Popover(popoverTriggerEl))

const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]')
const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl))
