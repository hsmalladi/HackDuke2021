const express = require('express')
const app = express()
const request = require('postman-request')
const Sequelize = require("sequelize-cockroachdb");

const sequelize = new Sequelize({
    dialect: "postgres",
    username: "root",
    password: "",
    host: "34.96.125.49",
    port: 110,
    database: "slangdata",

    dialectOptions: {
        sslMode: "disable"
    },
    logging: false,
});

const definition = sequelize.define("deftable", {
    slang: {
        type: Sequelize.STRING(255),
        primaryKey: true,
        unique: true,
        notNull: true
    },
    def: {
        type: Sequelize.STRING(1000)
    }
},
    {
        sequelize,
        modelName: 'definition',
        tableName: 'deftable',
        timestamps: false,
        underscore: false,
    });

definition.removeAttribute('id');


definition.sync({
    force: true,
})
    .then(function () {
        // Insert two rows into the "accounts" table.
        return definition.bulkCreate([
            {
                slang: "lol",
                def: "laughing out loud; laugh out loud: used as a response to something funny or as a follow-up to something said only as a joke",
            },
            {
                slang: "lmao",
                def: "laugh my ass off",
            },
        ]);
    })
    .then(function () {
        // Retrieve accounts.
        return definition.findAll();
    })
    .then(function (definitions) {
        // Print out the balances.
        definitions.forEach(function (definition) {
            console.log(definition.slang + " " + definition.def)
        })
        process.exit(0);
    })
    .catch(function (err) {
        console.error("error: " + err.message);
        process.exit(1);
    });



app.use(express.json())

app.get('/', (req, res) => {
    res.send('hello')
})

app.get('/hello', (req, res) => {
    request("https://us-central1-meta-will-329918.cloudfunctions.net/ocr_s3", function (error, response, body) {
        console.log(response);
        res.send(response)
    });
})

app.post('/text', async (req, res) => {
    const words = req.body.text
    console.log(req.body.text)
    let slangArr = []
    const wordsArr = words.split(" ")
    wordsArr.forEach(word => word.trim().toLowerCase())
    const uniqueWords = [...new Set(wordsArr)]
    for (let word of uniqueWords) {
        if (word != '') {
            // if not in database
            const slangInDatabase = await definition.findOne({ where: { slang: word } })
            if (slangInDatabase) {
                const obj = { "word": word, "definition": slangInDatabase.dataValues.def }
                slangArr.push(obj)
            }
            else {
                request("https://us-central1-meta-will-329918.cloudfunctions.net/ocr_s3", function (error, response, body) {
                    console.log(response)
                });
            }

        }
    }
    res.json(req.body)
})

// get image from edison and run python script 
// get list of words, then iterate through and check
// whether it is in the database
// if it is, use the def in the database
// if not, run havishs code to get the web scraped definition
app.post('/image', (req, res) => {
    request.post("https://us-central1-meta-will-329918.cloudfunctions.net/ocr_s3", { body: req.body },
        function (error, response, body) {
            console.log(response)
            res.send(response)
        });
})

const port = process.env.PORT || 3000

app.listen(port, () => {
    console.log('Server is up on port ' + port)
})

module.exports = app