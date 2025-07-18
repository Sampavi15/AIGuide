import google.generativeai as genai;
import os;
import json;
import textwrap;



class colors {
    with entry {
        HEADER = '\x1b[95m';
        BLUE = '\x1b[94m';
        CYAN = '\x1b[96m';
        GREEN = '\x1b[92m';
        YELLOW = '\x1b[93m';
        RED = '\x1b[91m';
        BOLD = '\x1b[1m';
        UNDERLINE = '\x1b[4m';
        END = '\x1b[0m';
    }
}


"""Prints text with specified color and style."""
def cprint(
    text: Any,
    color: Any = colors.END,
    bold: Any = False,
    underline: Any = False
) {
    style = '';
    if bold {
        style += colors.BOLD;
    }
    if underline {
        style += colors.UNDERLINE;
    }
    print(f"{style}{color}{text}{colors.END}");
}


with entry {
    try {
        api_key = os.environ.get('GOOGLE_API_KEY');
        genai.configure(api_key=api_key);
        model = genai.GenerativeModel('models/gemini-2.0-flash');

        if
        not api_key
        {
        raise ValueError(
            'API key not found. Please set the GOOGLE_API_KEY environment variable.'
        ) ;
        } } except Exception as e {
        cprint(
            f"'Fatal Error: Could not configure AI model. '{e}",
            color=colors.RED,
            bold=True
        );
        model = None;
    }
}


"""Generates the main narrative for a topic based on the user's persona."""
def generate_narrative(topic: Any, persona: Any, destination: Any = 'Colombo')-> str {
    prompt =
        f"\n    Generates the main narrative for a topic based on the user's persona.";
    prompt =
        f"\n    You are 'WanderWise', a Sri Lankan storyteller. For a '{persona}', weave a short, enchanting tale (below 120 words) about the '{topic}' of '{destination}'.\n    Focus on a key moment, taste, or discovery to make them feel like they're there.\n    Don't just inform, captivate. End with an intriguing question to draw them in.\n    ";
    try {
        response = model.generate_content(prompt);
        return response.text;
    } except Exception as e {
        return f"I seem to have lost my train of thought... ('{e}')";
    }
}


"""Answers a user's specific, free-form question."""
def generate_free_response(
    question: Any,
    topic: Any,
    persona: Any,
    context: Any,
    destination: Any = 'Colombo'
)-> str {
    prompt =
        f"\n    You are WanderWise, the storyteller. A '{persona}' listener asks about '{topic}'\': '{question}'\n    Answer in a brief, narrative style. Instead of a dry fact, share a small piece of lore or a vivid detail, as if telling a secret. Keep it warm and concise.\n    ";
    try {
        response = model.generate_content(prompt);
        return response.text;
    } except Exception as e {
        return f"That's a great question, but I'm drawing a blank right now. ('{e}')";
    }
}

def generate_quiz(narrative: Any)-> list {
    prompt =
        f"\n    \nBased on the following travel narrative, generate a list of 2 multiple-choice questions in a valid JSON format solely based on this narrative.\nEach question must:\n- be strictly and directly answerable from the test provided above and do not use any general knowledge or information outside of the text\n- Include 4 options labeled from a to d\n- Indicate the correct answer letter ('a', 'b', 'c', or 'd')\n-Include a fun, helpful hint\n\n🎯 Keep the output in this JSON structure:\n[\n  ";
        response = model.generate_content(prompt);
        cleaned_response =
            response.text.strip().replace('```json', '').replace('```', '');
        return json.loads(cleaned_response);
    
}     


"""Generates a 'Local's Secret' as a reward."""
def generate_secret(topic: Any, persona: Any)-> str {
    prompt =
        f"\n    You are \'WanderWise\', an expert travel guide.\n    Generate one short, fascinating 'Local Secret' about the \'{topic}' of Colombo.\n    The secret should be a cool, non-obvious tip that a tourist would love.\n    Tailor it to the '{persona}' persona.\n    For a Foodie, a secret dish or place.\n    For a Historian, a hidden detail.\n    For an Observer, a cultural tip.\n    For an Adventurer, a tip about a hidden hike, a unique water sport, or a thrilling tuk-tuk route.\n    Start the secret with a 🗝️ emoji.\n    ";
    try {
        response = model.generate_content(prompt);
        return response.text;
    } except Exception {
        return '🗝️ The best secret is to always keep exploring!';
    }
}


"""The main function to run the WanderWise Travel Guide."""
def main() {
    cprint(
        '🌟 Welcome to WanderWise: Your AI Adventure in Colombo! 🌟',
        color=colors.HEADER,
        bold=True
    );
    cprint("Let's make this journey uniquely yours.", bold=True);
    print(('-' * 60));
    personas =

        {'1' : 'The Foodie' , '2' : 'The Historian' , '3' : 'The Observer' , '4' : 'The Adventurer' };
    cprint(
        'First, tell me... who are you on this journey?',
        color=colors.YELLOW,
        bold=True
    );
    cprint('1: 🍔 The Foodie      (I travel with my taste buds)');
    cprint('2: 📜 The Historian    (I want to hear the whispers of the past)');
    cprint("3: 🎨 The Observer     (I'm here to soak in the daily life and culture)");
    cprint('4: 🗺️ The Adventurer   (I seek thrills and unique experiences)');
    choice = input('Enter the number of your choice: ');
    while (choice not in personas) {
        cprint('Invalid choice. Please enter 1, 2, 3, or 4.', color=colors.RED);
        choice = input('Enter the number of your choice: ');
    }
    persona = personas[ choice ];
    cprint(
        f"\nExcellent! Guiding '{persona}' will be a pleasure.",
        color=colors.GREEN,
        bold=True
    );
    available_topics = ['Places', 'Cultures', 'Foods'];
    while available_topics {
        print(('-' * 60));
        cprint('Where shall we focus your lens now?', color=colors.YELLOW, bold=True);
        for (i, topic) in enumerate(available_topics, 1) {
            print(f"{i}': The '{topic}' of Colombo'");
        }
        topic_choice = input("Enter your choice number : ");
            try
            {
            topic = available_topics[ (int(topic_choice) - 1) ];
            }
            except (ValueError, IndexError) { cprint(
                "That's not a valid path. Please choose a number from the list.",
                color=colors.RED
            ); continue; }
        cprint(
            f"'\n🎭 Uncovering the '{topic}' of Colombo... 🎭'",
            color=colors.CYAN,
            bold=True
        );
        narrative = generate_narrative(topic, persona);
        print(('\n' + textwrap.fill(narrative, 80)));
        while True { cprint('\n✨ Your Journey Continues... ✨', color=colors.YELLOW); user_input =
            input("Ask a question, or type 'next' to face the Challenge: ").strip();
            if
            (user_input.lower() == 'next')
            {
            break;
            } cprint('\nA fantastic question! Let me see...', color=colors.CYAN); answer =
            generate_free_response(user_input, topic, persona, narrative); 
            print(('\n' + textwrap.fill(answer, 80)));}
        cprint('\n📜 The Challenge Awaits! 📜', color=colors.HEADER, bold=True);
        cprint("Let's test your adventurer's memory.", bold=True);
        quiz = generate_quiz(narrative);
        for (i, q) in enumerate(quiz, 1) {
            cprint(f"'\nQuestion '{i}': '{q[ 'question' ]}", bold=True);
            for (letter, text) in q['options'].items() {
                print(f"{letter}) {text}");
    }
        ans = input('Your answer (a/b/c/d): ').strip().lower();
        correct_answer = "";
        temp = q.get('correct');

   
        if (temp) {
            correct_answer = temp;
        } else {
            temp = q.get('answer');
            if (temp) {
                correct_answer = temp;
        }
    }

    
    if (correct_answer != "") {
        if (ans == correct_answer.lower()) {
            cprint(
                '\n🌟 Outstanding! Your insight is flawless.',
                color=colors.GREEN,
                bold=True
            );
            cprint("For your skill, you've unlocked a...", color=colors.GREEN);
            secret = generate_secret(topic, persona);
            cprint(textwrap.fill(secret, 80), color=colors.YELLOW, bold=True);
        } else {
            cprint(
                f"\n❌ Not quite. The correct path was '{correct_answer}'.",
                color=colors.RED,
                bold=True
            );
           
            hint = q.get('hint');
            if (hint) {
                cprint(f"'Hint: '{hint}", color=colors.RED);
            }
        }
    } else {
        
        cprint(
            "\n🤔 Hmm, the storyteller seems to have forgotten the answer! Let's call it a draw.",
            color=colors.YELLOW,
            bold=True
        );
    }
}
available_topics.remove(topic);
if (not available_topics) {
    break; 
}
print(('-' * 60));
exit_choice = input("Press Enter to explore the next topic, or type 'exit' to end your journey: ").strip().lower();
if (exit_choice == 'exit') {
    break;}
        
print(('-' * 60));
cprint(
    'You have explored all the paths! A truly grand tour.',
    color=colors.HEADER,
    bold=True
);
cprint(
    'Thank you for adventuring with WanderWise. Until our next journey!',
    bold=True
    );
}
}

with entry {
    if (__name__ == '__main__') {
        main();
    }
} 