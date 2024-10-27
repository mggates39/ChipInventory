
function parse_symbol(symbol)
{
  // Bail if string is empty
  if (!symbol) {
    return symbol;
  }
  // process __ for subscripts
  let newsym = '';
  if (symbol.includes('__')){
    let seen = 0
    for (let i = 0; i < symbol.length; i++) {
      if (symbol[i] == '_') {
        seen++;
        if (seen == 2) {
          newsym += '<sub>';
        }
      } else if ((symbol[i] == '/' || symbol[i] == ' ') && seen == 2) {
        newsym += '</sub>';
        seen = 0;
        newsym += symbol[i];
      } else {
        newsym += symbol[i]
      }
    }
    
    if (seen == 2) {
      newsym += '</sub>';
      seen = 0;
  ``}
  } else {
    newsym = symbol;
  }

  // Process ~ for negation
  if (newsym.includes('~')) {
    let negsym = ''
    let found = false
    for (let i = 0; i < newsym.length; i++) {
      if (newsym[i] == '~') {
        found = !found;
        if (found) {
          negsym += "<span class='neg'>"
        } else {
          negsym += '</span>'
        }
      } else if ((newsym[i] == ' ' || newsym[i] == '/') && found) {
        negsym += '</span>';
        found = false;
        negsym += newsym[i];
      } else {
        negsym += newsym[i];
      }
    }
    if (found) {
      negsym += "</span>";
    }
    newsym = negsym;
  }
  return newsym
}

module.exports = { parse_symbol};
