const express = require('express')
const app = express()
const spawn = require('child_process').spawn
const axios = require('axios')

app.use(express.json())

app.get('/', (req, res) => {
    res.send('hello')
})

app.post('/hello', async (req, res) => {
    const response = await axios.post('https://meta-will-329918.cloudfunctions.net/ocr_s3', { jimmay: "john" })
    res.send(response)
})

app.post('/text', (req, res) => {
    const words = req.body.text
    console.log(req.body.text)
    let slangObj = {}
    for (let word of words.split(" ")) {
        if (word != ' ') {
            word = word.trim()
            // if not in database

        }
    }
    res.json(req.body)
})

// get image from edison and run python script 
// get list of words, then iterate through and check
// whether it is in the database
// if it is, use the def in the database
// if not, run havishs code to get the web scraped definition
app.get('/image', (req, res) => {
    const pythonProcess = spawn('python', ["../../ocr.py", req.body]);
    pythonProcess.stdout.on('data', (data) => {
        // Do something with the data returned from python script
        for (let word of data) {
            // check if its in the database
            console.log(word)
        }
        res.send(data)
    });
})

const port = process.env.PORT || 3000

app.listen(port, () => {
    console.log('Server is up on port ' + port)
})

module.exports = app