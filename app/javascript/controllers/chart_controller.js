import { Controller } from '@hotwired/stimulus';
import Chart from 'chart.js/auto';

export default class extends Controller {
  static values = {
    done: Number,
    total: Number,
  };

  connect() {
    const ctx = this.element.getContext('2d');
    const remaining = this.totalValue - this.doneValue;

    this.chart = new Chart(ctx, {
      type: 'doughnut',
      data: {
        labels: ['Completed', 'Remaining'],
        datasets: [
          {
            data: [this.doneValue, remaining],
            backgroundColor: ['#0d6efd', '#e9ecef'],
            borderWidth: 0,
            hoverOffset: 4,
          },
        ],
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        cutout: '60%',
        rotation: 0,
        circumference: 360,
        animation: {
          animateScale: true,
          animateRotate: true,
        },
        plugins: {
          legend: { display: false },
          tooltip: { enabled: false },
        },
      },
    });
  }

  disconnect() {
    if (this.chart) {
      this.chart.destroy();
    }
  }
}
