import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static values = {
    date: String,
  };

  // Change to asynchronous (async) function
  async copy() {
    try {
      // 1. Request data from server (AJAX)
      // /todos/report?date=YYYY-MM-DD
      const response = await fetch(`/todos/report?date=${this.dateValue}`, {
        headers: { Accept: 'application/json' },
      });

      if (!response.ok) throw new Error('Network response was not ok');

      // 2. Received JSON data
      const data = await response.json();
      // data = { date_str: "...", done_todos: ["todo1", "..."], next_todos: ["todo1", "..."] }

      // 3. Format lists (show 'なし' if no data)
      const doneSection =
        data.done_todos.length > 0
          ? data.done_todos.map((t) => `- ${t}`).join('\n')
          : '- なし';

      const nextSection =
        data.next_todos.length > 0
          ? data.next_todos.map((t) => `- ${t}`).join('\n')
          : '- なし';

      // 4. Assemble markdown
      const reportText = `# 日報

## 日付

${data.date_str}

---

## やったこと

${doneSection}

---

## 所感

(ここに感想を書く)

**本日の総学習時間： 約 時間**

---

## 次やること

${nextSection}
`;

      // 5. Copy to clipboard
      await navigator.clipboard.writeText(reportText);

      // 6. Success alert
      alert('Copied to clipboard! 🎉');
    } catch (err) {
      // Error handling
      console.error(err);
      alert('Error occurred while fetching data.');
    }
  }
}
