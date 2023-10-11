WordFile ← "words.txt"
WordLen ← 5
MaxAttempts ← 5

Words ← ⊜∘ ≠@\n. &fras WordFile

WordCount ← ⧻ Words

RandomWordIndex ← (⌊ × WordCount ⚂)
GetRandomWord ← (⊏ RandomWordIndex Words)

GetInput ← (&sc &pf "> ")

IsValidLength ← = WordLen ⧻

IsLowerChar ← (× ≥ @a ∶ ≤ @z .)
IsLowerString ← /× ∵IsLowerChar

InWordList ← (∊∶ Words .)

Validators ← [(IsValidLength) (InWordList) (IsLowerString)]

IsValidInput ← (/× ∵(|1 !) Validators .)

PrintBanner ← (|0.0
  WordLen
  &p $ uordle: wordle written in uiua.
     $ 
     $ rules:
     $ 
     $ * type words in lower case
     $ * words must be _ characters long
     $ * \x1b[42;30m green  \x1b[0m means correct character is in the right spot
     $ * \x1b[43;30m yellow \x1b[0m means correct character is in the wrong spot
     $ * \x1b[48;5;240m\x1b[30m gray   \x1b[0m means incorrect character
     $ 
     $ type a word to get started
)

SecretWord ← GetRandomWord

PromptForValidWord ← (
  GetInput
  .
  ⎋ IsValidInput
  ;
  &p "\ninvalid word, guess again"
)

GetCorrectLetterMask ← = SecretWord
GetMisplacedLetterMask ← ∊ ∶ SecretWord

GetLetterMask ← (
  . .
  GetCorrectLetterMask
  ∶
  GetMisplacedLetterMask
  +
)

ColorMappings ← [
  ($"\x1b[48;5;240m\x1b[30m _ \x1b[0m")
  ($"\x1b[43;30m _ \x1b[0m")
  ($"\x1b[42;30m _ \x1b[0m")
]
GetColorMapping ← (⊏ ∶ ColorMappings)

PrintColors ← (&p /(⊂ ∩⊔) ≡(|1 □!/∘) ⍉ ⊟ ∶ ∵GetColorMapping GetLetterMask)

Win ← (⎋1 &p "\nyou win!")
Lose ← (⎋1 ; &p $"\nyou lose!\n\nthe secret word was: _" SecretWord)

MainLoop ← (|1.0
  ?Lose ∘ <1 .

  &p $"\nyou have _ attempts left"

  ⍥(PromptForValidWord) ∞

  PrintColors .

  # BUG: I cannot seem to use void funcs here anymore
  ;?Win(1) ≅ SecretWord
)

PrintBanner

∵MainLoop ⇌ ⇡ + 1 MaxAttempts
