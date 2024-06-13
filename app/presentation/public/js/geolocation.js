document.addEventListener("DOMContentLoaded", function() {
    const button = document.getElementById("get-location");
    const output = document.getElementById("location-output");
  
    button.addEventListener("click", function() {
      if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(showPosition, showError);
      } else {
        output.innerHTML = "Geolocation is not supported by this browser.";
      }
    });
  
    function showPosition(position) {
      const latitude = position.coords.latitude;
      const longitude = position.coords.longitude;
  
      $.ajax({
        type: 'POST',
        url: '/geolocation/locate',
        contentType: 'application/json',
        data: JSON.stringify({ latitude: latitude, longitude: longitude }),
        success: function(response) {
          output.innerHTML = `Latitude: ${latitude}, Longitude: ${longitude}<br>Address: ${response.address}`;
        },
        error: function(error) {
          output.innerHTML = `Error: ${error}`;
        }
      });
    }
  
    function showError(error) {
      switch(error.code) {
        case error.PERMISSION_DENIED:
          output.innerHTML = "User denied the request for Geolocation.";
          break;
        case error.POSITION_UNAVAILABLE:
          output.innerHTML = "Location information is unavailable.";
          break;
        case error.TIMEOUT:
          output.innerHTML = "The request to get user location timed out.";
          break;
        case error.UNKNOWN_ERROR:
          output.innerHTML = "An unknown error occurred.";
          break;
      }
    }
  });
  