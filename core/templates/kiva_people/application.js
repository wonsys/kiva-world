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
  // $('#lender-info').fadeOut('slow', function(){
    // $('#lender-info').queue(function () {
      // $(this).html(content);
      // centerElement('.info-left', '#lender-info');
      // centerElement('.info', '.info-right');
      // $(this).dequeue();
    // });
    // $('#lender-info').queue(function () {
      // centerElement('.info-left', '#lender-info');
      // centerElement('.info', '.info-right');
      // $(this).dequeue();
    // });
    // centerElement('.info', '.info-right');
    // $('#lender-info').fadeIn('slow');
  // });
  $('#lender-info').fadeOut('slow', function() {
    showSpinner(function(){
      $('#lender-info').queue(function (){
        $(this).html(content);
        // alert($('.info-right').height());
        setTimeout(function(){
          $('#lender-info').dequeue();
          // alert($('.info-right').height());
          hideSpinner(function(){
            $('#lender-info').fadeIn('slow');
            centerElement('.info', '.info-right');
            centerElement('.info-left img', '.info-left');
          });
        }, 2000 );
      });
    });
  })
}

function showSpinner(callback) {
  $('#spinner').fadeIn('slow', callback);
}

function hideSpinner(callback) {
  $('#spinner').fadeOut('slow', callback);
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
  $('#lender').everyTime(7000, function(i){
    nextLender();
  }, 0)
}

function pause() {
  $$play = false;
  $("#lender").stopTime();
}

function center(element_size, container_size) {
  var difference = container_size - element_size;
  if (difference > 0) {
    return parseInt((difference / 2) - (difference*0.1));
  } else {
    return 0;
  };
}

function centerElement(element, container) {
  container_height = $(container).height();
  // alert(container+' - '+container_height);
  element_height   = $(element).height();
  // alert(element+' - '+element_height);
  $(element).css('margin-top', (center(element_height, container_height) + 'px'));
}

function centerElementOnBrowser(element) {
  // browser_width  = browserWidth();
  browser_height = browserHeight();
  element_height = $(element).height();
  $(element).css('margin-top', (center(element_height, browser_height) + 'px'));
}

function browserHeight() {
  if(window.innerHeight) {
    return window.innerHeight;
  } else {
    return document.documentElement.clientHeight;
  }
}

function browserWidth() {
  if(window.innerWidth) {
    return window.innerWidth;
  } else {
    return document.documentElement.clientWidth;
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
    out += ' from ' + lender['where'];
  };
  if(lender['personal_url'] != '') {
    out += ' &middot; <span class="url"><a href="' + lender['personal_url'] + '" title="' + lender['name'] + ' personal url" target="_blank">' + lender['personal_url'] + '</a></span>';
  };
  out += '  </p>';
  if(lender['job'] != '') {
    out += '<p class="job">' + lender['job'] + '</p>';
  };
  out += '  <p class="loans">';
  out += "   I've helped " + '<span class="green">' + lender['loan_count'] + '</span> friends to achieve their dreams from <span class="green">' + lender['from'] + '</span>';
  out += '  </p>';
  if(lender['because'] != '') {
    out += '<p class="why">I do it because... ' + lender['because'] + '</p>';
  };
  out += '</div>';
  return out;
}