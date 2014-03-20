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

//window.pollInterval = window.setInterval( pollActivity, 5000 );