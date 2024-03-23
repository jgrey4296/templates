
jgdebug "Setting Soar"
SOAR_HOME="$HOME/github/_libs/ai/soar"

jgdebug "Setting CLIPS"
CLIPS_HOME="$HOME/github/_libs/ai/clips"

jgdebug "Setting Ceptre"
CEPTRE_HOME="$HOME/github/_libs/ai/ceptre"

# jgdebug "Setting Prompter"
# alias prompter="perl /Volumes/documents/github/MAS/cotillion/packages/prompter/prompter/prompter.pl"

JG_AI="$CEPTRE_HOME:$CLIPS_HOME:$SOAR_HOME"

PATH="$JG_AI:$PATH"
