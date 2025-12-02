import { Controller } from '@hotwired/stimulus';
import { Offcanvas } from 'bootstrap';

export default class extends Controller {
  connect() {
    console.log('Offcanvas Connected!');

    // 1. Initialize offcanvas instance
    this.offcanvas = new Offcanvas(this.element);

    // 2. Show on screen (start slide animation)
    this.offcanvas.show();
  }

  disconnect() {
    // 3. When the offcanvas is removed from the screen (e.g., clicking another date), clean up the offcanvas instance
    if (this.offcanvas) {
      this.offcanvas.hide();
    }
  }
}
