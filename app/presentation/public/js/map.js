import *  as L from 'leaflet';

const map = L.map('map').setView([51.505, -0.09], 13);

L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
    max_zoom: 19,
}).addTo(map);

