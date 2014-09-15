'use strict';

/*
 * Module Dependencies.
 */
var express = require('express');
var socketio = require('socket.io');
var crypto   = require('crypto');

console.log('Configuring the server...');
process.openStdin();
var app = express();
var server = app.listen(8080);
app.use(express.bodyParser());

var tags     = [];
var sessions = [];

console.log('Configuring web sockets...');
var io = socketio.listen(server);
io.sockets.on('connection', function (socket) {
    console.log('CONNECTION!!!');
    socket.on('gibVideos', function(data) {
        socket.emit('hazVideos', sessions);
    });
    socket.on('gibTags', function(data) {
        socket.emit('hazTags', tags);
    });
});

function generateUniqueId() {
    var chars = "abcdefghijklmnopqrstuwxyz";
    var rnd = crypto.randomBytes(6)
        , value = new Array(6)
        , len = chars.length;

    for (var i = 0; i < 6; i++) {
        value[i] = chars[rnd[i] % len]
    };

    return '' + value.join('');
}

console.log('Configuring routes...');
/*
 * Get a list of all of the current tags.
 */
app.get('/api/tags', function (req, res) {
    res.json(tags);
});
/*
 * Adds a tag to the list of available tags.
 */
app.post('/api/tags', function (req, res) {
    console.log('Received data for tags!');
    console.log(req.body);
    console.log(req.body.name);
    tags.push(req.body.name);
    io.sockets.emit('hazNewTag', {data: req.body.name});
    res.json({
        success: true
    });
});
/*
 * Creates a new session for watching videos.
 */
app.post('/api/sessions', function (req, res) {
    console.log('Received data for sessions!');
    console.log(req.body);
    console.log(req.body.latitude);
    // Generate the unique ID and secret.
    //var uniqueId = generateUniqueId();
    var uniqueId = generateUniqueId();

    // Create a new session from the provided information, add it to the session list.
    var newSession = {
        uniqueId: uniqueId,
        tag: req.body.tag,
        latitude: req.body.latitude,
        longitude: req.body.longitude
    };
    sessions.push(newSession);

    console.log(uniqueId);

    // Send the response forward.
    res.json({
        uniqueId: uniqueId
    });

    // Let all current clients know about the new video.
    io.sockets.emit('hazMoreVideo', {uniqueId: uniqueId, tag: req.body.tag});
    
    
});

console.log('Configuring interrupts...');
process.on('SIGINT', function() {
    console.log('\nGot SIGINT, aborting...');
    process.exit(0);
});
