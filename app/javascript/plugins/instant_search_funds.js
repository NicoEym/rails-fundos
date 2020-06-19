// var client = algoliasearch(process.env.ALGOLIASEARCH_APPLICATION_ID, process.env.ALGOLIASEARCH_API_KEY);
var index = client.initIndex('Fund');


const instantSearchFunds = () => {
  // we initialize our search bar with the query selector
  const algoliaSearch = document.querySelector("#funds_input");

  // if there is a searchbar on the page then we run code below
  if (algoliaSearch === null) {return}

    // when we start we define the content of the search bar(empty) as the name to search
    var keyword = algoliaSearch.value;
    // we also get the type of funds in order to put a filter on our algolia research
    const pageName = document.querySelector("#area_name");
     // we initialize where we will input the cards
    const drop = document.querySelector(".my-row");
    // we display directly the all the funds using the content of the searchbar: nothing
    // the function below will display all the funds or only the ones corresponding to an area using
    // the content of #area_name
    searchRouter(pageName, keyword) ;


    // we put an event listener on the searchbar
    algoliaSearch.addEventListener('keyup', (event) => {
    // our keyword will be the input of the searchbar each time we insert a character
    var keyword = event.currentTarget.value;
    // we clean the cards
    drop.innerHTML = "";
     // the function below will display all the funds or only the ones corresponding to an area using
    // the content of #area_name
    searchRouter(pageName, keyword) ;
  });
};

// if the page has no title, we are on the pages with all the funds, then pageName is null and
// we do our research without filter
// else we run our research with a filter
const searchRouter = (filter, word) => {
if (filter === null)
      { searchWithoutFilter(word);}
  else
    { searchWithFilter(word, filter.textContent);}
}

// we do our research without filter
const searchWithoutFilter = (word) => {
  index.search(word, { hitsPerPage: 20, page: 0 })
  .then(function searchDone(content) {
      content.hits.forEach((hit) => {
        console.log(addFundCard(hit));
      })

    })
    .catch(function searchFailure(err) {
    console.error(err);
  });
}

// else we run our research with a filter based on the area name
const searchWithFilter = (word, filter) => {
  index.search(word, { filters: `area_name:'${filter}'`, hitsPerPage: 5, page: 0 })
  .then(function searchDone(content) {
      content.hits.forEach((hit) => {
        console.log(addFundCard(hit));
      })

    })
    .catch(function searchFailure(err) {
    console.error(err);
  });
}

// we add the cards in the row
const  addFundCard = (json) => {
    const drop = document.querySelector(".my-row");
  drop.insertAdjacentHTML('beforeend', html(json));
};


// json code
const html = (json) => {
const new_html = `
                <div class="col-xs-12 col-md-4">
                <a href="/funds/${json.id}/">
                    <div class="card" style="background-image: linear-gradient(rgba(0,0,0,0.3), rgba(0,0,0,0.3)), url(${json.photo_url});">
                       <div>
                        <h2 class="text-center">${json.name} </h2>
                      </div>
                    </div>
                  </div>
                `;
  return new_html;
};


export { instantSearchFunds };
