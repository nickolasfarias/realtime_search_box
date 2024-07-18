import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "input" ]

  searchQuery() {
    const query = this.inputTarget.value;
    const save_search_query_url = this.element.dataset.saveSearchQueryUrl;

    this.userTyping(query, save_search_query_url)
  }

  saveSearchQuery(query, save_search_query_url) {
    fetch(save_search_query_url, {
      method: 'POST',
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
      },
      body: JSON.stringify({ query: query })
    }).then(response => {
      return
    })
  }

  userTyping(query, save_search_query_url) {
    if (query.length === 0) {
      this.saveSearchQuery('', save_search_query_url)
      return;
    }

    this.saveSearchQuery(query, save_search_query_url)
  }
}
