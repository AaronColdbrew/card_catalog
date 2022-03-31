/* Include and start express. */
let express = require('express');
let app = express();

/* Path module for directing to the Public assets folder.*/
const path = require('path');

/* Set the path for loading assets like CSS and images.*/
app.use(express.static(path.join(__dirname, '/public')));

/* Include credentials and return a mySQL pool. */
let database = require('./dbconnection.js');

/* Start express-handlebars. Set the main layout. */
let handlebars = require('express-handlebars').create({defaultLayout: 'main'});

/* Set express-handlebars as the template engine. At runtime, the template
 * engine will replace variables in the template file with values and transform
 * the template into a web-page for the client.*/

app.engine('handlebars', handlebars.engine);  // Connect express-handlebars to express.
app.set('view engine', 'handlebars'); // Set express-handlebars to manage the views.
app.set('port', process.argv[2]); // Set input from the console to manage the port.

/* Create our express session and set the secret password.*/
let session = require('express-session');
app.use(session({secret: 'T1Q0@1qtJHAm'}));

/* Set up the HTTP request.*/
let request = require('request');

/*This code sets up the middleware used to parse POST requests
 * sent via the body. It can accept posts that are URL-Encoded
 * or JSON formatted.*/

let bodyParser = require('body-parser');
app.use(bodyParser.urlencoded({extended: false}));
app.use(bodyParser.json());


/* This GET request handles loading the front page. */
app.get('/', function (req, res, next) {
    let context = {};
    context.title = "View All Cards";
    /*  xData.pool.query('SELECT card.card_id, card.name as name, type.name AS type, color.name as color, edition.name AS edition, quality.name AS quality FROM card LEFT JOIN color ON card.color = color.color_id LEFT JOIN type ON card.type = type.type_id LEFT JOIN edition ON card.edition = edition.edition_id LEFT JOIN quality ON card.quality = quality.quality_id ORDER BY card.name;\n', function (err, result) {
          /* Skips to the 500 page if an error is returned.*/
    database.pool.query('SELECT * FROM card;', function (err, result) {
        context.card = result;
        res.render('front', context);
    });
});


/* Create a 500 page. */
app.use(function (err, req, res, next) {
    console.error(err.stack);
    res.status(500);
    res.render('500');
});


/* Create a 404 page. */
app.use(function (req, res) {
    res.status(404);
    res.render('404');
});


/* Listen for someone to access the script on the specified port. */
app.listen(app.get('port'), function () {
    console.log('Express started on http://localhost:' + app.get('port') + '; press Ctrl-C to terminate.');
});


           