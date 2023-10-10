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

InWordList ← (∊∶⍚1 Words .)

Validators ← [(IsValidLength) (InWordList) (IsLowerString)]

IsValidInput ← (/× ∵(|1 !) Validators .)

# TODO: allow \e escape code
Escape ← + 27 @\0

PrintBanner ← (|0
  ⍥Escape 7
  WordLen
  &p $ uordle: wordle written in uiua.
     $ 
     $ rules:
     $ 
     $ * type words in lower case
     $ * words must be _ characters long
     $ * _[42;30m green  _[0m means correct character is in the right spot
     $ * _[43;30m yellow _[0m means correct character is in the wrong spot
     $ * _[48;5;240m_[30m gray   _[0m means incorrect character
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
  ($"_[48;5;240m_[30m _ _[0m" Escape Escape ∶ Escape)
  ($"_[43;30m _ _[0m" Escape ∶ Escape)
  ($"_[42;30m _ _[0m" Escape ∶ Escape)
]
GetColorMapping ← (⊏ ∶ ColorMappings)

PrintColors ← (&p /(⊂ ∩⊔) ≡(|1 □!/∘) ⍉ ⊟ ∶ ∵GetColorMapping GetLetterMask)

Win ← (⎋1 &p "\nyou win!")
Lose ← (⎋1 ; &p $"\nyou lose!\n\nthe secret word was: _" SecretWord)

MainLoop ← (|1.0
  ?Lose ∘ <1 .

  &p $"\nyou have _ attempts left"

  ⍥(PromptForValidWord) ∞
  .

  PrintColors

  ?Win ∘ ≅ SecretWord
)

PrintBanner

∵MainLoop ⇌ ⇡ + 1 MaxAttempts
