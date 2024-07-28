import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="my-modal"
export default class extends Controller {
  static targets = [ 'content', 'loading', 'contentCards', 'link' ];
  static values = { balance: String };

  connect() {
    console.log("Ok. My-Loading")
  }

  displayLoading(event) {
    this.loadingTarget.classList.remove('d-none');
    this.contentTarget.classList.add('d-none');
  }

  displayContent() {
    this.loadingTarget.classList.add('d-none');
    this.contentTarget.classList.remove('d-none');
  }

  displayCardsLoading(event) {
    // const balanceContent = document.getElementById("balance_" + cardIdValue)
    this.loadingTarget.classList.remove('d-none');
    this.contentCardsTarget.classList.add('d-none');
    // balanceContent.classList.add('d-none');
    console.log(event.detail.url)
  }

  displayContentCards() {
    // const balanceContent = document.getElementById("balance_#{cardIdValue}")
    this.loadingTarget.classList.add('d-none');
    this.contentCardsTarget.classList.remove('d-none');
    // balanceContent.classList.remove('d-none');
  }
  
}
