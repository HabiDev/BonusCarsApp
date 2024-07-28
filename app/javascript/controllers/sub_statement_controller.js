import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="my-modal"
export default class extends Controller {
  static targets = [ 'bonus' ]

  connect() {
    console.log("Ok");
    this.bonusTarget.contentEditable = true
  }
  
}
