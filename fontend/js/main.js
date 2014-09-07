
	var mainVideo = videojs('main-video'),
		siteTitle = $('#site-title'),
		firstSlideUp = $('.list-title:first-child');

	// play muted video
	// mainVideo.play().muted(true).controls(false);

	$( ".list-title" ).each(function( i ) {
		$(this).css('z-index', (i+1));
	});

	var cur, next, prev, nTop, scrollPosition;

	$('#site-title').on('click',function(){
		// alert('');
	    $('html,body').animate({
          scrollTop: $('body').offset().top
        }, 1000);
	});

	/* Scroll Function
	========================================================================== */
	jQuery(window).on("scroll", function() {
		// alert(firstSlideUp.offset().top + ' ' + $(window).height());
		// alert(typeof mainVideo);
		// Pause main Video
		if(firstSlideUp.offset().top <= $(window).height() * 3/4){
			mainVideo.pause(true);
		}else { mainVideo.play();
			}


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
	    svContent = $('.stream-viewer-content');

	/* Stream Viewer Show*/
	svButton.on('click', function(){
	  // var _id = $(this).attr('id').replace('stream-viewer-', '');
	  // var _this = ReadMore[_id];

	  // rmTitle.html(_this.title);
	  // rmDescription.html(_this.description);
		  // rmBackground.fadeIn('0.1s');
	  svBackground.fadeIn('0.1s').css('top',scrollPosition);
	  svContent.addClass('p-zoom-in');
	});

	/* Read More Exit */
	svExitButton.on('click', function(){
	    svContent.removeClass('p-zoom-in');
	    svBackground.fadeOut('0.1s');
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
	});

	svContent.on('click', function(event){
	  event.stopPropagation();
	});

	/* Stream Viewer
	========================================================================== */
	var socket = io('http://localhost');

		socket.on('connect', function(){
		socket.on('hazVideos', function(data){
			// Do things wib data
		});
		socket.emit('gibVideos', {});

		socket.on('hazMoreVideo', function(data){
			// Do things wib data
		});
		socket.on('delVideo',function(data){});
	});