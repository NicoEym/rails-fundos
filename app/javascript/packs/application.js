import "bootstrap";
//= require algolia/v3/algoliasearch.min

import { instantSearchFunds } from '../plugins/instant_search_funds.js';
import { show } from '../components/show_competitors';
import { showTabs } from '../components/tabs';

show();
// instantSearchFunds();
showTabs();
