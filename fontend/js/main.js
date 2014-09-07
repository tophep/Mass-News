	
	$src = 'rtmp://cp67126.edgefcs.net/ondemand/&mp4:mediapm/ovp/content/test/video/spacealonehd_sounas_640_300.mp4';
	var video = '<video id="main-video" class="video-js vjs-default-skin"' +
				' controls preload="auto" width="100%" height="100%"' +
				'data-setup=\'{"example_option":true}\'>' + 
				'<source src="' + $src + '" type="rtmp/mp4" >' + 
				'<p class="vjs-no-js">To view this video please enable JavaScript, and consider upgrading to a web browser that <a href="http://videojs.com/html5-video-support/" target="_blank">supports HTML5 video</a></p> </video>';
	// alert(video);

   var timer;
	$(document).mousemove(function() {
	    if (timer) {
	        clearTimeout(timer);
	        timer = 0;
	    }

	    $('#main-video-text').fadeIn('slow');
	    $('#where-vid-goes:first-child').css('cursor','auto');
	    timer = setTimeout(function() {
	        $('#main-video-text').fadeOut('slow');
	        $('#where-vid-goes:first-child').css('cursor','none');
	    }, 1500);
	});          

	$('#where-vid-goes').html(video);

              

	var mainVideo = videojs('main-video'),
		siteTitle = $('#site-title'),
		firstSlideUp = $('.list-title:first-child');


	// play muted video
	mainVideo.muted(true).controls(false).play();

	$( ".list-title" ).each(function( i ) {
		$(this).css('z-index', (i+1));
	});

	var cur, next, prev, nTop, scrollPosition;

	$('#site-title').on('click',function(){
	    $('html,body').animate({
          scrollTop: $('body').offset().top
        }, 1000);
	});

	/* Scroll Function
	========================================================================== */
	jQuery(window).on("scroll", function() {

		// Pause main Video
		// if(firstSlideUp.offset().top >= $(window).height() * 3/4){
		// 	mainVideo.pause();
		// }else if (firstSlideUp.offset().top <= $(window).height() * 3/4) { mainVideo.load().play();
		// }


	    scrollPosition = $(this).scrollTop();
		cur = $('.current'); 
		next = $('.next');
		prev = $('.previous');

		if(typeof next.offset() != "undefined"){
			curTop = cur.offset().top;
		}
		if(typeof next.offset() != "undefined"){
			nextTop = next.offset().top;
		}

		siteTitleHeight = siteTitle.offset().top + siteTitle.outerHeight();

		if(curTop <= siteTitleHeight &&(typeof next !== "undefined")){
			cur.next().css('margin-top', cur.outerHeight() + 'px');
			cur.addClass('fixed').css('top', siteTitle.outerHeight()).removeClass('current').addClass('previous');
			cur.prev().prev().removeClass('previous');
			next.addClass('current').removeClass('next');
			next.next().next().addClass('next');
		} 	
		else if(prev.offset().top + prev.outerHeight() <= prev.next().offset().top){
			prev.next().css('margin-top', '0px');
			prev.removeClass('fixed').removeClass('previous').addClass('current').css('top', '0px');
			prev.prev().prev().addClass('previous');
			cur.addClass('next').removeClass('current');
			next.removeClass('next');
		}	
	});


	/* Stream Viewer
	========================================================================== */
	var svButton = $('.video-box'),
	    svExitButton = $('.stream-viewer-exit-button'),
	    svTitle = $('.stream-viewer-title'),
	    svDescription = $('.stream-viewer-description p'),
	    svBackground = $('.stream-viewer-bg'),
	    svContent = $('.stream-viewer-content'),
	    suBackground = $('.stream-upload-bg'),
	    suExitButton = $('.stream-upload-exit-button'),
	    suContent = $('.stream-upload-content');

	/* Stream Viewer Show*/
	svButton.on('click', function(){
	  svBackground.fadeIn('0.1s').css('top',scrollPosition);
	  svContent.addClass('p-zoom-in');
	});

	/* Read More Exit */
	svExitButton.on('click', function(){
	    svContent.removeClass('p-zoom-in');
	    svBackground.fadeOut('0.1s');
	});

	suExitButton.on('click', function(){
	    suContent.removeClass('p-zoom-in');
	    suBackground.fadeOut('0.1s');
	});

	/* Read More Exit When document clicked outside container*/
	$(document).mouseup(function (e)
	{
	    // var container = $("YOUR CONTAINER SELECTOR");

	    if (!svContent.is(e.target) // if the target of the click isn't the container...
	        && svContent.has(e.target).length === 0) // ... nor a descendant of the container
	    {
	      svContent.removeClass('p-zoom-in');
	      svBackground.fadeOut('0.1s');
	    }
	    if (!suContent.is(e.target) // if the target of the click isn't the container...
	        && suContent.has(e.target).length === 0) // ... nor a descendant of the container
	    {
	      suContent.removeClass('p-zoom-in');
	      suBackground.fadeOut('0.1s');
	    }
	});

	suContent.on('click', function(event){
	  event.stopPropagation();
	});

	$('.upload-button').on('click',function(event){
	  suBackground.fadeIn('0.1s').css('top',scrollPosition);
	  suContent.addClass('p-zoom-in');
	  event.stopPropagation();
	});

	var currentlyPlaying, lastPlayed, sessionArray;

	// var recieveVideo = function(vid){
	// 	removeMainVideoFeed();
	// 	moveCurStrToDiv();
	// 	changeVidAttrToNewStr();
	// 	return true;
	// };

		var curVid  = $('#where-vid-goes:first-child');
		$('#ann-arbor-section:first-child').before(curVid);
		
	var setVideo = function(_src){
		video = '<video id="main-video" class="video-js vjs-default-skin"' +
				' controls preload="auto" width="100%" height="100%"' +
				'data-setup=\'{"example_option":true}\'>' + 
				'<source src="' + _src + '" type="rtmp/mp4" >' + 
				'<p class="vjs-no-js">To view this video please enable JavaScript, and consider upgrading to a web browser that <a href="http://videojs.com/html5-video-support/" target="_blank">supports HTML5 video</a></p> </video>';
	};

	var putVideoOnMainStream = function(vid){    	

		videojs('main-video').dispose();
		$src = 'rtmp://massne.ws/live/' + vid.uniqueId ;
		setVideo($src);
		$('#where-vid-goes').html(video);
		videojs('main-video').play().muted(true).controls(false);

	};


	/* Stream Viewer
	========================================================================== */

	var socket = io.connect('http://massne.ws:8080/');

		socket.on('connect', function(){
			socket.on('hazVideos', function(data){

				putVideoOnMainStream(data);
				alert(id + " " + tag + " " + lat + " " +  lon + " from hazVid");
			});

			socket.emit('gitVideos', {});
			socket.emit('gitTags', {});
			socket.on('hazTags', function(data){

			});

			socket.on('hazMoreVideo', function(data){
			
				putVideoOnMainStream(data);
				// alert(id + " " + tag + " " + lat + " " +  lon + " from moreVid");
			});
			socket.on('hazNewTag', function(data){
				// Do things wib data
			});
		});