// Function to set up multiple choice questions
function setupMultipleChoice(questionId, correctAnswer) {
    const questionElement = document.querySelector(questionId);
    const buttons = questionElement.querySelectorAll('button');
    const feedbackElement = questionElement.querySelector('.feedback');

    buttons.forEach(button => {
        button.addEventListener('click', function() {
            const isCorrect = button.classList.contains(correctAnswer);
            button.style.backgroundColor = isCorrect ? 'lightgreen' : 'lightcoral';
            showFeedback(feedbackElement, isCorrect ? 'Correct!' : 'Incorrect, try again!', isCorrect);
        });
    });
}

// Function to set up free response questions
function setupFreeResponse(questionId, correctAnswers) {
    const questionElement = document.querySelector(questionId);
    const input = questionElement.querySelector('input');
    const checkButton = questionElement.querySelector('button');
    const feedbackElement = questionElement.querySelector('.feedback');

    checkButton.addEventListener('click', function() {
        const userAnswer = input.value.toLowerCase().replace(/,/g, '').split(' ').filter(Boolean).sort();
        const isCorrect = arraysEqual(userAnswer, correctAnswers);

        input.style.backgroundColor = isCorrect ? 'lightgreen' : 'lightcoral';
        showFeedback(feedbackElement, isCorrect ? 'Correct!' : 'Incorrect, try again!', isCorrect);
    });
}

// Helper function to show feedback in a colored box
function showFeedback(element, message, isCorrect) {
    const backgroundColor = isCorrect ? 'lightgreen' : 'lightcoral';
    element.innerHTML = `
        <div style="
            background-color: ${backgroundColor};
            color: black;
            padding: 10px;
            border-radius: 5px;
            display: inline-block;
            font-weight: bold;
        ">
            ${message}
        </div>
    `;
}

// Helper function to compare arrays
function arraysEqual(arr1, arr2) {
    if (arr1.length !== arr2.length) return false;
    for (let i = 0; i < arr1.length; i++) {
        if (arr1[i] !== arr2[i]) return false;
    }
    return true;
}

// Function to initialize all trivia questions
function initializeTrivia() {
    // Set up multiple choice questions
    setupMultipleChoice('#question1', 'correct');
    // Add more multiple choice questions as needed, e.g.:
    // setupMultipleChoice('#question2', 'correct');

    // Set up free response questions
    setupFreeResponse('#question-free1', ['brown', 'irving', 'tatum']);
    // Add more free response questions as needed, e.g.:
    // setupFreeResponse('#question-free2', ['jordan', 'pippen', 'rodman']);
}

// Initialize trivia when the DOM is fully loaded
document.addEventListener('DOMContentLoaded', initializeTrivia);
