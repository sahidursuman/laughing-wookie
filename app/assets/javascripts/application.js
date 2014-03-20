// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require js-routes
//= require turbolinks
//= require_tree .

window.loadedActivities = [];

/* Add activity into the array */
var addActivity = function(item) {
	var found = false;
	for (var i = 0; i < window.loadedActivities.length; i++) {
		if (window.loadedActivities[i].id == item.id) {
			var found = true;
		}
	}

	if (!found) {
		window.loadedActivities.push(item);
	}

	return item;
}
/* Instantiate handlebars template */
var renderActivities = function() {
	var source = $('#activities-template').html();
	var template = Handlebars.compile(source);
	var html = template({activities: window.loadedActivities});
	var $activityFeedLink = $('li#activity-feed');

	$activityFeedLink.addClass('dropdown');
	$activityFeedLink.html(html);
	$activityFeedLink.find('a.dropdown-toggle').dropdown();
}
/* Look for activities since the last time you looked */
var pollActivity = function() {
  $.ajax({
  	url: Routes.activities_path({format: 'json', since: window.lastFetch}),
  	type: "GET",
  	dataType: "json",
  	success: function(data) {
  		window.lastFetch = Math.floor((new Date).getTime() / 1000);
  		if (data.length > 0) {		
  			for (var i = 0; i < data.length; i++) {
  				addActivity(data[i]);
  			}
  		renderActivities();
  		}
  	}
  })
}
/* Handlebars helper, because conditional logic in handlebars on a view is difficult */
Handlebars.registerHelper('activityLink', function () {
	
	var link, path, html;
	var activity = this;
	/* make the dropdown prettier */
	var linkText = activity.targetable_type.toLowerCase();

	switch (linkText) {
		case "status":
			path = Routes.status_path(activity.targetable_type);
			break;
		case "album":
			path = Routes.album_path(activity.profile_name, activity.targetable_id);
			break;
		case "picture":
			path = Routes.album_picture_path(activity.profile_name, activity.targetable.album);
			break;
		case "userfriendship":
			path = Routes.profile_path(activity.profile_name);
			break;	
	}

	/* what is contained in the activities dropdown */
	html = "<li><a href='" + path + "'>" + this.profile_name + " " + this.action + " a " + linkText + ". </a></li>";
	return new Handlebars.SafeString( html );
});


window.pollInterval = window.setInterval( pollActivity, 5000 );
pollActivity();