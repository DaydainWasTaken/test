// JavaScript script to print a paragraph about bees one word at a time

const paragraph = "Bees are essential for pollination, which helps plants reproduce and supports the ecosystem. They produce honey and beeswax, and their role in maintaining biodiversity is invaluable.";

let words = paragraph.split(" ");  // Split the paragraph into an array of words
let index = 0;

function printWord() {
    if (index < words.length) {
        console.log(words[index]); // Print the current word
        index++; // Move to the next word
    } else {
        clearInterval(interval); // Stop the interval once all words are printed
    }
}

// Print one word every 500 milliseconds
let interval = setInterval(printWord, 500);
