%% simplify.pl -*- mode: Prolog -*-
/**********************************************************************
% Copyright (C) 1998 Ullrich Hustadt
%                    Max-Planck-Institut fuer Informatik
%                    Im Stadtwald
%                    66123 Saarbruecken, Germany
% Version 1.2 of simplify.pl
%
% simplify.pl is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 1, or (at your option)
% any later version.
%
% simplify.pl is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
**********************************************************************/

%% Source: https://www.csc.liv.ac.uk/~ullrich/mdp/section7.html
%%
:- use_module(library(lists)).
:- use_module(library(ordsets)).

% simplify_alc(+TERM1,-TERM2)
% transform TERM1 to negation normal form and simplify it according to 
% the rules of Table 1 in the MPII Research report 97-2-003 by Ullrich 
% Hustadt and Renate A. Schmidt.

simplify_alc(Term0,Term3) :-
	nnf_term(Term2,Term0),
	simplify_term(Term0,Term2),
	(Term2 = and(L2) ->
	    subsumption(L2,L3),
	    rebuild_conjunction(L2,Term3)
	;
	    Term3 = Term2
	).

nnf_term(not(not(T1)),T2) :-
	nnf_term(T1,T2).
nnf_term(not(all(R1,T1)),some(R1,T2)) :-
	nnf_term(not(T1),T2).
nnf_term(not(some(R1,T1)),all(R1,T2)) :-
	nnf_term(not(T1),T2).
nnf_term(not(and(L1)),or(L2)) :-
	nnf_terms(L1,L2).
nnf_term(not(or(L1)),and(L2)) :-
	nnf_terms(L1,L2).
nnf_term(T1,T1) :-
	atomic(T1).
nnf_term(T1,T2) :-
	functor(T1,F,N),
	functor(T2,F,N),
	nnf_args(N,T1,T2).

nnf_terms([],[]).
nnf_terms([T1|TL1],[T2|TL2]) :-
	nnf_term(not(T1),T2),
	nnf_terms(TL1,TL2).

nnf_args(1,T1,T2) :-
	arg(1,T1,A1),
	nnf_term(A1,A2),
	arg(1,T2,A2),
	!.
nnf_args(N,T1,T2) :-
	N >= 2,
	arg(N,T1,A1),
	nnf_term(A1,A2),
	arg(N,T2,A2),
	M is N-1,
	nnf_args(M,T1,T2),
	!.	

simplify_lwb(Term1,Term3) :-
	nnf_term(Term1,Term0),
	simplify_term(Term0,Term2),
	(Term2 = and(L2) ->
%	    reverse(L2,L3),
	    L3 = L2,
	    Term3 = and(L3)
	;
	    Term3 = Term2
	).

simplify_alc_cont(Term1,Term4) :- 
	simplify_term(Term1,Term2),
	(Term2 = and(L2) ->
	    subsumption(L2,L3),
	    rebuild_conjunction(L3,Term3)
	;
	    Term3 = Term2
	),
	(Term3 = Term1 ->
	    Term4 = Term3
	;
	    simplify_alc_cont(Term3,Term4)
	).


simplify_term(and(L1),T2) :-
	simplify_conjunction(L1,T2).
simplify_term(or(L1),T2) :-
	simplify_disjunction(L1,T2).
simplify_term(not(T1),T2) :-
	simplify_term(T1,T3),
	negate_term(T3,T2).
simplify_term(all(R,T1),T3) :-
	simplify_term(T1,T2),
	rebuild_all(T2,R,T3).
simplify_term(some(R,T1),T3) :-
	simplify_term(T1,T2),
	rebuild_some(T2,R,T3).
simplify_term(T1,T1) :-
	atomic(T1).

rebuild_all(true,_,true).
rebuild_all(false,R,all(R,and([c0,not(c0)]))).
rebuild_all(T1,R,all(R,T1)).

rebuild_some(false,_,false).
rebuild_some(true,R,some(R,or([c0,not(c0)]))).
rebuild_some(T1,R,some(R,T1)).

negate_term(all(_,true),false).
negate_term(not(T1),T1).
negate_term(all(R,T1),some(R,T2)) :-
	negate_term(T1,T2).
negate_term(some(R,T1),all(R,T2)) :-
        negate_term(T1,T2).
negate_term(true,false).
negate_term(false,true).
negate_term(and(L1),or(L2)) :-
	negate_terms(L1,L2).
negate_term(or(L1),and(L2)) :-
	negate_terms(L1,L2).
negate_term(T1,not(T1)).

negate_terms([],[]).
negate_terms([T1|TL1],[T2|TL2]) :-
	negate_term(T1,T2),
	negate_terms(TL1,TL2).
	

simplify_elements_of_list([],[]) :-
	!.
simplify_elements_of_list([T1|TL1],[T2|TL2]) :-
	simplify_term(T1,T2),
	!,
	simplify_elements_of_list(TL1,TL2).

simplify_conjunction(L1,T3) :-
	simplify_elements_of_list(L1,L2),
	(member(false,L2) ->
	    T3 = false
	;
	    (option(ac,yes) ->
		list_to_ord_set(L2,L3)
	    ;
		L3 = L2
	    ),
	    simplify_conjunctive_list(L3,L4),
	    rebuild_conjunction(L4,T3)
	).

rebuild_conjunction([],true).
rebuild_conjunction([T1],T1) :-
	!.
rebuild_conjunction(TL,and(TL)).


subsumption([not(T1)|TL1],[not(T1)|TL4]) :-
	atomic(T1),
	eliminate_subsumed_disjunctions(TL1,not(T1),TL2),
	eliminate_from_disjunctions(TL2,T1,TL3),
	subsumption(TL3,TL4).
subsumption([T1|TL1],[T1|TL4]) :-
	atomic(T1),
	eliminate_subsumed_disjunctions(TL1,T1,TL2),
	eliminate_from_disjunctions(TL2,not(T1),TL3),
	subsumption(TL3,TL4).
subsumption([T1|TL1],[T1|TL2]) :-
	subsumption(TL1,TL2).
subsumption([],[]).

eliminate_subsumed_disjunctions([],_,[]).
eliminate_subsumed_disjunctions([or(L1)|TL1],T1,TL2) :-
	member(T1,L1),
	eliminate_subsumed_disjunctions(TL1,T1,TL2).
eliminate_subsumed_disjunctions([T1|TL1],T2,[T1|TL2]) :-
	eliminate_subsumed_disjunctions(TL1,T2,TL2).

eliminate_from_disjunctions([],_,[]).
eliminate_from_disjunctions([or(L1)|TL1],T1,[T2|TL2]) :-
	!,
	delete(L1,T1,L2),
	(L2 = [T3] ->
	    T2 = T3
	;
	    T2 = or(L2)
	),
	eliminate_from_disjunctions(TL1,T1,TL2).
eliminate_from_disjunctions([T1|TL1],T2,[T1|TL2]) :-
	eliminate_from_disjunctions(TL1,T2,TL2).
	
simplify_disjunction(L1,T3) :-
	simplify_elements_of_list(L1,L2),
	(member(true,L2) ->
	    T3 = true
	;
	    (option(ac,yes) ->
		list_to_ord_set(L2,L3)
	    ;
		L3 = L2
	    ),
	    simplify_disjunctive_list(L3,L4),
	    rebuild_disjunction(L4,T3)
	).	

rebuild_disjunction([],false).
rebuild_disjunction([T1],T1) :-
	!.
rebuild_disjunction(TL,or(TL)).

% simplify_conjunctive_list(LISTE1,LISTE2)
% Beachte: Die Eingabeliste LISTE1 kann die Konstante `false' nicht
% enthalten.
simplify_conjunctive_list([],[]) :-
	!.
simplify_conjunctive_list([true|TL1],TL2) :-
	!,
	simplify_conjunctive_list(TL1,TL2).
simplify_conjunctive_list([not(C1)|TL1],TL2) :-
	(member(C1,TL1) ->
	    TL2 = [false]
	;
	    simplify_conjunctive_list(TL1,TL3),
	    (TL3 = [false] ->
		TL2 = [false]
	    ;
		(member(not(C1),TL3) ->
		    TL2 = TL3
		;
		    TL2 = [not(C1)|TL3]
		)
	    )
	).
simplify_conjunctive_list([C1|TL1],TL2) :-
	(member(not(C1),TL1) ->
	    TL2 = [false]
	;
	    simplify_conjunctive_list(TL1,TL3),
	    (TL3 = [false] ->
		TL2 = [false]
	    ;
		(member(C1,TL3) ->
		    TL2 = TL3
		;
		    TL2 = [C1|TL3]
		)
	    )
	).

% simplify_disjunctive_list(LISTE1,LISTE2)
% Beachte: Die Eingabeliste LISTE1 kann die Konstante `true' nicht
% enthalten.
simplify_disjunctive_list([],[]) :-
	!.
simplify_disjunctive_list([false|TL1],TL2) :-
	!,
	simplify_disjunctive_list(TL1,TL2).
simplify_disjunctive_list([not(C1)|TL1],TL2) :-
	(member(C1,TL1) ->
	    TL2 = [true]
	;
	    simplify_disjunctive_list(TL1,TL3),
	    (TL3 = [true] ->
		TL2 = [true]
	    ;
		(member(not(C1),TL3) ->
		    TL2 = TL3
		;
		    TL2 = [not(C1)|TL3]
		)
	    )
	).
simplify_disjunctive_list([C1|TL1],TL2) :-
	(member(not(C1),TL1) ->
	    TL2 = [true]
	;
	    simplify_disjunctive_list(TL1,TL3),
	    (TL3 = [true] ->
		TL2 = [true]
	    ;
		(member(C1,TL3) ->
		    TL2 = TL3
		;
		    TL2 = [C1|TL3]
		)
	    )
	).

factor_common_subexpressions(T1,and(T2)) :-
	common_subexpressions(T1,and(T3),E3),
	append(T3,E3,T2).

	
common_subexpressions(T1,T3,E3) :-
	get_all_expression(T1,A1),
	!,
	new_predicate(d,P),
	replace_all_occurrences(T1,A1,P,T2),
	E1 = [or([not(P),A1]),or([not(A1),P]),
	      all(r1,or([not(P),A1])), all(r1,or([not(A1),P]))],
	common_subexpressions(T2,T3,E2),
	append(E1,E2,E3).
common_subexpressions(T1,T1,[]).
	
replace_all_occurrences(A1,A1,P,P) :-
	!.
replace_all_occurrences(T1,A1,P,T2) :-
	T1 =.. [F|Args1],
	replace_all_occurrences_list(Args1,A1,P,Args2),
	T2 =.. [F|Args2].
replace_all_occurrences_list([],_A1,_P,[]).
replace_all_occurrences_list([T1|TL1],A1,P,[T2|TL2]) :-
	replace_all_occurrences(T1,A1,P,T2),
	replace_all_occurrences_list(TL1,A1,P,TL2).

get_all_expression(all(R1,T1),T3) :-
	(get_all_expression(T1,T2) ->
	    T3 = T2
	;
	    T3 = all(R1,T1)
	),
	!.
get_all_expression(T1,A1) :-
	T1 =.. [_|Args],
	get_all_expression_list(Args,A1).
get_all_expression_list([],_) :-
	!,
	fail.
get_all_expression_list([L1|_],A1) :-
	get_all_expression(L1,A1),
	!.
get_all_expression_list([_|L2],A1) :-
	get_all_expression_list(L2,A1).

	
new_predicate(Prefix,Symbol) :-
                ( retract(new_predicate_counter(Prefix,Value)) ; Value = 100 ),
                NewValue is Value+1,
                asserta(new_predicate_counter(Prefix,NewValue)),
                name(Prefix,P),
                name(NewValue,N),
                user:append(P,N,SymbolList),
                name(Symbol,SymbolList), !.
