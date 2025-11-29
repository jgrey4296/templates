#!/usr/bin/env bash

jgdebug "setting PERL"
PROMPTER_BASE="$HOME/github/MAS/cotillion/packages/prompter/prompter"
PERL5LIB="$PROMPTER_BASE:${PERL5LIB-}"
PERL5LIB="$PROMPTER_BASE/mod_aspects:$PERL5LIB"
PERL5LIB="$PROMPTER_BASE/mod_drama:$PERL5LIB"
PERL5LIB="$PROMPTER_BASE/mod_control:$PERL5LIB"
PERL5LIB="$PROMPTER_BASE/mod_services:$PERL5LIB"
