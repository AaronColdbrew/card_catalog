/* Include and start express. */
let express = require('express');
let app = express();

/* Require and set  up handlebars.*/
const handlebars = require('express-handlebars').create({defaultLayout: 'main'});
app.engine('handlebars', handlebars.engine);
app.set('view engine', 'handlebars');

/* Path module for directing to the Public assets folder.*/
const path = require('path');

/* Set the path for loading assets like CSS and images.*/
app.use(express.static(path.join(__dirname, '/public')));

/* Set input from the console to manage the port. */
app.set('port', process.env.PORT || 8080);

/* Set up the HTTP request.*/
let request = require('request');

/*This code sets up the middleware used to parse POST requests
 * sent via the body. It can accept posts that are URL-Encoded
 * or JSON formatted.*/

let bodyParser = require('body-parser');
app.use(bodyParser.urlencoded({extended: false}));
app.use(bodyParser.json());


function Card(name, edition, type, color, quality) {
    this.name = name;
    this.edition = edition;
    this.type = type;
    this.color = color;
    this.quality = quality;
}
/* Handles building the front page.*/
app.get("/", (req, res) => {

    let context = {};
    context.title = "View All Cards";
    context.card = [new Card('Counterspell', '3rd', 'Interrupt', 'Blue', 'EX'),
        new Card('Scryb Sprites', '4th', 'Creature', 'Green', 'GO')]
    res.render('front', context);
});


// /* This GET request handles loading the front page. */
// app.get('/', function (req, res, next) {
//     let context = {};
//     context.title = "View All Cards";
//     /*  xData.pool.query('SELECT card.card_id, card.name as name, type.name AS type, color.name as color, edition.name AS edition, quality.name AS quality FROM card LEFT JOIN color ON card.color = color.color_id LEFT JOIN type ON card.type = type.type_id LEFT JOIN edition ON card.edition = edition.edition_id LEFT JOIN quality ON card.quality = quality.quality_id ORDER BY card.name;\n', function (err, result) {
//           /* Skips to the 500 page if an error is returned.*/
//     database.pool.query('SELECT * FROM card;', function (err, result) {
//         console.log(result)
//         context.card = result;
//         res.render('front', context);
//     });
// });


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


           