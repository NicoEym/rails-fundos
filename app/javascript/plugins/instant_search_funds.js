var client = algoliasearch(process.env.ALGOLIASEARCH_APPLICATION_ID, process.env.ALGOLIASEARCH_API_KEY);
var index = client.initIndex('Fund');


const instantSearchFunds = () => {

  const algoliaSearch = document.querySelector("#funds_input");


  if (algoliaSearch === null) {return}
  algoliaSearch.addEventListener('keyup', (event) => {
    const drop = document.querySelector(".my-row");
    // grid.innerHTML = "";
    var keyword = event.currentTarget.value;
    const pageName = document.querySelector("#area_name");
    // if (pageName === null) {index.search(keyword, { hitsPerPage: 5, page: 0 })}
    //   {index.search(keyword, { filters: `area_name:${pageName.textContent}`, hitsPerPage: 5, page: 0 })}
    console.log(pageName.textContent);
    drop.innerHTML = "";
    if (pageName === null) {searchWithoutFilter(keyword)} {searchWithFilter(keyword, pageName.textContent)}

  //   index.search(keyword, { filters: `area_name:${pageName}`, hitsPerPage: 5, page: 0 })
  //   .then(function searchDone(content) {
  //     content.hits.forEach((hit) => {
  //       console.log(addFundCard(hit));
  //     })

  //   })
  //   .catch(function searchFailure(err) {
  //   console.error(err);
  // });
  });
};


const searchWithoutFilter = (word) => {
  index.search(word, { hitsPerPage: 5, page: 0 })
  .then(function searchDone(content) {
      content.hits.forEach((hit) => {
        console.log(addFundCard(hit));
      })

    })
    .catch(function searchFailure(err) {
    console.error(err);
  });
}

const searchWithFilter = (word, filter) => {
  index.search(word, { filters: `area_name:${filter.textContent}`, hitsPerPage: 5, page: 0 })
  .then(function searchDone(content) {
      content.hits.forEach((hit) => {
        console.log(addFundCard(hit));
      })

    })
    .catch(function searchFailure(err) {
    console.error(err);
  });
}


const  addFundCard = (json) => {
    const drop = document.querySelector(".my-row");
  drop.insertAdjacentHTML('beforeend', html(json));
};



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
