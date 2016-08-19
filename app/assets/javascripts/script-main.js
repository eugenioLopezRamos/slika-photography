var main = function() {
//sets up the default presentation of the site. Most of these should probably be done on the css - will see later.  
  //$('#homeTab').css("background-color", "#111");
  
var activeTabValue = window.location.pathname.replace('/', '') + 'Tab'; //used to manage the state of the different tabs

var stateObject = {// initializes the state object for use in the nav menu handler
state: activeTabValue.replace('Tab', 'State'),

};
var scheduled = false; // this is used to delay applying the state changes so the page doesnt get messed up - src= http://eloquentjavascript.net/14_event.html  - Thanks! 

history.replaceState(stateObject, "Leonardo Antonio PhotoArt", ""); //The page uses the history API for the tabs. This line of code is used for consistency, I wanted to declare the initial state of the page instead of using the browser's default.
updateState(stateObject);

function initialFormat() { //this function is used on load, and when resetting the elements' styling, for example on the resize event listener


}

//al finalizar load se debe determinar la activeTab de manera dinamica, y mandar una orden de replaceState que llama a la function updateState para 
//invocar al eventHandler apropiado para la tab
console.log(window.location);

initialFormat();
var prevHeight = 0; //this variable defines the starting size of the menu on mobile, it needs to be outside the menuToggle function because otherwise it cannot be changed when clicking a menu item, so when you click a menu item
//and then slide down the menu will start growing from where it was, not from zero.

var currentOrientation = window.orientation; // 0 = portrait, -90 || 90 = landscape, undefined = device doesn't support rotation - used on event listeners that style things according to orientation.

var clientWidth = document.documentElement.clientWidth; //width of client, used for several calculations later (for example, the menu height on phone size)

if (!Array.prototype.findIndex) { //findIndex polyfill for IE source: MDN - https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Array/findIndex
  Array.prototype.findIndex = function(predicate) {
    if (this === null) {
      throw new TypeError('Array.prototype.findIndex called on null or undefined');
    }
    if (typeof predicate !== 'function') {
      throw new TypeError('predicate must be a function');
    }
    var list = Object(this);
    var length = list.length >>> 0;
    var thisArg = arguments[1];
    var value;

    for (var i = 0; i < length; i++) {
      value = list[i];
      if (predicate.call(thisArg, value, i, list)) {
        return i;
      }
    }
    return -1;
  };
}  

  
window.addEventListener("resize", function() { //handles resizing when changing screen orientation
  document.getElementById("menu").removeAttribute("style");
  document.getElementById("header").removeAttribute("style");
  document.getElementsByClassName("active-Tab")[0].removeAttribute("style");
if(currentOrientation !== window.orientation) { //if this evaluates to true, it means there's been a resize with no orientation change made, which means
//that the user is focus-ing on an input/textarea in the "Contact Us" tab, and that is handled differently, in the contactFormHandler function

var header = document.getElementById("headerBackground");
var jumbotron = document.getElementById("jumbotron");
var bottomBackground = document.getElementById("bottomBackground");
var contactButton = document.getElementById("contactButton"); 
var contactText = document.getElementById("contactText");
var aboutButton = document.getElementById("aboutButton");
var contactForm = document.getElementById("contactForm");
var topHr = document.getElementById("topHr");
var bottomHr = document.getElementById("bottomHr");


currentOrientation = window.orientation;   

var contentTabs = (function() { //array with all elements with class "content-Tabs" - works kind of like $('.content-Tabs')
    var allContentTabs = [];
    allContentTabs = Array.prototype.slice.call(document.getElementsByClassName("content-Tabs")); //array with all elements with the 
    // "content-Tabs" class
    return allContentTabs;
})();//contentTabs close

if(currentOrientation !== 0 && clientWidth < 641) { //orientation = landscape and width < 641px which represents all phones http://mydevice.io/devices/


[header, topHr, bottomHr, bottomBackground].map(function(index) {
index.style.display = "none";    
});

jumbotron.style.height = "100vh";
jumbotron.style.width = "100vw";
jumbotron.style.maxHeight = "100vh";
jumbotron.style.maxWidth = "100vw";


contentTabs.map(function(element, array, index) { //if this is not done, bad things happen to the contact tab.
element.style.height = "100vh";  
element.style.width = "100vw";
});

document.getElementById("contactContent").removeAttribute("style");
contactButton.style.animation = "none"; //this makes the Contact Us tab layout return to the css default when changing screen orientation
contactText.style.animation = "none";
aboutButton.style.animation = "none";
contactForm.style.animation = "none"; 

 
}

if(currentOrientation == 0 && clientWidth < 641) {
document.getElementById("contactContent").scrollTop = 0;
[header,topHr, jumbotron, bottomHr, bottomBackground].map(function(index) {
window.scrollTo(0,0);
index.removeAttribute("style");
});

contentTabs.map(function(element, array, index) { //if this is not done, bad things happen to the contact tab.
element.removeAttribute("style");    

});

//updateState(stateObject.state, 0); //shows the current tab

initialFormat(); //sets the initial styling.

} //closes if == portrait

}    
});

function homeTabHandler(){ 
    
var setBigThumbEvtHandler = 1;  

function stopScroll(event) {
    event.stopPropagation();
    event.preventDefault();
}

function bigThumbEvtHandler() {

setBigThumbEvtHandler = 0; 

document.getElementById("bigThumbnails").style.animation = "fadeOut 0.45s forwards";
window.setTimeout(function() {document.getElementById("bigThumbnails").removeAttribute("style")}, 460);

document.getElementsByClassName("active-Tab")[0].removeEventListener("touchmove", stopScroll);

}    //end of bigThumbEvtHandler




    
function smallThumbnailHandler(event) {

var clickedImageIndex = [].slice.call(document.getElementsByClassName("smallThumbnailImgs")).findIndex(function(element) { //index of the element whose id is equal to the id of the target of the smallThumbnails click event
    if(element.id == event.target.id){
        return element.id;    
    } 
    else {
        return;
    }
}, 0);

[].slice.call(document.getElementsByClassName("bigThumbnailImgs")).map(function(element){element.style.display = "none";}); //makes all big imgs have display = "none"
document.getElementsByClassName("bigThumbnailImgs")[clickedImageIndex].style.display = "flex"; //this makes visible the img with the same index as the one we clicked. Since these are just the big versions of the small thumbnails, they make visible the same index of bigimgs
document.getElementById("bigThumbnails").style.display = "block"; //makes the container visible.


document.getElementsByClassName("active-Tab")[0].addEventListener("touchmove", stopScroll); //this way the evt listener is dumped by JS garbage collection on tab change, and it stops a bug where
//if you change tabs while a big thumbnail is open, when coming back the stopScroll function would still be in memory  and thus the homeTab becomes un-scrollable (because of event.preventDefault)
(setBigThumbEvtHandler==1) ? document.getElementById("bigThumbnails").addEventListener("click", bigThumbEvtHandler) : ""; //sets an event listener for the big imgs container (if it has not been set yet)


}    //end of smallThumbnailHandler

[].slice.call(document.getElementsByClassName("smallThumbnailImgs")).map(function(element, array, index) { //adds a click event listener to each element with the class "smallThumbnail"
element.addEventListener("click", smallThumbnailHandler);
});

}

/**************************************************************************START OF MENU SLIDE DOWN HANDLER***************************************************************************************************************/

(function menuToggle() { //toggle is a misnomer really, this makes the menu slidable down/up
    
var menuSlideStartY; //starting Y coordinate of the touch event
var menuSlideStartX; //starting X coordinate of the touch event
var newY; //new value of the Y coordinate of the touch event after sliding down or up
var newX;//new value of the X coordinate of the touch event after sliding down or up
var header = document.getElementById("header"); //the header that contains the "logo" and menu
var menu = document.getElementById("menu"); //the menu, with links
var oneEm = parseInt(getComputedStyle(document.body).fontSize, 10); //size of one em as defined in body. Since I dont define it in css it should adapt the site to custom default font sizes.
var clHeight = document.documentElement.clientHeight; //usable height of client
var clWidth = document.documentElement.clientWidth;   //usable width of client
var minimumMenuHeight = 80; //min menu height in px
var maxMenuHeight = clHeight - 4.25 * oneEm; //in px as integer (no 'px' after)




if(document.documentElement.clientWidth<=480) {
(function initialMenuAnimation() {


header.style.height = "auto";  
menu.style.zIndex = "1";
menu.style.borderBottom = "2px solid rgb(230,230,230)";

menu.style.height = maxMenuHeight + 'px';
prevHeight = maxMenuHeight;
//while(prevHeight>minimumMenuHeight) {

window.setTimeout(function() {
menu.style.animation = "menuContract 1s forwards";
 //closes if<minHeight
prevHeight = 0;
}, 1000);
    
//} //closes while loop
window.setTimeout(function(){
if(prevHeight<minimumMenuHeight) {
    prevHeight = 0;
    menu.removeAttribute("style");
    header.removeAttribute("style"); 

}   
    
}, 1850); 

})(); //closes function

}


function touchStartHandler(event) { //handles touching the screen
menuToggleHandler.touchStart(event);    
}

function touchEndHandler(event) { //handles lifting the finger up
menuToggleHandler.touchEnd(event);    
}

function slideDownHandler(event) { //handles sliding finger up/down
menuToggleHandler.touchMove(event);
}

var menuToggleHandler = (function() {
    
return {
touchStart: function(event) {
menuSlideStartY = event.changedTouches[0].clientY;
menuSlideStartX = event.changedTouches[0].clientX;
document.addEventListener("touchmove", slideDownHandler);  
},

touchMove: function(event) {


if(clWidth>480) {
document.removeEventListener("touchmove", slideDownHandler);    
}

var originalPosY = menuSlideStartY;
var originalPosX = menuSlideStartX;
newY = event.changedTouches[0].clientY;
newX = event.changedTouches[0].clientX;
var deltaY = newY - originalPosY;
var deltaX = newX - originalPosX;
//I really need to make this code more readable, right now the 9001 ifs are awful for anyone to try to understand




var isSlideAttempt = (function() { //is user trying to change slides? evaluates to true/false
if(Math.abs(clHeight/clWidth * deltaX)>Math.abs(deltaY)) { //checks if the pointer has moved farther to the right/left than up/down. Not perfect since height/width are different
//assuming 640 height, 360 width (for example. clientHeight/width are smaller since they dont consider OS/browser UI)
// 640/360 = ratio of height to width is 1.7 height is 1.7 times width
// 360/640 = ratio of width to height is 0.56 (width is 0.56 times height)
//So, assuming we move the touch 50% on deltaX and 50% on deltaY:
// 360 * 50%  = 180px on deltaX, 640 * 50% = 320px on deltaY
// then we multiply by the factors: for deltaX = 180*1.7 = 153px, for deltaY = 320 * 0.56 = 179.2
//so we end up with a small difference that favors deltaY, but remember, we are moving (in pixels) the deltaY axis way more, since it is bigger in size. Testing the site live to me it "feels" appropiate. YMMV though.

return true;    
} else {
return false;
}
})();
 
var isScrollable = (function() {
return {
    topScroll: (function() {
                            if(document.getElementsByClassName("content-Tabs")[0].scrollTop < 5) {
                            return false;    
                            }
                            else {
                            return true;    
                            }
                            })()
            };

})();
var menuHeightCalculator = (function() {
   return prevHeight + deltaY;
})();


if(Math.abs(deltaY)>0) {

if(isScrollable.topScroll) {
document.removeEventListener("touchmove", slideDownHandler);    
}

if(deltaY>0 && !isSlideAttempt) { //user moves his/her finger down, and it is not deemed to be a slide attempt (as defined above)
    
    if(deltaY+prevHeight<=minimumMenuHeight) { //without this, it bugs out when you slide the menu out and then slide back up (it doesnt disappear)
      
        menu.removeAttribute("style");
        header.removeAttribute("style");  
        document.getElementsByClassName("content-Tabs")[0].style.pointerEvents = "auto";
 
}   
    if(deltaY>minimumMenuHeight && menu.style.height.replace('px', '')<0.9*maxMenuHeight) { //if deltaY>minHeight, menu appears
        document.getElementsByClassName("content-Tabs")[0].style.pointerEvents = "none";
        header.style.height = "auto";  
        menu.style.zIndex = "1";
        menu.style.borderBottom = "2px solid rgb(230,230,230)";
        menu.style.height = menuHeightCalculator + 'px';
    }
    
    if(menu.style.height.replace('px', '')>=0.9*maxMenuHeight) { //if menuHeight >= 90% of the max menu height, it becomes maxMenuHeight AND removes the evt listener. This also triggers the touchend event that records the
    //current menuHeight to prevHeight, to be used with either of the menu slide functions
        menu.style.height = maxMenuHeight + 'px';
        document.getElementsByClassName("content-Tabs")[0].style.pointerEvents = "auto";
        document.removeEventListener("touchmove", slideDownHandler);
    }

}


if(deltaY<0 && !isSlideAttempt) {
    menu.style.height = menuHeightCalculator + 'px';
    document.getElementsByClassName("content-Tabs")[0].style.pointerEvents = "none";
    
    if(menu.style.height.replace('px', '')<=minimumMenuHeight){
        menu.removeAttribute("style");
        header.removeAttribute("style");
        document.getElementsByClassName("content-Tabs")[0].style.pointerEvents = "auto";
        document.removeEventListener("touchmove", slideDownHandler);
    }   
    
    
}
    
}

}, //closes .touchMove

touchEnd: function(event) {
prevHeight = isNaN(parseInt(menu.style.height, 10)) ? 0 : parseInt(menu.style.height, 10);

}

};
    
})();

//need to check for device orientation so scrolling the menu down is disabled (and event.preventDefault() is not enabled)
document.addEventListener("touchstart", touchStartHandler);
document.addEventListener("touchend", touchEndHandler);

})();
/************************************************************************ END OF MENU SLIDEDOWN HANDLER***********************************************************************************************************/

/************************************************************************ START OF NAVMENU HANDLER ****************************************************************************************************************/
$('.menu li').click(function(event) { //added event here so it doesnt fail on firefox

var clickedId = this.id;

event.preventDefault();

prevHeight = 0; //makes menu height reset to zero again
document.getElementsByClassName("content-Tabs")[0].style.pointerEvents = "auto";
  
//document.documentElement.webkitRequestFullscreen();  

var header = document.getElementById('header');    
var menu = document.getElementById('menu');
header.removeAttribute('style');
menu.removeAttribute('style');

$('.menu li').css("background-color", "#333");
console.log(clickedId);
$('#' + clickedId).css("background-color", "#111");

stateObject.state = clickedId.replace('Tab', 'State');
history.pushState(stateObject, "state", "/" + clickedId.replace('Tab', ''));



updateState(stateObject);

});
/*************************************************************************************END OF NAVMENU HANDLER ************************************************************************************/

function popStateHandler(popstateEvent) {
//if(!popStateScheduled) {
    //window.removeEventListener("popstate", popStateHandler);    
    //popStateScheduled=true; //need to stop this evt listener from listening while in progress (I'll remove it)
   // setTimeout(function() {
    document.getElementById(activeTabValue).style.backgroundColor = "#333";
    var param = popstateEvent;
    stateObject.state = popstateEvent.state.state; //sets the state property value to the value of the state property that's on the popstate event (so, back or forwards)
    updateState(param.state);
   // window.addEventListener("popstate", popStateHandler);
    //popStateScheduled=false;
//}, 400); //setTimeout close
//}//scheduled close
}//function close


/*************************************************************************************START OF POPSTATE EVENT LISTENER ************************************************************************************/
//popstate event listener - handles the behavior of the page when a popstate event fires. Made this so the site can handle users using the back/forward browser buttons.
window.addEventListener("popstate", popStateHandler);

/*************************************************************************************END OF POPSTATE EVENT LISTENER ****************************************************************************/




/************************************************************************************* START OF UPDATESTATE FUNCTION *****************************************************************************/
//This is the function that actually does the job updating the states - this way it can be used by both the nav menu handler and the popstate event listener.
function updateState(status) {

var stateToRequest = status.state;

var trimmedStatus = status.state.replace('State', '');

activeTabValue = trimmedStatus + "Tab" ; //sets activeTabvalue

$.ajax({url: trimmedStatus, type: 'GET', dataType: 'script'}).done(function() {

window.setTimeout(function(){
    
if(stateToRequest == "homeState") {
homeTabHandler();
return;
}

if(stateToRequest == "contactState") {

contactFormHandler();
return;
}

if(stateToRequest == "blogState") {

return;
}

else{
    
var parentNode = document.getElementsByClassName("content-Tabs")[0];
var keepLoopAlive = true;
//history.pushState(stateObject, trimmedStatus, '/'+ trimmedStatus);
while(keepLoopAlive) {
    
[].slice.call(parentNode.children).map(function(element, index, array) { //could also use '.children instead of childNodes and then it wouldn't require the 'nodeType == 3 conditional'

if(element.classList.contains(status.state.replace('State', 'Slider'))) {
slidesHandler();
keepLoopAlive = false;
return;
} else {
    
if(index+1>array.length) {
keepLoopAlive = false;
console.log("no Sliders found!");
return;
}

}
//FIX THIS LINE BELOW!
if(element.hasChildNodes() == false) {
keepLoopAlive = false;    
return;
}

});

}
}//else close   
    
}, 200);


if(!document.getElementsByClassName("content-Tabs")[0].classList.contains("active-Tab")) {
document.getElementsByClassName("content-Tabs")[0].classList.add("active-Tab");
}

});
document.getElementById(activeTabValue).style.backgroundColor = "#111";
}
/********************************************************************************* END OF UPDATESTATE FUNCTION ***********************************************************************************/


/********************************************************************************** COMPANY NAME CLICKHANDLER ****************************************************************************************/
// COMPANY NAME CLICK HANDLER - Exactly the same as clicking "Home" in the Nav menu - need to DRY it up.
$('.companyName').click(function() {
event.preventDefault();
homeState();  
//need to add menu for mobile here (or redirect to home in all the other cases)

});

/********************************************************************************** END OF COMPANY NAME CLICKHANDLER ******************************************************************************/

/*********************************************************************************** START OF SLIDES HANDLER ****************************************************************************************/
function slidesHandler(){
    
typeof stateObject[activeTabValue] == "undefined" ? stateObject[activeTabValue] = 1 : ""; //creates a key/value pair such as 'peopleTab: 1'. This is used as
// 'memory' to remember what slide you were seeing, so it can be displayed when using the back/forward browser buttons
//it is done this way because for this case I think cookies are a bit excessive/intrusive, since state is only relevant while the page is active (as oppossed to e.g. login status)


//defines common variables used/shared among the different methods of the slidesHandler object/closure   

var touchStartPosX;//position of the touch X "pointer" at the start of the touch event
var touchMoveThreshold = 140; //threshold for slide change (in px) - 110px
var doubleTapCounter = 0; //used to check for double taps to use the fullscreen API
var movePass = function(event){ //need a named function for the event listener, so it can later be removed with removeEventListener.
slidesTouchHandler.touchMove(event);        
};

var slidesTouchHandler = (function() {

return {

touchStart: function(e){ //this is called upon touching the screen, and it does 2 things: saves the position where the screen was touched (in touchStartPosX, in the slidesHandler scope) and
//creates an eventListener for touch movements. This listener has the handler MovePass, which is also set in the slidesHandler scope because it must be reused between the properties of the slidesTouchHandler object
//which I should rename because its a bit confusing.
//this code should check for double taps on jumbotron, to use the fullscreen API
doubleTapCounter++;
setTimeout(function() { //when a touchstart event happens, waits 200ms before reseting the counter back to zero
doubleTapCounter = 0;
}, 200);

if(doubleTapCounter >= 2) { // if a double tap happens, toggles between fullscreen and non-fullscreen.
    if(document.webkitExitFullscreen()) { 
        document.webkitExitFullscreen();  
    } 
    else if(!document.fullScreenElement) { //calls fullscreen API on webkit, need to add firefox/IE. Element to fullscreen is jumbotron, since that's the element that has the content.
        document.getElementById("jumbotron").webkitRequestFullscreen();   
    } 
doubleTapCounter = 0;
}
touchStartPosX =  e.changedTouches[0].clientX; //assigns X coordinate of the touchstart event.
document.addEventListener("touchmove", movePass); //adds the slidesHandler.touchMove function as handler for the "touchmove" event.
},

touchMove: function(event){ //this property is called by the movePass handler function from the event listener set in .touchStart
event = this.event || window.event; //window. event is for IE compat, need to check if this is still needed.
var originalPosX = touchStartPosX; //the X coords of the start of the touch event, set in .touchStart
var newX = event.changedTouches[0].clientX; //the current position of the touch X coords (after the user has slid his/her finger)
var deltaX = newX - originalPosX;//the difference between the start X position and the current position - a negative value means newX is to the left of originalPosX, positive is to the right

if(deltaX>0) {
document.getElementsByClassName("active-slide")[0].style.left = deltaX + 'px';
}

if(deltaX<0) {
document.getElementsByClassName("active-slide")[0].style.right = -deltaX + 'px';    
}

if(deltaX>0 && deltaX>touchMoveThreshold) { //user moves touch to the right for more than 110 pixels
//document.getElementsByClassName("active-slide")[0].style.display = "none";
document.removeEventListener("touchmove", movePass); //if I don't remove this, every 1px you move the touch cursor will change slides
prevSlideHandler(); //goes to the prevSlide function

}
if(deltaX<0 && deltaX<touchMoveThreshold*-1) {//user moves touch to the left for more than 110 pixels
//document.getElementsByClassName("active-slide")[0].style.display = "none";
document.removeEventListener("touchmove", movePass);
nextSlideHandler(); //nextSlide function.

}

},

touchEnd: function(){ //called upon lifting the finger off the activeslide, it simply removes the event listener we set up in touchStart.
parseInt(document.getElementsByClassName("active-slide")[0].style.right, 10) < touchMoveThreshold ? document.getElementsByClassName("active-slide")[0].removeAttribute("style") : "";
parseInt(document.getElementsByClassName("active-slide")[0].style.left, 10) < touchMoveThreshold  ? document.getElementsByClassName("active-slide")[0].removeAttribute("style") : "";
document.removeEventListener("touchmove", movePass);
},



};    
    
 
    
})();

//Yes, I am aware that the whole previous/next slide and add/remove class is MUCH faster w/ jQuery (.prev(), .next(), .addClass(), .removeClass(), however I wanted to try a vanilla JS solution

var currentTab = [].slice.call(document.getElementsByClassName(stateObject.state.replace('State', 'Slide'))); //makes an array of items of all the slide containing divs
var currentTabActiveIndex = stateObject[activeTabValue]-1;
var activePicker = document.getElementById(stateObject.state.replace('State', 'CounterCurrent'));
activePicker.value = stateObject[activeTabValue];
document.getElementById(stateObject.state.replace('State', 'CounterTotal')).innerHTML = currentTab.length; //length of the slide picker at the bottom
currentTab[stateObject[activeTabValue]-1].classList.add("active-slide"); //from the currentTab array, check on stateObject what's the slide we should be at, and add 'active-slide to it'

function determineActiveIndex() {//this function has to be called every time the classes are modified

var findTheActiveSlide = function(element) {//finds the index where the element has class="active-slide"
if(element.classList.contains("active-slide")) { 
        return element; 
    }
   else {
        return; 
   }    
};
currentTabActiveIndex = currentTab.findIndex(findTheActiveSlide, 0);
stateObject[activeTabValue] = currentTabActiveIndex+1;
}
determineActiveIndex();

function prevSlideHandler() {
    
if(!scheduled) {
scheduled=true; //stops the event from happening again.

var currentTabPrevSlide = (function(){
if (currentTabActiveIndex==0){
    return currentTab[currentTab.length-1]; //arrays are zero indexed.
    }
    else {
    return currentTab[currentTabActiveIndex-1];
    }
})();

    currentTab[currentTabActiveIndex].style.animation = "fadeOut 0.45s forwards";//this will get changed to an animation, but for now it will suffice
    
    window.setTimeout(function() { //waits until the anim is over to start processing the rest of the code
    currentTab[currentTabActiveIndex].removeAttribute("style");
    currentTab[currentTabActiveIndex].style.display = "none";
    currentTab[currentTabActiveIndex].classList.remove("active-slide");
    currentTabPrevSlide.classList.add("active-slide");
    currentTabPrevSlide.style.animation = "imgFadeIn 0.45s forwards";
    currentTabPrevSlide.style.display= "flex";

    activePicker.value = (function() {
    if(activePicker.value == 1) {
    return currentTab.length;    
    }
    else {
    return parseInt(activePicker.value, 10) - 1;
    }
    })();
   
    scheduled=false; //allows the event to happen again once its finished
    
    determineActiveIndex(); 
    assignTouchEventListeners(); //assigns the touch evt listeners - Can probably make this more efficient by not loading them on non touch devices + removing all the evt listeners except the one currently in use(on currentTab)

    console.log(currentTabActiveIndex);
    }, 460);    
    
    

}
    
}

function nextSlideHandler() {
    
    
if(!scheduled) {
scheduled=true; //stops the event from happening again.    



var currentTabNextSlide = (function(){
    if (currentTabActiveIndex==currentTab.length-1){//arrays are zero indexed.
    return currentTab[0]; 
    }
    else {
    return currentTab[currentTabActiveIndex+1];
    }
})();

currentTab[currentTabActiveIndex].style.animation = "fadeOut 0.45s forwards";//this will get changed to an animation, but for now it will suffice
window.setTimeout(function() {
currentTab[currentTabActiveIndex].removeAttribute("style");
currentTab[currentTabActiveIndex].style.display = "none";
currentTab[currentTabActiveIndex].classList.remove("active-slide");
currentTabNextSlide.classList.add("active-slide");
currentTabNextSlide.style.animation = "imgFadeIn 0.45s forwards";
currentTabNextSlide.style.display= "flex";

activePicker.value = (function() {
    if (activePicker.value == currentTab.length) {
    return 1;    
    }
    else {
    return parseInt(activePicker.value, 10) + 1;
    }
})();


scheduled=false; //allows the event to happen again once its finished
determineActiveIndex();  
assignTouchEventListeners();    
console.log(currentTabActiveIndex);
}, 460);   

}
}

function jumpToSlide(currentTab, slideToJumpTo) {

if(slideToJumpTo < 1) {
slideToJumpTo = 0;    
}

if(slideToJumpTo > currentTab.length) {
slideToJumpTo = currentTab.length;    
}

currentTab[currentTabActiveIndex].style.animation = "fadeOut 0.45s forwards";

 window.setTimeout(function() {
    currentTab[currentTabActiveIndex].style.display = "none";
    currentTab[currentTabActiveIndex].classList.remove("active-slide");
    currentTab[slideToJumpTo].classList.add("active-slide");
    currentTab[slideToJumpTo].style.animation = "imgFadeIn 0.45s forwards";
    currentTab[slideToJumpTo].style.display= "flex";
    activePicker.value = slideToJumpTo+1;
    determineActiveIndex(); 
    assignTouchEventListeners();
    }, 460);    

    console.log(currentTabActiveIndex);
}


function onTouch(event) {
slidesTouchHandler.touchStart(event);    
}//need to name this function so I can remove the event listener later

function onTouchEnd (event) {
slidesTouchHandler.touchEnd();  
}//need to name this function so I can remove the event listener later

function assignTouchEventListeners() {
// start of touch event listener
currentTab[currentTabActiveIndex].addEventListener("touchstart", onTouch);
//end of touch event listener
currentTab[currentTabActiveIndex].addEventListener("touchend", onTouchEnd);
console.log(currentTab);
console.log(currentTabActiveIndex);
console.log("assign touch evt listener");
}

assignTouchEventListeners();

function slidePickerHandler() {

var slidePicker = [].slice.call(document.getElementsByClassName("slidePicker")); //array of all slide pickers 

console.log(slidePicker);
//I don't really like this solution...seems really ugly.

//It works like this: .map goes through each item of slidePicker, sets a new var called "assignEvtListeners" to true. if assignEvtListeners is true, executes  array[index].addEvtListener("focus"...)'s
// event listener assignation. Otherwise every time you focus the slide picker it adds another evt listener, which looks fine right up until you enter NaN and then are greeted by 9001 alerts. Also wastes resources unnecessarily

slidePicker.map(function(element, index, array) {

    
//if(amtOfListenersToAssign>0){
var assignEvtListeners = true;
//amtOfListenersToAssign--;

array[index].addEventListener("focus", function() {
if(assignEvtListeners == true) {    
determineActiveIndex();
//definir el valor activo al momento de focusear activePicker.
var activePickerCurValue = activePicker.value;
console.log(assignEvtListeners);

document.addEventListener("keypress", function(event) {
    
if(event.keyCode == "13") {

if(activePickerCurValue !== activePicker.value) {    

if(isNaN(activePicker.value) || activePicker.value == "") {

alert("Please pick a number between 1 and " + currentTab.length);
activePicker.value = "";
return;
} else {
activePicker.blur(); // triggers the below event listener    
}


}

}    
    
}); //closes the keypress evt listener

array[index].addEventListener("blur", function(event) {
    
if(isNaN(activePicker.value) || activePicker.value == "") {

alert("Please pick a number between 1 and " + currentTab.length);
activePicker.value = "";
return;
}

if(activePickerCurValue !== activePicker.value) {    
activePickerCurValue = activePicker.value;    

jumpToSlide(currentTab, parseInt(activePicker.value, 10)-1);   

window.setTimeout(function() {
prevNextButtonHandlers();     
    
}, 460);

}

}); //closes the blur evt listener

assignEvtListeners = false;    
}

});     //closes the focus evt listener 

//}
}); //closes the map function
  
}//closes slidePickerHandler

slidePickerHandler();

function prevNextButtonHandlers() { //assigns click event handlers for prev/next slide (clicking the arrow buttons in desktop mode)
    
var prevButton = [].slice.call(document.getElementsByClassName("slider-nav-prev")); //makes an array with all divs with the "slider...." class
var nextButton = [].slice.call(document.getElementsByClassName("slider-nav-next")); //^same but for next

prevButton.map(function(element, array, index) {element.addEventListener("click", prevSlideHandler)}); //assigns an event listener for each of the elements in the array.
nextButton.map(function(element, array, index) {element.addEventListener("click", nextSlideHandler)}); //^same

}

prevNextButtonHandlers();

function removePrevNextButtonHandlers() { //used when the slide picker input is clicked
var prevButton = [].slice.call(document.getElementsByClassName("slider-nav-prev")); //makes an array with all divs with the "slider...." class
var nextButton = [].slice.call(document.getElementsByClassName("slider-nav-next")); //^same but for next

prevButton.map(function(element, array, index) {element.removeEventListener("click", prevSlideHandler)});
nextButton.map(function(element, array, index) {element.removeEventListener("click", nextSlideHandler)});
    
}




//here there should be another function to remove the event listeners (since the ones on the hidden slides are unnecessary)


//stops event listener stacking

} //slides handler closing bracket


//This function controls the behavior of the contact tab
//Probably Fancy Programming Syndrome, but at least I learned a bit...
var contactFormHandler = function() { 
 //defines a new object type - inputField, used for the data relating to the inputfields and text area for the contact form     
(function() {
window.fbAsyncInit(); //reloads the fb script, needed or it doesn't work when you: visit Contact -> visit another tab -> visit Contact again
}
)();


function inputField(target, textValue, eventName, eventClass, eventId, defaultValue) {
this.target = target,
this.textValue = textValue,
this.name = eventName,
this.eventClass = eventClass,
this.eventId = eventId,
this.defaultValue = defaultValue,
this.newValue = "";
}

//defines inputField objects for each of the input boxes (and the text area)

var inputName = new inputField($('input[name="clientName"]'), $('input[name="clientName"]').val(), $('input[name="clientName"]').attr("name"), $('input[name="clientName"]').class, $('input[name="clientName"]').id,//
$('input[name="clientName"]').val()); 

var inputEmail = new inputField($('input[name="clientEmail"]'), $('input[name="clientEmail"]').val(), $('input[name="clientEmail"]').attr("name"), $('input[name="clientEmail"]').class, $('input[name="clientEmail"]').id,//
$('input[name="clientEmail"]').val()); 

var inputSubject = new inputField($('input[name="clientSubject"]'), $('input[name="clientSubject"]').val(), $('input[name="clientSubject"]').attr("name"), $('input[name="clientSubject"]').class, $('input[name="clientSubject"]').id,//
$('input[name="clientSubject"]').val()); 

var inputMessage = new inputField($('textarea[name="clientMessage"]'), $('textarea[name="clientMessage"]').val(), $('textarea[name="clientMessage"]').attr("name"), $('textarea[name="clientMessage"]').class, $('textarea[name="clientMessage"]').id,//
$('textarea[name="clientMessage"]').val());

//defines an array containing all the inputfields
var inputData = [inputName, inputEmail, inputSubject, inputMessage];
//sets the default values for the inputfields
var inputDefaultValues = ["Your Name", "Your Email", "Your Subject", "Your Message"];

(function() {
var i; 
//puts the default values in the inputboxes
for (i=0; i<inputData.length; i++) {
    inputData[i].defaultValue = inputDefaultValues[i];
    inputData[i].textValue = inputDefaultValues[i];
    $(inputData[i].target).val(inputDefaultValues[i]).css("color", "#A3A3A3");
}    
})();



//event listener for changes in input boxes eg. detect when the user types in the inputbox http://stackoverflow.com/questions/6458840/on-input-change-event

$('input, textArea').on("input", function() {
   var i;
   for (i=0; i<inputData.length; i++) {
       if(this.name == inputData[i].name) {
           inputData[i].textValue = $(this).val();
       }
   }
});

//event handler for when inputs or textArea are clicked
$('.contactForm input, textArea').on('focus blur', function(event) { //if this were vanillaJS the arg for function would be ".onmouseclick/.ontouchstart", right?

var valueOfObjectPropInArrayFinder = function(property, value, array) { //find the value of property X in array Y
 var iterator;
 var clickedTarget = {}; // es objeto xq solo necesita tener un valor (el de inputData[clickeado])
 var notClickedTargets = []; // es array xq debe contener todos los inputData[!clickeado]

  for(iterator=0; iterator<array.length; iterator++) {
      if(array[iterator][property] == value) {
     clickedTarget = array.slice(iterator, (iterator+1)); // es mas facil copiar el array encontrado con slice y a la copia añadirle .index creo.
      }
      else {
          notClickedTargets.push(array[iterator]);
      }
  }
return { //returns an anonymous object, the properties of which we have to access by calling the valueOfObjectPropInArrayFinder.["PROPERTY"]
    targeted: clickedTarget,
    notTargeted: notClickedTargets
};
};

var clickedObject = valueOfObjectPropInArrayFinder("name", event.target.name, inputData).targeted; //var comment = "damn that function name is long"
var notClickedObjects = valueOfObjectPropInArrayFinder("name", event.target.name, inputData).notTargeted; //console.log(comment)

//this function modifies the values of the inputboxes according to user actions and the inputboxes values, if empty, fills the box with the defaultValue, if value=defaultValue, empties the clicked inputbox (and leaves the others alone)
var modifyInputValues = function(targetedArray, deleteDefault) { // this is the ES6 way of default function parameter value, ES5 should be done like this example: https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Functions/Default_parameters
    typeof deleteDefault == "undefined" ? deleteDefault = true : deleteDefault;
    
    var index;
    for(index=0; index<targetedArray.length; index++) {
    
    switch(targetedArray[index].textValue) {
    case "":
      $(targetedArray[index].target).val(targetedArray[index].defaultValue);
      targetedArray[index].textValue = targetedArray[index].defaultValue;
      $(targetedArray[index].target).css("color", "#A3A3A3");
      break;  
    case targetedArray[index].defaultValue: //this uses the deleteDefault argument to distinguish between the clicked target and the others(it deletes the text if = defaultValue on clickedTarget and leaves it alone in the others)
        if(deleteDefault) {
         $(targetedArray[index].target).val("");
                   targetedArray[index].textValue = "";
                    $(targetedArray[index].target).css("color", "black");
        }
        if(!deleteDefault) {
                  $(targetedArray[index].target).css("color", "#A3A3A3");
        }
    break;
    default: //this default triggers when the user has input some other value in the inputbox but then clicks another inputbox
    targetedArray[index].textValue = $(targetedArray[index].target).val();
     $(targetedArray[index].target).css("color", "black");
}
}
};

//fires the function for both clicked inputbox and the others
modifyInputValues(clickedObject); 
modifyInputValues(notClickedObjects, false);
});

//This handles the display of the social plugins and their behavior:
var fbMessageBox = document.getElementById("fbMessageBox");
var fbMessageButton = document.getElementById("fbMessageButton");

fbMessageButton.onclick = function() { //trying to see how to do a handler function in vanilla JS instead of jQuery

//this is easier w/jquery: button.css("display", "none") ? button.show() : button.hide(); 
var showMessageBox = function() {

fbMessageBox.style.position="absolute"; //this becomes an inline style instead of a css style
fbMessageBox.style.display="inline-block";

};

var hideMessageBox = function() {
fbMessageBox.style.display = "none";    
};

window.getComputedStyle(fbMessageBox, null).getPropertyValue("display") == "none" ? showMessageBox() : hideMessageBox(); //ternary operator working - same as an IF/ELSE statement, but shorter
};



document.getElementById("fbMessageBoxClose").addEventListener("mousedown", function(event) { //needs to be mousedown so its compatible with the drag evt listener
event.stopPropagation(); //this way the drag function doesnt get an event so it doesnt fire
event.preventDefault();

fbMessageBox.style.animation = "fadeOut 0.45s forwards";

setTimeout(function() {
fbMessageBox.style.display = "none";    
fbMessageBox.style.animation = "none";    
}, 451);


});


//this handles the drag-ability of the message box. As I understand it, this should be way easier with the jQuery UI .draggable() method but understanding this might be useful in case I want to program an HTML5 canvas game or 
//something
//source + my understanding/explanation of the code: http://codepen.io/e0plus/pen/rLyKbZ - Later I had to modify the original code a bit to make it fit for this project, so it's not 100% ctrl+C ctrl+V work.

//function that controls the movement of the boxes


var dragBoxFunction = (function(){
    //boxToMove: the messageBox we need to move. This function should be reusable with the facebook, instagram and twitter message boxes
    //boundary: the boundaries for movement. This could be, for example, the parent element, or the "content-Tabs" div.
    return {
     movementStart: function(boxToMove, boundaryId, evt) { // boundaryId should be the ID of the div to be located (it is used in a document.getElementById function)
         //this is called onmousedown - defines mouse position, where the top and left borders of box to move are, and its height + width. Also gets the height and width of boundary(the container div)
        
        document.getElementById("fb-iframe").style.pointerEvents="none"; //dragging stops when you mouse over the first child of boxToMove(because it's an external iframe), this stops that (by making the iframe not react to pointer events)
                 
                   
                    evt = evt || window.event; // window.event is for IE compatibility
                    var positionX = evt.clientX, //mouse position on the X axis - setting multiple variables with one var statement using comma
                        positionY = evt.clientY, //mouse position on the Y axis
                        boxToMoveTop = window.getComputedStyle(boxToMove, null).getPropertyValue("top"),
                        boxToMoveLeft = window.getComputedStyle(boxToMove, null).getPropertyValue("left"),
                    //boxToMoveWidth = parseInt(boxToMove.style.width), //boxToMove's width
                        boxToMoveWidth = parseInt(window.getComputedStyle(boxToMove, null).getPropertyValue("width"), 10),
				    //boxToMoveHeight = parseInt(boxToMove.style.height), //boxToMove's height - not sure why he needs parseInt, isnt it integer already? - Nope, isnt: http://www.w3schools.com/jsref/prop_style_top.asp - includes "px"
					//which parseInt ignores
					    boxToMoveHeight = parseInt(window.getComputedStyle(boxToMove, null).getPropertyValue("height"), 10),
					//boundaryWidth = parseInt(document.getElementById(boundary).style.width), //^same but for the boundary div - since in my code styles are defined in css instead of inline, this has to be changed to
					//getComputedStyle().getPropertyValue
					    boundaryWidth = parseInt(window.getComputedStyle(document.getElementById(boundaryId), null).getPropertyValue("width"), 10),
				    //boundaryHeight = parseInt(document.getElementById(boundary).style.height);//^height, ditto
				        boundaryHeight = parseInt(window.getComputedStyle(document.getElementById(boundaryId),null).getPropertyValue("height"), 10);
					//Sets the mouse pointer to the "move" cursor (a cross with arrows on each end), and sets variables that store the difference between the original position of the mouse at the beginning of the click 
					//and the new one after the 
                    boxToMoveTop = boxToMoveTop.replace('px',''); //deletes "px" (by replacing with nothing)
                    boxToMoveLeft = boxToMoveLeft.replace('px','');//deletes "px" (by replacing with nothing)
         
                    var mousePosToBoxBorderX = positionX - boxToMoveLeft,//saves the delta between the mouse pointer Xposition and the left of the boxToMove. This var's values are automatically updated with the below onmousemove event listener
                        mousePosToBoxBorderY = positionY - boxToMoveTop; //same but for the Y axis/top - This is useful to locate the mouse pointer in relation to the borders of the boxToMove
				//fbMessageBox tiene Top y Left xq es un elemento con position absolute, lo normal es "auto"
			
			//find the child node of boundaryId (to calculate offsetLeft & offsetTop, which are then added to the clientX/Y to create the movement boundaries). In this case this could have been done with
			//node.firstChild, but this function is reusable in more scenarios (for example if there were several nodes with difference distances between them instead of contactForm and ~3 parents having no distance between them)
                    var nodeToOffset = (function() {
		            var prevNode = "parentNode", //added to make it go back in the DOM structure
		                currentNode = boxToMove,//where to start looking
		                boundaryIdFound=false; //boolean to continue/stop the loop
		        
		            while (!boundaryIdFound) {
		            (currentNode[prevNode].id == "contactContent") ?  boundaryIdFound=true : currentNode = currentNode[prevNode]; //short form if/else if statement w/ the ternary operator
		            }
                    return currentNode; //now we can access this value and its properties by calling the function (nodeToOffset.id = currentNode.id, etc)
		            })();		    
  
				document.onmousemove = function(evt){
                            evt = evt || window.event;
                            var positionX = evt.clientX,
                                positionY = evt.clientY,
                                newX = positionX - mousePosToBoxBorderX, //new position, X This brings position X to the border of the box, instead of the mouse position
                                newY = positionY - mousePosToBoxBorderY; //new position, Y

                            //var headerHeight = parseInt(window.getComputedStyle(document.getElementsByClassName("headerBackground")[0], null).getPropertyValue("height")); //height of the header bar - [0] because its the first and only element with that className
                           // if(positionY<headerHeight) {dragBoxFunction.movementStop(boxToMove, boundaryId, evt)} //if user tries to move the box outside the boundary (jumbotron), the dragging stops - This is the top border
                            //if(positionY>headerHeight + boundaryHeight) {dragBoxFunction.movementStop(boxToMove, boundaryId, evt)} //if user tries to move the box outside the boundary (jumbotron), the dragging stops - this is the bottom border
							if (newX + nodeToOffset.offsetLeft  < 0 ) newX = 0 - nodeToOffset.offsetLeft;  // this creates the X bottom "border" that doesnt allow boxToMove outside of Boundary (in this case, jumbotron)
							if (newY + nodeToOffset.offsetTop < 0) newY = 0 - nodeToOffset.offsetTop; //left border
							if (newX + nodeToOffset.offsetLeft + boxToMoveWidth > boundaryWidth) newX = boundaryWidth - boxToMoveWidth - nodeToOffset.offsetLeft; //right border
							if (newY + nodeToOffset.offsetTop + boxToMoveHeight > boundaryHeight) newY = boundaryHeight -boxToMoveHeight - nodeToOffset.offsetTop; //top border
						    
                            dragBoxFunction.positionChange(boxToMove,newX,newY);
                        };
     },
     movementStop: function(boxToMove, boundaryId, evt) {
         //this is called onmouseup
				        document.getElementById("fb-iframe").style.pointerEvents="auto";
                        document.onmousemove = function(){};//when mouse click is lifted, the event listener for mouse move becomes an empty function  - the "recommended" modern way to do this now seems to be assigning
                        //listeners with named functions so you can have multiple event listeners for an action and you can remove them without removing all of them
     },
     positionChange: function(boxToMove,XAxisPosition,YAxisPosition) {
         //applies the position changes according to mousemovement
      //console.log("newX    " + XAxisPosition + "newY   " + YAxisPosition);
                        boxToMove.style.left = XAxisPosition + 'px';
                        boxToMove.style.top = YAxisPosition + 'px';
     }
    };
})();
    
    
    
//invoking the movement control function on fbMessageBox.onmousedown


fbMessageBox.onmousedown = function(event) { //cant detect clicks or use mousedown on an iframe! need to move it using the borders or something - There is a way to detect clicks on iframes but its kind of hacky
//and might not be useful for me here: http://stackoverflow.com/questions/2381336/detect-click-into-iframe-using-javascript/32138108#32138108 (answer by Dmitry Kochin, JSFiddle: http://jsfiddle.net/oqjgzsm0/)
event.stopPropagation();
event.preventDefault(); //so you dont select stuff while dragging

dragBoxFunction.movementStart(fbMessageBox, "jumbotron", event);
};

fbMessageBox.onmouseup = function(event) {
    dragBoxFunction.movementStop(fbMessageBox, "jumbotron", event);
};

/****************************** this part handles the behavior of the buttons that show/hide the text/contactform on mobile********/

var contactButton = document.getElementById("contactButton"); 
var contactText = document.getElementById("contactText");
var aboutButton = document.getElementById("aboutButton");
var contactForm = document.getElementById("contactForm");

contactButton.style.animation="none"; //this is needed so the animation doesnt play again when you re-click the contact nav menu button
contactText.style.animation="none";
aboutButton.style.animation="none";
contactForm.style.animation="none";


contactButton.onclick = function() {
     
contactButton.style.animation = "contract3d 5s forwards";    
contactText.style.animation ="contract-text3d 2s forwards";
contactForm.style.animation = "contract-form3d 2s forwards"; 
aboutButton.style.animation ="expand3d 1.5s forwards";


};

aboutButton.onclick = function() {

contactButton.style.animation = "uncontract3d 2s forwards";    
contactText.style.animation ="uncontract-text3d 2s forwards";
contactForm.style.animation = "uncontract-form3d 2s forwards";
aboutButton.style.animation ="unexpand3d 1.5s forwards";   
   
    
};


/************************************************* /this part handles the behavior of the buttons that show/hide the text/contactform on mobile ************************/

/**** START part handles the formatting when the input boxes receive focus *****/

var allInputs = document.getElementsByTagName("input"); //these are my targets
var allTextAreas = document.getElementsByTagName("textarea"); //this one too

function assignFocusListeners(target) {
var i=0;
var headerBackground = document.getElementById("headerBackground");   
var jumbotron = document.getElementById("jumbotron"); 
var bottomBackground = document.getElementById("bottomBackground");
var aboutButton = document.getElementById("aboutButton");
var contactContent = document.getElementById("contactContent");
    
for (i=0; i<target.length; i++) {
    
target[i].addEventListener("focus", function(event) { //on focus, apply styles depending on orientation
    
switch(currentOrientation) {
    case  0: //portrait
    //poner event listener en focus que hace que jumbotron.height = 100vh y header, bottomBar = display.none
    //poner event listener "blur" -> remove styles.
    headerBackground.style.display = "none";
    jumbotron.style.height = "100vh";
    jumbotron.style.maxHeight = "100vh";
    bottomBackground.style.display = "none";
    
    if(activeTabValue == "contactTab") {
    aboutButton.style.display = "none";
    contactContent.style.overflow = "scroll";
    }
    
    break;
    
    case -90 || 90: //either of those is landscape
        
    break;
    
    case undefined: //device doesn't support orientation
        
    break;
    
    default:
    console.log("unexpected currentOrientation value");
    
}   //switch statement 

});//focus evt listener

target[i].addEventListener("blur", function(event) {
    
    switch (currentOrientation) {
        case 0: 
            
        [headerBackground, jumbotron, bottomBackground].map(function(index) {
        index.removeAttribute("style");
        });   
        
        if(activeTabValue =="contactTab") {
        contactContent.removeAttribute("style");   
        aboutButton.style.animation = "expand3d 0s forwards";
        aboutButton.style.display = "flex";   
        }
        break;
        
        case -90 || 90:
        console.log("landscape");
        break;
    }
});


}//loop

}//function

assignFocusListeners(allInputs);
assignFocusListeners(allTextAreas);




/**** END part that handles the formatting when the input boxes receive focus *****/

};//end of contactFormHandler






};


$(document).ready(main);

