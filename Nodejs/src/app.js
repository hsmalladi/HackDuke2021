const express = require('express')
const app = express()
const spawn = require('child_process').spawn

app.get('/text', (req, res) => {

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
        for (word of data) {
            // check if its in the database
            console.log(word)
        }
        res.send(data)
    });
})

module.exports = app