const express = require('express')
const app = express()
const Sequelize = require("sequelize-cockroachdb");
const axios = require('axios')
const request = require('postman-request');

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

app.use(express.json())

app.get('/', (req, res) => {
    res.send('hello')
})

app.post('/text', async (req, res) => {
    definition.sync({
        force: true,
    })
        .then(function () {
            return definition.findAll();
        })
        .then(function (def) {
            definition.forEach(function (def) {
                console.log(def.id + " " + def.balance);
            });
            process.exit(0);
        })
        .catch(function (err) {
            console.error("error: " + err.message);
            process.exit(1);
        });
    const words = req.body.text
    console.log(req.body.text)
    let slangArr = []
    const wordsArr = words.split(" ")
    const newWords = wordsArr.map(word => word.trim().toLowerCase())
    const uniqueWords = [...new Set(newWords)]
    console.log('uniqueWords ' + uniqueWords)
    for (let charac of uniqueWords) {
        if (charac != '') {
            // if not in database
            const slangInDatabase = await definition.findOne({ where: { slang: charac } })
            console.log(slangInDatabase)
            if (slangInDatabase) {
                const json = { "word": charac, "definition": obj[charac] }
                slangArr.push(json)
            }
            else {
                console.log(charac)
                axios.post("https://us-central1-meta-will-329918.cloudfunctions.net/webscraper", { word: charac }).then(res => {
                    console.log('statusCode: ' + res.status)
                    console.log(res)
                }).catch(err => {
                    console.log(err)
                })
                // if (response["word"] != "") {
                //     const obj = { "word": word, "definition": response["definition"] }
                //     slangArr.push(obj)
                // }
            }
        }
    }
    res.json(slangArr)
})

app.post('/image', (req, res) => {
    try {
        const img = req.body.image
        console.log(img)
        request.post({
            url: "https://us-central1-fleet-muse-297716.cloudfunctions.net/ocr_s3",
            json: { "image": img }
        },
            function (error, response, body) {
                console.log('error ' + error)
                console.log('response ' + response)
                console.log('body ' + body)
                const slangArr = []
                const words = response.body.text.split(" ")
                const newWords = words.map(word => word.trim().toLowerCase())
                const uniqueWords = [...new Set(newWords)]
                for (let word of uniqueWords) {
                    if (word in obj) {
                        const json = { "word": word, "definition": obj[word] }
                        slangArr.push(json)
                    }
                }
                res.json(slangArr)
            }
        )
    } catch (e) {
        console.log(e)
    }
})


const port = process.env.PORT || 3000

app.listen(port, () => {
    console.log('Server is up on port ' + port)
})

module.exports = app