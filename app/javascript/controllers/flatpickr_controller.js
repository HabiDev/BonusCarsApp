import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr";

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
    console.log("Ok")

    flatpickr(".card-fan", config)
  }
}
