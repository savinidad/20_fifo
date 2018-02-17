// every user watching this screen gets an sse
function sse_start() {
	var source = new EventSource("app_sse.cgi");
	$("#debug").prepend("source.url:"+source.url+"\n");
	source.onmessage = function(e) {
		var ret = JSON.parse(e.data);
		if ('function' in ret) { execute_obj(ret); };
	};
	source.onerror = function(e) {
		$("#debug").prepend("js: sse.onerror: " + JSON.stringify(e) + "\n");
	};
	return source;
}

// post a message from user to server
function message_enter() {
	ajax_sub_args("message_enter", {msg: $("#message").val()});
	$("#message").val("");
}

// prepend a message from server to user screen
function message_receive(args) {
	if (typeof args.user !== 'undefined') {
		$("#msg").prepend(args.user + ": " + args.msg + "<br>");
	}
}


// prepend some text to an element
function el_prepend(args) {
	$("#"+args.el).prepend(args.text);
}

// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
// main    Kinda like "main" from Perl
// Start up this page and register listeners
$(function() {
	var source = sse_start();
	$("#message").val("");
	$("#debug").prepend("pagecreate 17\n");
	$("#debug").prepend("main:source.url:"+source.url+"\n");
	//$("#debug").prepend("host:"+window.location.host+"\n");
	//$("#debug").prepend("window.location:"+window.location+"\n");

	// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	// Register event listeners
	// when [return] is detected in message
	// "keyup" does not work right with ios and ipad keyboard!
	$("#message").on("keydown", function(e) {
		var code = (e.keyCode || e.which);
		if (code == 13) { message_enter(); }
	});
	// when [done] is detected in message
	// my attempt to treat <done> similar to <return> on iPhone
	document.addEventListener('focusout', function(e) {
		// if there is something in message, user likely wants to send it
		if ($("#message").val()) { message_enter(); }
	});
	// shudding down
	$(window).on("unload", function(e) {
		source.close();
		$("#message").val("I'm out!");
		message_enter();
	});
});
