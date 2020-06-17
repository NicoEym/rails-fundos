const showTabs = () => {
  const elementReturn = document.getElementById('return');
  const elementRisk = document.getElementById('risk');
  const elementLiquidity = document.getElementById('liquidity');
  const elementGeral = document.getElementById('data_geral');

  const hidableElements = document.querySelectorAll('.hidable');

  const tabs = document.querySelectorAll('.tab-underlined');
  if (tabs) {
      tabs.forEach((tab) => {
      tab.addEventListener('click', (e) => {

      const hiddenElements = document.querySelectorAll('.hidden');
      const activeTab = document.querySelector('.active');
      var keyword = tab.textContent.toLowerCase();
      console.log(keyword);
      const elementToShow = document.getElementById(keyword);

      activeTab.classList.toggle('active');
      tab.classList.toggle('active');

      hidableElements.forEach((hidableElement) => {
          hidableElement.classList.add('hidden')
        });

      elementToShow.classList.remove('hidden');
      });
    });
  }
}

export { showTabs };
