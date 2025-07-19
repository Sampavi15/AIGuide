import from mtllm.llm { Model }
import os;
import json;
import textwrap;

# Initialize a global LLM instance.
# Ensure your API key (e.g., GEMINI_API_KEY) is set in your environment.
glob llm = Model(model_name="gemini/gemini-2.0-flash");

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

# 1. Define functions to generate content using the LLM.

# Generates the main narrative for a topic based on the user's persona.
def generate_narrative(topic: str, persona: str, destination: str = "Colombo") -> str by llm();

# Answers a user's specific, free-form question.
def generate_free_response(question: str, topic: str, persona: str, context: str, destination: str = "Colombo") -> str by llm();

# Generates a quiz based on a narrative.
def generate_quiz(narrative: str) -> str by llm();


# Generates a 'Local's Secret' as a reward.
def generate_secret(topic: str, persona: str) -> str by llm();


# --- Semantic Prompts for each 'def' function ---

sem generate_narrative = """
    You are 'WanderWise', a Sri Lankan storyteller. For a '{persona}', weave a short, enchanting tale (below 120 words) about the '{topic}' of '{destination}'.
    Focus on a key moment, taste, or discovery to make them feel like they're there.
    Don't just inform, captivate. End with an intriguing question to draw them in.
    """;

sem generate_free_response = """
    You are WanderWise, the storyteller. A '{persona}' listener asks about '{topic}': '{question}'
    Answer in a brief, narrative style. Instead of a dry fact, share a small piece of lore or a vivid detail, as if telling a secret. Keep it warm and concise.
    """;

sem generate_quiz = """
    Based on the following travel narrative, generate a list of 2 multiple-choice questions in a valid JSON format solely based on this narrative.
    Each question must:
    - be strictly and directly answerable from the test provided above and do not use any general knowledge or information outside of the text
    - Include 4 options labeled from a to d
    - Indicate the correct answer letter ('a', 'b', 'c', or 'd')
    -Include a fun, helpful hint

    🎯 Keep the output in this JSON structure:
    [
        {
            "question": "...",
            "options": {"a": "...", "b": "...", "c": "...", "d": "..."},
            "answer": "...",
            "hint": "..."
        }
    ]
    """;



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
        # Get quiz as string and parse it manually
        quiz_json_string = generate_quiz(narrative);
        try{         
            if(quiz_json_string.startswith("```json") and quiz_json_string.endswith("```")){
                quiz_json_string = quiz_json_string.lstrip("```json").rstrip("```");
                quiz_json_string = quiz_json_string.strip();# Remove any leading/trailing whitespace/newlines
                
            }
            quiz = json.loads(quiz_json_string);
            }
        except (json.JSONDecodeError)as e{
            cprint(f"Error decoding quiz JSON: {e}", color=colors.RED);
            cprint(f"Raw quiz output: {quiz_json_string}", color=colors.RED);
            # If JSON decoding fails, we skip the quiz for this round and continue to the next topic
            continue;} 
        

            for (i, q ) in enumerate(quiz, 1) {
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