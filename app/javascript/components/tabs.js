const showTabs = () => {
  // we select the element that can be hidden
  const hidableElements = document.querySelectorAll('.hidable');
  // we select all the tabs
  const tabs = document.querySelectorAll('.tab-underlined');

  if (tabs) {
    // we add an event listener on each tab on click
    tabs.forEach((tab) => {
    tab.addEventListener('click', (e) => {

    // we check which tab is active
    const activeTab = document.querySelector('.active');
    // the name of the tab is used as a keyword to unhide items with ID = keyword
    var keyword = tab.textContent.toLowerCase();
    const elementToShow = document.getElementById(keyword);

    // we activate the tab we clicked on and desactivate the one that was activated
    activeTab.classList.toggle('active');
    tab.classList.toggle('active');

    // we hide all the hidable element...
    hidableElements.forEach((hidableElement) => {
        hidableElement.classList.add('hidden')
      });
    // ... and unhide all the elements where ID = keyword
    elementToShow.classList.remove('hidden');
    });
    });
  }
}

export { showTabs };
