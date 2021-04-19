import "../css/app.scss"
import "phoenix_html"

document.querySelectorAll('table').forEach(table => {
  const wrapper = document.createElement('div');
  wrapper.className = 'table-wrapper'
  table.parentNode.insertBefore(wrapper, table);
  wrapper.appendChild(table);
});
