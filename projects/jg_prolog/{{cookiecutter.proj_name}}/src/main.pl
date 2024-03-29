#!/usr/bin/env swipl -t halt
%% -t halt : stops entering the repl
%% from https://stackoverflow.com/questions/25467090

%%-- setup
:- set_prolog_flag(verbose, silent).
:- initialization main.
%%-- end setup

%%-- main
main :-
    current_prolog_flag(argv, [Argv|_]),
    format("Got: ~q~n", Argv),
    place(Argv),
    getPairedPerson(X, Argv),
    likes(X, Y),
    format("Result: ~q likes ~q in ~q~n", [X, Y, Argv]),
    halt().

main :- halt(1).

%%-- end main

%%-- rules
getPairedPerson(X, Y) :- paired(X, Z), Z = Y.
%%-- end rules

%%-- data
person(bob).
person(bill).
place(london).
place(ny).
likes(bob, curry).
likes(bill, salad).

paired(bob, london).
paired(bill, ny).

%%-- end data
