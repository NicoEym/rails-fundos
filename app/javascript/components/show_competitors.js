const show = () => {
  const showButton = document.getElementById('show-competitors');
  const competitorRows = document.querySelectorAll('.competitor-data');
  if (showButton) {
    showButton.addEventListener('click', (e) => {
      competitorRows.forEach((competitorRow) => {
      competitorRow.classList.toggle('hidden')
    });
    });
  }
}

export { show };
