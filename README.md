# HackDuke2021

## Inspiration

In the past few decades, the rapid development of technology has brought like-minded people from around the world together. These advancements have transformed the social scene, altering the way we speak and interact with one another (txt speak, memes, slang). However, this swift change has left many older generations in the dust as new trends can quite literally develop overnight.

A unique generational gap caused by technology has formed between Gen Z and older generations over social interaction, leading to miscommunication and divide between the two groups. Furthermore, this gap is widened by non-native speakers and immigrants, who may already struggle to understand and speak English. Our exposure to colloquial language from a young age has caused an inequality; an opportunity that many immigrants and non-native speakers never had. Therefore, they are hindered when they have to communicate with peers at school or in the workplace.

In order to close this gap, we developed POG! (Parents on Groupchat!), a mobile app slang translator that helps adults understand modern slang, assists non-native speakers in overcoming the language barrier, and brings all generations closer together.  

## What it does

POG! is a simple mobile app that detects and translates modern slang in text, pictures, or screenshots into straightforward definitions. Using computer vision and OCR (optimal character recognition), the app recognizes modern slang words, highlights them in the text, and returns definitions in readable cells. The app currently supports two ways of uploading data: typing or copy/pasting into a text field and taking/uploading a photo. So, if you ever start feeling out of touch with what's cool on the street, just POG it!

## How we built it

The main iOS application was built on Swift and UIKit, with custom UI components built on XIB. The aim with the UI was to follow as closely to the Apple developer guidelines as possible, in order to develop a clean, efficient, and unambiguous UI. The design philosophy was MVC - model, view, controller - which helped our team organize functionality and work in parallel without stepping on each other's tracks. Network communication was aided by the Alamofire and AWSS3 Swift libraries, which provided us extra networking functionality while writing less code overall. Lastly, secrets management for AWS and API credentials was managed through Cocoapods Keys.

One major functionality of the Swift mobile app is the ability for the user to input a block of text and get all of the slang fully translated. After the user inputs the text, the front-end sends it the App Engine hosted on **Google Cloud**, which then iterates word by word, check if the word is in the CockroachDB databse. If it is, the algorithm simply adds this definition and the word to the array. If not, the _App Engine_ calls the webcrawler, which searches Dictionary.com's slang dictionary to find the definition of the word, outputs it, and adds it to the database. Finally, after all the definitions are collected, the App Engine returns it to the Swift App to display.

We also utilized machine learning, computer vision, and optical character recognition to read the text in the images that were taken by user. The purpose of this feature was to add more functionality the product, allowing all users an easier way to input unknown text messages. After a user takes a photo with the Swift front-end, the image is uploaded to an AWS S3 bucket, which the App Engine, hosted on Google Cloud, downloads from, calls the _Google Cloud Vision API_ to perform _Optical Character Recognition_, which is hosted on a _Google Cloud Function_, and sends the text back to the App Engine. Similar to the text parser, the App Engine then parses word by word and checks if any of the slang words are in the **CockroachDB database**. If so, we simply output the definition. If not, we use our second Google Cloud Function, which is a _webcrawler_ that connects to Dictionary.com's slang section, to determine the definition of a word and to add it to the CockroachDB database. These definitions are returned to the front-end, which then display on the UI.


## Challenges we ran into

The biggest challenge we ran into was using Google Cloud and all the specifications necessary with it. Many times, our code world work on our local computer but would fail on the Cloud. Also, the time it took to the deploy the website was long, which led to long delays between testing the code. Also, at one point, we were using Tesseract for our OCR; however, Tesseract is not supported on Google Cloud and we had to quickly switch to Google Cloud Vision API, Google Cloud's own OCR software.
We also had difficulty working with the Cockroach database as it was something that was very new to us. On the front-end side, we had difficulties working with the AWS S3 SDK for iOS and working with dynamic UIs.


## Accomplishments that we're proud of

Even with all our challenges, we were able to overcome all of them and successfully implement our app. One of our proudest accomplishments was deploying the entire app on Google Cloud, and when we finally got the image translation to work, we were filled with joy. We reached all our goals with the project and are very satisfied with the results.

## What we learned
The biggest thing we learned is how to work with the various technologies that we utilized. Many of the technologies, like Cockroach, Google Cloud, and OCR, have not been taught in our classroom, so working through our failures and repeatedly deploying our projects helped become more well versed in the subjects. We also discovered each others' strengths and weakness when it comes to software development. Some of us are better at front-end design while others are better at API development.

## What's next for POG!: Parents On Groupchats

Potentially adding a current trending slangs tab, keeping users up-to-date on the latest trends and phrases, and adding the optionality of allowing users to add their own slang.
