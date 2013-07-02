var video = document.createElement("video");
video.setAttribute("style", "display:block;");
video.setAttribute("id", "videoOutput");
video.setAttribute("autoplay", "true");
if(document.body!=null) document.body.appendChild(video);


(function () { 
 
  navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia || navigator.msGetUserMedia;
  
  window.URL = window.URL || window.webkitURL || window.mozURL || window.msURL; 

  function successCallback(stream) {
      // Set the source of the video element with the stream from the camera
      if (video.mozCaptureStream) {
          video.mozSrcObject = stream;
      } else {
          video.src = (window.URL && window.URL.createObjectURL(stream)) || stream;
      }
      video.play();
   }

   function errorCallback(error) {
      alert('Unable to get webcam stream.');
   }
  
  if (navigator.getUserMedia) {
     navigator.getUserMedia({video: true}, successCallback, errorCallback);
  } else {
     alert('Native web camera streaming (getUserMedia) not supported in this browser.');
  }
  
  video.addEventListener('loadeddata', function() {
      var attempts = 10;    
      function checkVideo() {
          if (attempts > 0) {
            if (video.videoWidth > 0 && video.videoHeight > 0) {
                video.available = true;
            } else {
                // Wait a bit and try again
                window.setTimeout(checkVideo, 500);
            }
          } else {
              // Give up after 10 attempts
              alert('Unable to play video stream. Is webcam working?');
          }
          attempts--;
      }    
      checkVideo();
  }, false);

}());
