const show = () => {
   console.log("toto");
  const showButton = document.getElementById('show-competitors');
  const competitorRows = document.querySelectorAll('.competitor-row');
  if (showButton) {
    console.log("toto");
    showButton.addEventListener('click', (e) => {
      competitorRows.forEach((competitorRow) => {
      competitorRow.classList.toggle('hidden')
    });
    });
  }
}




export { show };
