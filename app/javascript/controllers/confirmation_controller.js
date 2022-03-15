import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  confirm(event) {
    let confirmed = confirm("Are you sure?")

    if (!confirmed) {
      event.preventDefault()
    }
  }
}
