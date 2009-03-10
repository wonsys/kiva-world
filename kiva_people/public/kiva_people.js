/* === application.js === */

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

/* === corners.js === */

/*
 * jQuery Corners 0.3
 * Copyright (c) 2008 David Turnbull, Steven Wittens
 * Dual licensed under the MIT (MIT-LICENSE.txt)
 * and GPL (GPL-LICENSE.txt) licenses.
 */
jQuery.fn.corners=function(C){var N="rounded_by_jQuery_corners";var V=B(C);var F=false;try{F=(document.body.style.WebkitBorderRadius!==undefined);var Y=navigator.userAgent.indexOf("Chrome");if(Y>=0){F=false}}catch(E){}var W=false;try{W=(document.body.style.MozBorderRadius!==undefined);var Y=navigator.userAgent.indexOf("Firefox");if(Y>=0&&parseInt(navigator.userAgent.substring(Y+8))<3){W=false}}catch(E){}return this.each(function(b,h){$e=jQuery(h);if($e.hasClass(N)){return }$e.addClass(N);var a=/{(.*)}/.exec(h.className);var c=a?B(a[1],V):V;var j=h.nodeName.toLowerCase();if(j=="input"){h=O(h)}if(F&&c.webkit){K(h,c)}else{if(W&&c.mozilla&&(c.sizex==c.sizey)){M(h,c)}else{var d=D(h.parentNode);var f=D(h);switch(j){case"a":case"input":Z(h,c,d,f);break;default:R(h,c,d,f);break}}}});function K(d,c){var a=""+c.sizex+"px "+c.sizey+"px";var b=jQuery(d);if(c.tl){b.css("WebkitBorderTopLeftRadius",a)}if(c.tr){b.css("WebkitBorderTopRightRadius",a)}if(c.bl){b.css("WebkitBorderBottomLeftRadius",a)}if(c.br){b.css("WebkitBorderBottomRightRadius",a)}}function M(d,c){var a=""+c.sizex+"px";var b=jQuery(d);if(c.tl){b.css("-moz-border-radius-topleft",a)}if(c.tr){b.css("-moz-border-radius-topright",a)}if(c.bl){b.css("-moz-border-radius-bottomleft",a)}if(c.br){b.css("-moz-border-radius-bottomright",a)}}function Z(k,n,l,a){var m=S("table");var i=S("tbody");m.appendChild(i);var j=S("tr");var d=S("td","top");j.appendChild(d);var h=S("tr");var c=T(k,n,S("td"));h.appendChild(c);var f=S("tr");var b=S("td","bottom");f.appendChild(b);if(n.tl||n.tr){i.appendChild(j);X(d,n,l,a,true)}i.appendChild(h);if(n.bl||n.br){i.appendChild(f);X(b,n,l,a,false)}k.appendChild(m);if(jQuery.browser.msie){m.onclick=Q}k.style.overflow="hidden"}function Q(){if(!this.parentNode.onclick){this.parentNode.click()}}function O(c){var b=document.createElement("a");b.id=c.id;b.className=c.className;if(c.onclick){b.href="javascript:";b.onclick=c.onclick}else{jQuery(c).parent("form").each(function(){b.href=this.action});b.onclick=I}var a=document.createTextNode(c.value);b.appendChild(a);c.parentNode.replaceChild(b,c);return b}function I(){jQuery(this).parent("form").each(function(){this.submit()});return false}function R(d,a,b,c){var f=T(d,a,document.createElement("div"));d.appendChild(f);if(a.tl||a.tr){X(d,a,b,c,true)}if(a.bl||a.br){X(d,a,b,c,false)}}function T(j,i,k){var b=jQuery(j);var l;while(l=j.firstChild){k.appendChild(l)}if(j.style.height){var f=parseInt(b.css("height"));k.style.height=f+"px";f+=parseInt(b.css("padding-top"))+parseInt(b.css("padding-bottom"));j.style.height=f+"px"}if(j.style.width){var a=parseInt(b.css("width"));k.style.width=a+"px";a+=parseInt(b.css("padding-left"))+parseInt(b.css("padding-right"));j.style.width=a+"px"}k.style.paddingLeft=b.css("padding-left");k.style.paddingRight=b.css("padding-right");if(i.tl||i.tr){k.style.paddingTop=U(j,i,b.css("padding-top"),true)}else{k.style.paddingTop=b.css("padding-top")}if(i.bl||i.br){k.style.paddingBottom=U(j,i,b.css("padding-bottom"),false)}else{k.style.paddingBottom=b.css("padding-bottom")}j.style.padding=0;return k}function U(f,a,d,c){if(d.indexOf("px")<0){try{console.error("%s padding not in pixels",(c?"top":"bottom"),f)}catch(b){}d=a.sizey+"px"}d=parseInt(d);if(d-a.sizey<0){try{console.error("%s padding is %ipx for %ipx corner:",(c?"top":"bottom"),d,a.sizey,f)}catch(b){}d=a.sizey}return d-a.sizey+"px"}function S(b,a){var c=document.createElement(b);c.style.border="none";c.style.borderCollapse="collapse";c.style.borderSpacing=0;c.style.padding=0;c.style.margin=0;if(a){c.style.verticalAlign=a}return c}function D(b){try{var d=jQuery.css(b,"background-color");if(d.match(/^(transparent|rgba\(0,\s*0,\s*0,\s*0\))$/i)&&b.parentNode){return D(b.parentNode)}if(d==null){return"#ffffff"}if(d.indexOf("rgb")>-1){d=A(d)}if(d.length==4){d=L(d)}return d}catch(a){return"#ffffff"}}function L(a){return"#"+a.substring(1,2)+a.substring(1,2)+a.substring(2,3)+a.substring(2,3)+a.substring(3,4)+a.substring(3,4)}function A(h){var a=255;var d="";var b;var e=/([0-9]+)[, ]+([0-9]+)[, ]+([0-9]+)/;var f=e.exec(h);for(b=1;b<4;b++){d+=("0"+parseInt(f[b]).toString(16)).slice(-2)}return"#"+d}function B(b,d){var b=b||"";var c={sizex:5,sizey:5,tl:false,tr:false,bl:false,br:false,webkit:true,mozilla:true,transparent:false};if(d){c.sizex=d.sizex;c.sizey=d.sizey;c.webkit=d.webkit;c.transparent=d.transparent;c.mozilla=d.mozilla}var a=false;var e=false;jQuery.each(b.split(" "),function(f,j){j=j.toLowerCase();var h=parseInt(j);if(h>0&&j==h+"px"){c.sizey=h;if(!a){c.sizex=h}a=true}else{switch(j){case"no-native":c.webkit=c.mozilla=false;break;case"webkit":c.webkit=true;break;case"no-webkit":c.webkit=false;break;case"mozilla":c.mozilla=true;break;case"no-mozilla":c.mozilla=false;break;case"anti-alias":c.transparent=false;break;case"transparent":c.transparent=true;break;case"top":e=c.tl=c.tr=true;break;case"right":e=c.tr=c.br=true;break;case"bottom":e=c.bl=c.br=true;break;case"left":e=c.tl=c.bl=true;break;case"top-left":e=c.tl=true;break;case"top-right":e=c.tr=true;break;case"bottom-left":e=c.bl=true;break;case"bottom-right":e=c.br=true;break}}});if(!e){if(!d){c.tl=c.tr=c.bl=c.br=true}else{c.tl=d.tl;c.tr=d.tr;c.bl=d.bl;c.br=d.br}}return c}function P(f,d,h){var e=Array(parseInt("0x"+f.substring(1,3)),parseInt("0x"+f.substring(3,5)),parseInt("0x"+f.substring(5,7)));var c=Array(parseInt("0x"+d.substring(1,3)),parseInt("0x"+d.substring(3,5)),parseInt("0x"+d.substring(5,7)));r="0"+Math.round(e[0]+(c[0]-e[0])*h).toString(16);g="0"+Math.round(e[1]+(c[1]-e[1])*h).toString(16);d="0"+Math.round(e[2]+(c[2]-e[2])*h).toString(16);return"#"+r.substring(r.length-2)+g.substring(g.length-2)+d.substring(d.length-2)}function X(f,a,b,d,c){if(a.transparent){G(f,a,b,c)}else{J(f,a,b,d,c)}}function J(k,z,p,a,n){var h,f;var l=document.createElement("div");l.style.fontSize="1px";l.style.backgroundColor=p;var b=0;for(h=1;h<=z.sizey;h++){var u,t,q;arc=Math.sqrt(1-Math.pow(1-h/z.sizey,2))*z.sizex;var c=z.sizex-Math.ceil(arc);var w=Math.floor(b);var v=z.sizex-c-w;var o=document.createElement("div");var m=l;o.style.margin="0px "+c+"px";o.style.height="1px";o.style.overflow="hidden";for(f=1;f<=v;f++){if(f==1){if(f==v){u=((arc+b)*0.5)-w}else{t=Math.sqrt(1-Math.pow(1-(c+1)/z.sizex,2))*z.sizey;u=(t-(z.sizey-h))*(arc-w-v+1)*0.5}}else{if(f==v){t=Math.sqrt(1-Math.pow((z.sizex-c-f+1)/z.sizex,2))*z.sizey;u=1-(1-(t-(z.sizey-h)))*(1-(b-w))*0.5}else{q=Math.sqrt(1-Math.pow((z.sizex-c-f)/z.sizex,2))*z.sizey;t=Math.sqrt(1-Math.pow((z.sizex-c-f+1)/z.sizex,2))*z.sizey;u=((t+q)*0.5)-(z.sizey-h)}}H(z,o,m,n,P(p,a,u));m=o;var o=m.cloneNode(false);o.style.margin="0px 1px"}H(z,o,m,n,a);b=arc}if(n){k.insertBefore(l,k.firstChild)}else{k.appendChild(l)}}function H(c,a,e,d,b){if(d&&!c.tl){a.style.marginLeft=0}if(d&&!c.tr){a.style.marginRight=0}if(!d&&!c.bl){a.style.marginLeft=0}if(!d&&!c.br){a.style.marginRight=0}a.style.backgroundColor=b;if(d){e.appendChild(a)}else{e.insertBefore(a,e.firstChild)}}function G(c,o,l,h){var f=document.createElement("div");f.style.fontSize="1px";var a=document.createElement("div");a.style.overflow="hidden";a.style.height="1px";a.style.borderColor=l;a.style.borderStyle="none solid";var m=o.sizex-1;var j=o.sizey-1;if(!j){j=1}for(var b=0;b<o.sizey;b++){var n=m-Math.floor(Math.sqrt(1-Math.pow(1-b/j,2))*m);if(b==2&&o.sizex==6&&o.sizey==6){n=2}var k=a.cloneNode(false);k.style.borderWidth="0 "+n+"px";if(h){k.style.borderWidth="0 "+(o.tr?n:0)+"px 0 "+(o.tl?n:0)+"px"}else{k.style.borderWidth="0 "+(o.br?n:0)+"px 0 "+(o.bl?n:0)+"px"}h?f.appendChild(k):f.insertBefore(k,f.firstChild)}if(h){c.insertBefore(f,c.firstChild)}else{c.appendChild(f)}}};

/* === mousewheel.js === */

/* Copyright (c) 2006 Brandon Aaron (brandon.aaron@gmail.com || http://brandonaaron.net)
 * Dual licensed under the MIT (http://www.opensource.org/licenses/mit-license.php)
 * and GPL (http://www.opensource.org/licenses/gpl-license.php) licenses.
 * Thanks to: http://adomas.org/javascript-mouse-wheel/ for some pointers.
 * Thanks to: Mathias Bank(http://www.mathias-bank.de) for a scope bug fix.
 *
 * $LastChangedDate: 2007-12-14 23:57:10 -0600 (Fri, 14 Dec 2007) $
 * $Rev: 4163 $
 *
 * Version: 3.0
 * 
 * Requires: $ 1.2.2+
 */
eval(function(p,a,c,k,e,r){e=function(c){return(c<a?'':e(parseInt(c/a)))+((c=c%a)>35?String.fromCharCode(c+29):c.toString(36))};if(!''.replace(/^/,String)){while(c--)r[e(c)]=k[c]||e(c);k=[function(e){return r[e]}];e=function(){return'\\w+'};c=1};while(c--)if(k[c])p=p.replace(new RegExp('\\b'+e(c)+'\\b','g'),k[c]);return p}('(5($){$.6.j.4={L:5(){9 b=$.6.j.4.i;7($.8.f)$(2).o(\'y.4\',5(a){$.d(2,\'h\',{x:a.x,l:a.l,s:a.s,r:a.r})});7(2.q)2.q(($.8.f?\'v\':\'4\'),b,n);m 2.w=b},D:5(){9 a=$.6.j.4.i;$(2).k(\'y.4\');7(2.u)2.u(($.8.f?\'v\':\'4\'),a,n);m 2.w=5(){};$.A(2,\'h\')},i:5(a){9 c=U.T.S.P(O,1);a=$.6.N(a||M.6);$.t(a,$.d(2,\'h\')||{});9 b=0,K=J;7(a.e)b=a.e/I;7(a.p)b=-a.p/3;7($.8.H)b=-a.e;a.d=a.d||{};a.G="4";c.z(b);c.z(a);g $.6.F.E(2,c)}};$.Q.t({4:5(a){g a?2.o("4",a):2.R("4")},C:5(a){g 2.k("4",a)}})})(B);',57,57,'||this||mousewheel|function|event|if|browser|var||||data|wheelDelta|mozilla|return|mwcursorposdata|handler|special|unbind|pageY|else|false|bind|detail|addEventListener|clientY|clientX|extend|removeEventListener|DOMMouseScroll|onmousewheel|pageX|mousemove|unshift|removeData|jQuery|unmousewheel|teardown|apply|handle|type|opera|120|true|returnValue|setup|window|fix|arguments|call|fn|trigger|slice|prototype|Array'.split('|'),0,{}))

/* === scrollable.js === */

/**
 * jquery.scrollable 1.0.2. Put your HTML scroll.
 * 
 * Copyright (c) 2009 Tero Piirainen
 * http://flowplayer.org/tools/scrollable.html
 *
 * Dual licensed under MIT and GPL 2+ licenses
 * http://www.opensource.org/licenses
 *
 * Launch  : March 2008
 * Version : 1.0.2 - Tue Feb 24 2009 10:52:06 GMT-0000 (GMT+00:00)
 */
eval(function(p,a,c,k,e,r){e=function(c){return(c<a?'':e(parseInt(c/a)))+((c=c%a)>35?String.fromCharCode(c+29):c.toString(36))};if(!''.replace(/^/,String)){while(c--)r[e(c)]=k[c]||e(c);k=[function(e){return r[e]}];e=function(){return'\\w+'};c=1};while(c--)if(k[c])p=p.replace(new RegExp('\\b'+e(c)+'\\b','g'),k[c]);return p}('(3($){3 1d(a,c,d,e){6 b=a[c];7($.16(b)){1X{4 b.10(d,e)}1G(14){7(a.1e){1e("2c 25 A."+c+": "+14)}L{20 14;}4 Q}}4 B}6 u=C;3 1o(l,r){6 o=8;7(!u){u=o}6 j=!r.1z;6 q=$(r.1a,l);6 s=0;6 h=l.S(r.17).y(0);6 n=l.S(r.R).y(0);6 m=l.S(r.H).y(0);6 t=l.S(r.P).y(0);6 k=l.S(r.O).y(0);$.1r(o,{1P:3(){4[1,0,1]},1L:3(){4 s},1J:3(){4 r},x:3(){4 o.D().9()},1l:3(){4 M.15(8.x()/r.9)},Z:3(){4 M.15(s/r.9)},1C:3(){4 l},1A:3(){4 q},D:3(){4 q.T()},K:3(i,a,f){a=a||r.1c;7($.16(a)){f=a;a=r.1c}7(i<0){i=0}7(i>o.x()-r.9){4 o}6 e=o.D().y(i);7(!e.1b){4 o}7(1d(r,"1w",o,i)===Q){4 o}7(j){6 b=-(e.28(B)*i);q.1x({24:b},a,r.19,f?3(){f.10(o)}:C)}L{6 c=-(e.23(B)*i);q.1x({22:c},a,r.19,f?3(){f.10(o)}:C)}7(h.1b){6 g=r.w;6 d=M.15(i/r.9);d=M.21(d,h.T().1b-1);h.T().G(g).y(d).v(g)}7(i===0){n.X(t).v(r.E)}L{n.X(t).G(r.E)}7(i>=o.x()-r.9){m.X(k).v(r.E)}L{m.X(k).G(r.E)}u=o;s=i;1d(r,"1v",o,i);4 o},F:3(b,c,d){6 a=s+b;7(r.1u&&a>(o.x()-r.9)){a=0}4 8.K(a,c,d)},H:3(a,b){4 8.F(1,a,b)},R:3(a,b){4 8.F(-1,a,b)},1Z:3(a,b,c){4 8.F(r.9*a,b,c)},N:3(b,a,d){6 e=r.9;6 f=e*b;6 c=f+e>=8.x();7(c){f=8.x()-r.9}4 8.K(f,a,d)},P:3(a,b){4 8.N(8.Z()-1,a,b)},O:3(a,b){4 8.N(8.Z()+1,a,b)},1W:3(a,b){4 8.K(0,a,b)},1V:3(a,b){4 8.K(8.x()-r.9,a,b)},1U:3(){4 13()},z:3(f,c,e){6 d=o.D().y(f);6 g=r.w;7(!d.1T(g)&&(f>=0||f<8.x())){o.D().G(g);d.v(g);6 a=M.1S(r.9/2);6 b=f-a;7(b>o.x()-r.9){b--}7(b!==f){4 8.K(b,c,e)}}4 o}});7($.16($.1R.1s)){l.12("1s.A",3(e,a){6 b=$.1Q.1O?1:-1;o.F(a>0?b:-b,1N);4 Q})}n.v(r.E).z(3(){o.R()});m.z(3(){o.H()});k.z(3(){o.O()});t.v(r.E).z(3(){o.P()});7(r.1q){$(1M).1K("1n.A").12("1n.A",3(a){6 b=u;7(!b){4}7(j&&(a.J==1m||a.J==1I)){b.F(a.J==1m?-1:1);4 a.11()}7(!j&&(a.J==1p||a.J==1H)){b.F(a.J==1p?-1:1);4 a.11()}4 B})}3 13(){h.U(3(){6 b=$(8);7(b.1F(":1k")||b.I("1j")==o){b.1k();b.I("1j",o);1E(6 i=0;i<o.1l();i++){6 c=$("<"+r.1i+"/>").W("V",i).z(3(e){6 a=$(8);a.1D().T().G(r.w);a.v(r.w);o.N(a.W("V"));4 e.11()});7(i===0){c.v(r.w)}b.1B(c)}}L{6 d=b.T();d.U(3(i){6 a=$(8);a.W("V",i);7(i===0){a.v(r.w)}a.z(3(){b.1Y("."+r.w).G(r.w);a.v(r.w);o.N(a.W("V"))})})}});7(r.1h){o.D().U(3(a,b){6 c=$(8);7(!c.I("1t")){c.12("z.A",3(){o.z(a)});c.I("1t",B)}})}7(r.Y){o.D().1g(3(){$(8).v(r.Y)},3(){$(8).G(r.Y)})}4 o}13();6 p=C;3 1f(){p=2h(3(){o.H()},r.18)}7(r.18>0){l.1g(3(){2g(p)},3(){1f()});1f()}}1y.2e.A=3(d){6 c=8.y(2d d==\'2b\'?d:0).I("A");7(c){4 c}6 b={9:5,1z:Q,1h:B,1u:Q,18:0,1c:2a,1q:B,w:\'29\',E:\'27\',Y:C,19:\'2f\',1a:\'.1a\',R:\'.R\',H:\'.H\',P:\'.P\',O:\'.O\',17:\'.17\',1i:\'a\',1w:C,1v:C,1e:B};$.1r(b,d);8.U(3(){6 a=26 1o($(8),b);$(8).I("A",a)});4 8}})(1y);',62,142,'|||function|return||var|if|this|size||||||||||||||||||||||addClass|activeClass|getSize|eq|click|scrollable|true|null|getItems|disabledClass|move|removeClass|next|data|keyCode|seekTo|else|Math|setPage|nextPage|prevPage|false|prev|siblings|children|each|href|attr|add|hoverClass|getPageIndex|call|preventDefault|bind|load|error|ceil|isFunction|navi|interval|easing|items|length|speed|fireEvent|alert|setTimer|hover|clickable|naviItem|me|empty|getPageAmount|37|keypress|Scrollable|38|keyboard|extend|mousewheel|set|loop|onSeek|onBeforeSeek|animate|jQuery|vertical|getItemWrap|append|getRoot|parent|for|is|catch|40|39|getConf|unbind|getIndex|window|50|opera|getVersion|browser|fn|floor|hasClass|reload|end|begin|try|find|movePage|throw|min|top|outerHeight|left|calling|new|disabled|outerWidth|active|400|number|Error|typeof|prototype|swing|clearInterval|setInterval'.split('|'),0,{}))

/* === timers.js === */

/**
 * jQuery.timers - Timer abstractions for jQuery
 * Written by Blair Mitchelmore (blair DOT mitchelmore AT gmail DOT com)
 * Licensed under the WTFPL (http://sam.zoy.org/wtfpl/).
 * Date: 2009/02/08
 *
 * @author Blair Mitchelmore
 * @version 1.1.2
 *
 **/

jQuery.fn.extend({
  everyTime: function(interval, label, fn, times, belay) {
    return this.each(function() {
      jQuery.timer.add(this, interval, label, fn, times, belay);
    });
  },
  oneTime: function(interval, label, fn) {
    return this.each(function() {
      jQuery.timer.add(this, interval, label, fn, 1);
    });
  },
  stopTime: function(label, fn) {
    return this.each(function() {
      jQuery.timer.remove(this, label, fn);
    });
  }
});

jQuery.event.special

jQuery.extend({
  timer: {
    global: [],
    guid: 1,
    dataKey: "jQuery.timer",
    regex: /^([0-9]+(?:\.[0-9]*)?)\s*(.*s)?$/,
    powers: {
      // Yeah this is major overkill...
      'ms': 1,
      'cs': 10,
      'ds': 100,
      's': 1000,
      'das': 10000,
      'hs': 100000,
      'ks': 1000000
    },
    timeParse: function(value) {
      if (value == undefined || value == null)
        return null;
      var result = this.regex.exec(jQuery.trim(value.toString()));
      if (result[2]) {
        var num = parseFloat(result[1]);
        var mult = this.powers[result[2]] || 1;
        return num * mult;
      } else {
        return value;
      }
    },
    add: function(element, interval, label, fn, times, belay) {
      var counter = 0;
      
      if (jQuery.isFunction(label)) {
        if (!times) 
          times = fn;
        fn = label;
        label = interval;
      }
      
      interval = jQuery.timer.timeParse(interval);

      if (typeof interval != 'number' || isNaN(interval) || interval <= 0)
        return;

      if (times && times.constructor != Number) {
        belay = !!times;
        times = 0;
      }
      
      times = times || 0;
      belay = belay || false;
      
      var timers = jQuery.data(element, this.dataKey) || jQuery.data(element, this.dataKey, {});
      
      if (!timers[label])
        timers[label] = {};
      
      fn.timerID = fn.timerID || this.guid++;
      
      var handler = function() {
        if (belay && this.inProgress) 
          return;
        this.inProgress = true;
        if ((++counter > times && times !== 0) || fn.call(element, counter) === false)
          jQuery.timer.remove(element, label, fn);
        this.inProgress = false;
      };
      
      handler.timerID = fn.timerID;
      
      if (!timers[label][fn.timerID])
        timers[label][fn.timerID] = window.setInterval(handler,interval);
      
      this.global.push( element );
      
    },
    remove: function(element, label, fn) {
      var timers = jQuery.data(element, this.dataKey), ret;
      
      if ( timers ) {
        
        if (!label) {
          for ( label in timers )
            this.remove(element, label, fn);
        } else if ( timers[label] ) {
          if ( fn ) {
            if ( fn.timerID ) {
              window.clearInterval(timers[label][fn.timerID]);
              delete timers[label][fn.timerID];
            }
          } else {
            for ( var fn in timers[label] ) {
              window.clearInterval(timers[label][fn]);
              delete timers[label][fn];
            }
          }
          
          for ( ret in timers[label] ) break;
          if ( !ret ) {
            ret = null;
            delete timers[label];
          }
        }
        
        for ( ret in timers ) break;
        if ( !ret ) 
          jQuery.removeData(element, this.dataKey);
      }
    }
  }
});

jQuery(window).bind("unload", function() {
  jQuery.each(jQuery.timer.global, function(index, item) {
    jQuery.timer.remove(item);
  });
});

