var baseURL = "http://dejaview.pictures";

function register_first_event(){
    var code = document.getElementById("code-input").value;
    register_event(code);
}

function register_event(code){
    var events = readCookie("events");
    var event_array = new Array();
    if (events == null){
        event_array = new Array();
    }else{
        event_array = JSON.parse(events);
    }
    event_array.push(code);
    var event_string = JSON.stringify(event_array);
    eraseCookie("events");

    createCookie("events", event_string);
    location.reload();
}

function get_events(){
    var events = readCookie("events");
}

function generate_event_card(id){
    var theUrl = baseURL + "/api/getEventInfo?eventId="+id;
    console.log("Making a get request to ["+theUrl+"] to get event data for id="+id+".");
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.open( "GET", theUrl, false ); // false for synchronous request
    xmlHttp.send( null );
    var response = JSON.parse(xmlHttp.responseText)
    return "<a href='/gallary/"+id+"'><div class='event'><h2>"+response.name+"</h2>"+id+"</div></a>"
}

function create_event(){
    var retVal = prompt("Enter your desired event name: ", "");
    var theUrl = baseURL + "/api/createEvent?name="+retVal;
    console.log("Making a get request to ["+theUrl+"] to create a new event.");
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.open( "GET", theUrl, false ); // false for synchronous request
    xmlHttp.send( null );
    var response = JSON.parse(xmlHttp.responseText)
    alert("Your event ID is: " + response.eventId);
}

/* STATUP */
var events = readCookie("events");
var event_array = JSON.parse(events);
if (events != null && event_array.length > 0){
    document.getElementById("register").hidden = true;
    var list = document.getElementById("event-list");
    for (var i=0; i<event_array.length; i++){
        list.innerHTML += generate_event_card(event_array[i]);
    }
}else{
    document.getElementById("list-events").hidden = true; 
}

/* COOKIE FUNCTIONS */
function createCookie(name,value,days) {
    if (days) {
        var date = new Date();
        date.setTime(date.getTime()+(days*24*60*60*1000));
        var expires = "; expires="+date.toGMTString();
    }
    else var expires = "";
    document.cookie = name+"="+value+expires+"; path=/";
}

function readCookie(name) {
    var nameEQ = name + "=";
    var ca = document.cookie.split(';');
    for(var i=0;i < ca.length;i++) {
        var c = ca[i];
        while (c.charAt(0)==' ') c = c.substring(1,c.length);
        if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
    }
    return null;
}

function eraseCookie(name) {
    createCookie(name,"",-1);
}