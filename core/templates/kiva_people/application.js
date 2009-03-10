var $$data;
var $$index;
var $$play;

if (!Array.prototype.shuffle) {
  Array.prototype.shuffle = function() {
    var v = this.concat();
    for(var j, x, i = v.length; i; j = parseInt(Math.random() * i), x = v[--i], v[i] = v[j], v[j] = x);
    return v;
  };
}

function initialize(data) {
  $$data = data.shuffle();
  $$index = 0;
  nextLender();
  play();
}

function nextLender() {
  $$index += 1;
  length = $$data.length;
  if($$index >= length) {
    $$index = 0;
  }
  showLender(createContentForSingleLender($$data[$$index]));
}

function previousLender() {
  $$index -= 1;
  if($$index < 0) {
    $$index = $$data.length - 1;
  }
  showLender(createContentForSingleLender($$data[$$index]));
}

function showLender(content) {
  $('#lender-info').fadeOut('slow', function(){
    $('#lender-info').html(content);
    $('#lender-info').fadeIn('slow');
  });
}

function play_or_pause() {
  if($$play) {
    pause();
  } else {
    play();
  };
}

function play() {
  $$play = true;
  $('#lender').everyTime(2000, function(i){
    nextLender();
  }, 0)
}

function pause() {
  $$play = false;
  $("#lender").stopTime();
}

function centerElementOnBrowser(element) {
  browser_width  = browserWidth();
  browser_height = browserHeight();
  // $('body').height(browser_height);
  // $('body').width(browser_width);

  element_height = $(element).height();
  difference = browser_height - element_height
  margin_top = parseInt((difference / 2) - (difference*0.1))
  $(element).css('margin-top', (margin_top + 'px'));  
}

function browserHeight() {
  if(window.innerHeight) {
    return window.innerHeight;
  } else {
    return document.documentElement.clientHeight
  }
}

function browserWidth() {
  if(window.innerWidth) {
    return window.innerWidth;
  } else {
    return document.documentElement.clientWidth
  }
}

function createContentForSingleLender(lender) {
  out =  '<div class="info-left">';
  out += ' <img src="' + lender['image_url'] + '" title="' + lender['name'] + ' image" alt="' + lender['name'] + ' image" />';
  out += '</div>';
  out += '<div class="info-right">';
  out += ' <div class="info">';
  out += '  <p class="name">';
  out += "   I'm " + '<a href="' + lender['url'] + '" title="' + lender['name'] + ' on Kiva.org" target="_blank">' + lender['name'] + '</a>';
  if(lender['where'] != '') {
    out += ' from ' + lender['where']
  }
  if(lender['personal_url'] != '') {
    out += '&middot; <span class="url"><a href="' + lender['personal_url'] + '" title="' + lender['name'] + ' personal url" target="_blank">' + lender['personal_url'] + '</a></span>'
  }
  out += '  </p>';
  if(lender['job'] != '') {
    out += '<p class="job">' + lender['job'] + '</p>'
  }
  out += '  <p class="loans">';
  out += "   I've helped " + '<span class="green">' + lender['loan_count'] + '</span> friends to achieve their dreams from <span class="green">' + lender['from'] + '</span>';
  out += '  </p>';
  if(lender['because'] != '') {
    out += '<p class="why">I do it because... ' + lender['because'] + '</p>'
  }
  return out;
}