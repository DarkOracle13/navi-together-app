$(document).ready(function() {
    var map = L.map("map").setView([24.7961, 120.9967], 13);

    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
        attribution:
        '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
    }).addTo(map);

    // Function to add a marker to the map
    function addMarker(lat, lng, name, address, removable = false, waypoint_id = false) {
        var marker = L.marker([lat, lng]).addTo(map);
        var popupContent = `
            <div>
                <strong>${name}</strong><br>
                ${address}<br>
                Latitude: ${lat}<br>
                Longitude: ${lng}
                ${removable ? '<br><button class="remove-waypoint">Remove Waypoint</button>' : ''}
            </div>
        `;
        marker.bindPopup(popupContent);

        if (removable) {
            marker.on('popupopen', function() {
                var roomId = $('body').data('room-id');
                var planName = $('body').data('plan-name');
                var planId = $('body').data('plan-id');

                $(document).on('click', '.remove-waypoint', function() {
                    $.ajax({
                        url: `/plan/${roomId}/${planName}/waypoints?waypoint_id=${waypoint_id}&plan_id=${planId}`,
                        type: 'DELETE',
                        headers: {
                            'Content-Type': 'application/json',
                        },
                        data: JSON.stringify({ latitude: lat, longitude: lng }),
                        success: function(data) {
                            console.log('Waypoint removed:');
                            window.location.reload(); // Reload the page on success
                        },
                        error: function(xhr, status, error) {
                            console.error('Error:', error);
                        }
                    });
                });
            });
        }
    }

    // Add waypoints markers
    var waypoints = document.querySelectorAll('table.waypoints-table tbody tr');
    waypoints.forEach(function (row) {
        var lat = parseFloat(row.getAttribute('data-lat'));
        var lng = parseFloat(row.getAttribute('data-lng'));
        var name = row.getAttribute('data-name');
        var address = row.getAttribute('data-address');
        var waypoint_id = row.getAttribute('data-waypoint-id');
        addMarker(lat, lng, name, address, true, waypoint_id);
    });

    // Add user locations markers
    var userLocations = document.querySelectorAll('table.user-data-table tbody tr');
    userLocations.forEach(function (row) {
        var lat = parseFloat(row.getAttribute('data-lat'));
        var lng = parseFloat(row.getAttribute('data-lng'));
        var name = row.getAttribute('data-name');
        var address = row.getAttribute('data-address');
        addMarker(lat, lng, name, address);
    });

    var popup = L.popup();

    function onMapClick(e) {
        var latlng = e.latlng;
        var jsonLatLng = JSON.stringify({ latitude: latlng.lat, longitude: latlng.lng });

        $.ajax({
            url: `https://nominatim.openstreetmap.org/reverse?format=json&lat=${latlng.lat}&lon=${latlng.lng}`,
            method: 'GET',
            success: function(data) {
                var address = data.display_name ? data.display_name : 'Address not found';
                var popupContent = `
                    <div class="popup-form">
                        <label>Latitude: ${latlng.lat}</label>
                        <label>Longitude: ${latlng.lng}</label>
                        <label>Address: ${address}</label>
                        <label for="waypoint-name">Waypoint Name:</label>
                        <input type="text" id="waypoint-name" name="waypoint-name">
                        <button id="clear-inputs">Clear</button>
                        <button id="submit-waypoint">Submit</button>
                    </div>
                `;

                popup
                    .setLatLng(latlng)
                    .setContent(popupContent)
                    .openOn(map);

                $('#clear-inputs').on('click', function() {
                    $('#waypoint-name').val('');
                    $('#waypoint-description').val('');
                });

                $('#submit-waypoint').on('click', function() {
                    var waypointName = $('#waypoint-name').val();
                    var roomId = $('body').data('room-id');
                    var planName = $('body').data('plan-name');
                    var planId = $('body').data('plan-id');

                    console.log("Room ID:", roomId);
                    console.log("Plan Name:", planName);
                    console.log("Plan ID:", planId);

                    var waypointData = {
                        plan_id: planId,
                        latitude: latlng.lat,
                        longitude: latlng.lng,
                        waypoint_address: address,
                        waypoint_name: waypointName
                    };

                    $.ajax({
                        url: `/plan/${roomId}/${planName}/waypoints`,
                        type: 'POST',
                        contentType: 'application/json',
                        data: JSON.stringify(waypointData),
                        success: function(data) {
                            console.log('Success:');
                            window.location.reload(); // Reload the page on success
                        },
                        error: function(xhr, status, error) {
                            console.error('Error:', error);
                        }
                    });
                });
            },
            error: function(xhr, status, error) {
                console.error('Error fetching address:', error);
            }
        });
    }
    
    map.on('click', onMapClick);
});
