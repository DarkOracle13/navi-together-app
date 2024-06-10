document.addEventListener("DOMContentLoaded", function () {
    var map = L.map("map").setView([24.7961, 120.9967], 13);

    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
        attribution:
        '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
    }).addTo(map);

    L.marker([24.7961, 120.9967])
        .addTo(map)
        .bindPopup("You are here!")
        .openPopup();

    var popup = L.popup();

    function onMapClick(e) {
        var latlng = e.latlng;
        var jsonLatLng = JSON.stringify({ lat: latlng.lat, lng: latlng.lng });

        popup
            .setLatLng(latlng)
            .setContent("You clicked the map at " + latlng.toString())
            .openOn(map);

        // print the JSON to the console
        console.log(jsonLatLng);

        // Send the JSON to the server
        fetch('/coordinates', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
            },
            body: jsonLatLng,
        })
        .then(response => response.json())
        .then(data => {
            console.log('Success:', data);
        })
        .catch((error) => {
            console.error('Error:', error);
        });
    }
    
    map.on('click', onMapClick);
});
