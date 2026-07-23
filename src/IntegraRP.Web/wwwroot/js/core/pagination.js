export function renderPagination(container, page, totalPages, onSelect) {
  container.replaceChildren();
  for (let index = 1; index <= totalPages; index += 1) {
    const button = document.createElement('button');
    button.type = 'button';
    button.className = index === page ? 'btn btn-primary btn-sm' : 'btn btn-outline-primary btn-sm';
    button.textContent = String(index);
    button.addEventListener('click', () => onSelect(index));
    container.appendChild(button);
  }
}
