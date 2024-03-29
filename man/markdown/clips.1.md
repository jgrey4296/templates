# CLIPS 6.30

# COMMANDS

This section gives a general overview of the available CLIPS constructs.

| Subtopics:
|    DEFRULE                    DEFCLASS
|    DEFFACTS                   DEFINSTANCES
|    DEFTEMPLATE                DEFMESSAGE-HANDLER
|    DEFGLOBAL                  DEFMODULE
|    DEFFUNCTION                CONSTRAINT_ATTRIBUTES
|    DEFGENERIC/DEFMETHOD

## DEFRULE

One of the primary methods of representing knowledge in CLIPS is a rule.
A rule is a collection of conditions and the actions to be taken if the
conditions are met.  The developer of an expert system defines the rules
which describe how to solve a problem.  Rules execute (or fire) based on
the existence or non-existence of facts.  CLIPS provides the mechanism
(the inference engine) which attempts to match the rules to the current
state of the system (as represented by the fact-list) and applies the
actions.

~~~
(defrule <rule-name> [<comment>]
    [<declaration>]
    <conditional-element>*
    =>
    <action>*)
~~~

## DECLARATIONS

~~~
<declaration>           ::= (declare <rule-property>+)

<rule-property>         ::= (salience <integer-expression>) |
                            (auto-focus <boolean-symbol>)
~~~

## CONDITIONAL ELEMENTS

~~~
<conditional-element>   ::= <pattern-CE> | <assigned-pattern-CE> |
                            <not-CE> | <and-CE> | <or-CE> |
                            <logical-CE> | <test-CE> |
                            <exists-CE> | <forall-CE>

<test-CE>               ::= (test <function-call>)

<not-CE>                ::= (not <conditional-element>)

<and-CE>                ::= (and <conditional-element>+)

<or-CE>                 ::= (or <conditional-element>+)

<exists-CE>             ::= (exists <conditional-element>+)

<forall-CE>             ::= (forall <conditional-element>
                                    <conditional-element>+)

<logical-CE>            ::= (logical <conditional-element>+)
~~~
## PATTERN CONDITIONAL ELEMENT

~~~
<assigned-pattern-CE>   ::= ?<variable-symbol> <- <pattern-CE>

<pattern-CE>            ::= <ordered-pattern-CE> |
                            <template-pattern-CE> |
                            <object-pattern-CE>

<ordered-pattern-CE>    ::= (<symbol> <constraint>*)

<template-pattern-CE>   ::= (<deftemplate-name <LHS-slot>*)

<object-pattern-CE>     ::= (object <attribute-constraint>*)

<attribute-constraint>  ::= (is-a <constraint>) |
                            (name <constraint>) |
                            (<slot-name> <constraint>*)

<LHS-slot>              ::= <single-field-LHS-slot> |
                            <multifield-LHS-slot>

<LHS-slot>              ::= <single-field-LHS-slot> |
                            <multifield-LHS-slot>

<single-field-LHS-slot> ::= (<slot-name> <constraint>)

<multifield-LHS-slot>   ::= (<slot-name> <constraint>*)
~~~

## PATTERN CONSTRAINTS

~~~
<constraint>            ::= ? | $? | <connected-constraint>

<connected-constraint>
                ::= <single-constraint> |
                    <single-constraint> & <connected-constraint> |
                    <single-constraint> | <connected-constraint>

<single-constraint>     ::= <term> | ~<term>

<term>                  ::= <constant> |
                            <single-field-variable> |
                            <multifield-variable> |
                            :<function-call> |
                            =<function-call>
~~~

## DEFFACTS

With the deffacts construct, a list of facts can be defined which are
automatically asserted whenever the reset command is performed.
Facts asserted through deffacts may be retracted or pattern matched like
any other fact.  The initial fact-list, including any defined deffacts,
is always reconstructed after a reset command.

The syntax of the deffacts construct is:

~~~
(deffacts <deffacts-name> [<comment>]
   <RHS-pattern>*)
~~~

## DEFTEMPLATE

Ordered facts encode information positionally.  To access that information,
a user must know not only what data is stored in a fact but which field
contains the data.  Non-ordered (or deftemplate) facts provide the user
with the ability to abstract the structure of a fact by assigning names
to each field found within the fact.  The deftemplate construct is
used to create a template which can then be used by non-ordered facts to
access fields of the fact by name.  The deftemplate construct is analogous
to a record or structure definition in programming languages such as Pascal
and C.

The syntax of the deftemplate construct is:

~~~
(deftemplate <deftemplate-name> [<comment>]
   <slot-definition>*)

<slot-definition>         ::= <single-slot-definition> |
                              <multislot-definition>

<single-slot-definition>  ::= (slot <slot-name>
                                    <template-attribute>*)

<multislot-definition>    ::= (multislot <slot-name>
                                         <template-attribute>*)

<template-attribute>      ::= <default-attribute> |
                              <constraint-attribute>

<default-attribute>
                   ::= (default ?DERIVE | ?NONE | <expression>*) |
                       (default-dynamic <expression>*)
~~~

## DEFGLOBAL

With the defglobal construct, global variables can be defined, set, and
accessed within the CLIPS environment.  Global variables can be accessed
as part of the pattern matching process, but changing them does not invoke
the pattern matching process.  The bind function is used to set the value
of global variables.

The syntax of the defglobal construct is:

~~~
<defglobal-construct> ::= (defglobal [<defmodule-name>]
                             <global-assignment>*)

<global-assignment>   ::= <global-variable> = <expression>

<global-variable>     ::= ?*<symbol>*
~~~

## DEFFUNCTION

With the deffunction construct, new functions may be defined directly in
CLIPS.  Deffunctions are equivalent in use to other functions in CLIPS.
The only differences between user-defined external functions and
deffunctions are that deffunctions are written in CLIPS and executed
by CLIPS interpretively and user-defined external functions are written
in an external language, such as C, and executed by CLIPS directly.
Also, deffunctions allow the addition of new functions without having to
recompile and relink CLIPS.

The syntax of the deffunction construct is:

~~~
(deffunction <name> [<comment>]
    (<regular-parameter>* [<wildcard-parameter>])
    <action>*)

<regular-parameter>  ::= <single-field-variable>
<wildcard-parameter> ::= <multifield-variable>
~~~

## DEFGENERIC/DEFMETHOD

With the defgeneric/defmethod constructs, new generic functions may be written
directly in CLIPS.  Generic functions are similar to deffunctions because
they can be used to define new procedural code directly in CLIPS, and they can
be called like any other function. However, generic functions are much more
powerful because they can do different things depending on the types
(or classes) and number of their arguments. For example, a '+' operator could
be defined which performs concatenation for strings but still performs
arithmetic addition for numbers.  Generic functions are comprised of
multiple components called methods, where each method handles different
cases of arguments for the generic function.  A generic function which has
more than one method is said to be overloaded.

A generic function is comprised of a header (similar to a forward declaration)
and zero or more methods.  A generic function header can either be explicitly
declared by the user or implicitly declared by the definition of at least one
method. The defgeneric construct is used to specify the generic function
header,
and the defmethod construct is used for each of the generic function's
methods.

The syntax of the defgeneric/defmethod constructs is:

~~~
(defgeneric <name> [<comment>])

(defmethod <name> [<index>] [<comment>]
    (<parameter-restriction>* [<wildcard-parameter>])
    <action>*)

<parameter-restriction> ::= <single-field-variable> |
                            (<single-field-variable> <type>* [<query>])

<wildcard-parameter>    ::= <multifield-variable>

<type>                  ::= <class-name>

<query>                 ::= <global-variable> | <function-call>
~~~

## DEFCLASS

A defclass is a construct for specifying the properties (slots) of a class of
objects.  A defclass consists of four elements: 1) a name, 2) a list of
superclasses from which the new class inherits slots and message-handlers,
3)  a specifier saying whether or not the creation of direct instances of the
new class is allowed and 4) a list of slots specific to the new class.  All
user-defined classes must inherit from at least one class, and to this end
COOL provides predefined system classes for use as a base in the derivation
of new classes.

Any slots explicitly given in the defclass override those gotten from
inheritance.  COOL applies rules to the list of superclasses to generate a
class precedence list for the new class.  Facets further describe slots.
Some examples of facets include: default value, cardinality, and types of
access allowed.

The syntax of the defclass construct is:

~~~
(defclass <name> [<comment>]
  (is-a <superclass-name>+)
  [<role>]
  [<pattern-match-role>]
  <slot>*
  <handler-documentation>*)

<role>  ::= (role concrete | abstract)

<pattern-match-role>
        ::= (pattern-match reactive | non-reactive)

<slot>  ::= (slot <name> <facet>*) |
            (single-slot <name> <facet>*) |
            (multislot <name> <facet>*)

<facet> ::=  <default-facet> | <storage-facet> |
             <access-facet> | <propagation-facet> |
             <source-facet> | <pattern-match-facet> |
             <visibility-facet> | <create-accessor-facet>
             <override-message-facet> | <constraint-attributes>

<default-facet> ::=
           (default ?DERIVE | ?NONE | <expression>*) |
           (default-dynamic <expression>*)

<storage-facet> ::= (storage local | shared)

<access-facet>
       ::= (access read-write | read-only | initialize-only)

<propagation-facet> ::= (propagation inherit | no-inherit)

<source-facet> ::= (source exclusive | composite)

<pattern-match-facet>
       ::= (pattern-match reactive | non-reactive)

<visibility-facet> ::= (visibility private | public)

<create-accessor-facet>
     ::= (create-accessor ?NONE | read | write | read-write)

<override-message-facet>
     ::= (override-message ?DEFAULT | <message-name>)

<handler-documentation>
       ::= (message-handler <name> [<handler-type>])

<handler-type> ::= primary | around | before | after
~~~

## DEFINSTANCES

Similar to deffacts, the definstances construct allows the specification of
instances which will be created every time the reset command is executed.
On every reset all current instances receive a delete message, and the
equivalent of a make-instance function call is made for every instance
specified in definstances constructs.

The syntax of the definstances construct is:

~~~
<definstances-construct>
                ::= (definstances <definstances-name> [<comment>]
                       <instance-template>*)

<instance-template>   ::= (<instance-definition>)

<instance-definition> ::= <instance-name-expression> of
                             <class-name-expression>
                             <slot-override>*

<slot-override>       ::= (<slot-name-expression> <expression>*)
~~~

## DEFMESSAGE-HANDLER

Objects are manipulated by sending them messages via the function send.  The
result of a message is a useful return-value or side-effect.  A
defmessage-handler is a construct for specifying the behavior of a class of
objects in response to a particular message.  The implementation of a message
is made up of pieces of procedural code called message-handlers (or handlers
for short).  Each class in the class precedence list of an object's class can
have handlers for a message.  In this way, the object's class and all its
superclasses share the labor of handling the message.  Each class's handlers
handle the part of the message which is appropriate to that class.  Within a
class, the handlers for a particular message can be further subdivided into
four types or categories: primary, before, after and around.

A defmessage-handler is comprised of seven elements: 1) a class name to which
to attach the handler (the class must have been previously defined), 2) a
message name to which the handler will respond, 3) an optional type (the
default is primary), 4) an optional comment, 5) a list of parameters that will
be passed to the handler during execution, 6) an optional wildcard parameter
and 7) a series of expressions which are executed in order when the handler
is called.  The return-value of a message-handler is the evaluation of the
last
expression in the body.

The syntax of the defmessage-handler construct is:

~~~
(defmessage-handler <class-name> <message-name>
   [<handler-type>] [<comment>]
   (<parameter>* [<wildcard-parameter>])
   <action>*)

<handler-type>       ::= around | before | primary | after

<parameter>          ::= <single-field-variable>

<wildcard-parameter> ::= <multifield-variable>
~~~

## DEFMODULE

CLIPS provides support for the modular development and execution of knowledge
bases with the defmodule construct. CLIPS modules allow a set of constructs to
be grouped together such that explicit control can be maintained over
restricting the access of the constructs by other modules. This type of
control is similar to global and local scoping used in languages such as C or
Ada. By restricting access to deftemplate and defclass constructs, modules can
function as blackboards, permitting only certain facts and instances to be
seen by other modules. Modules are also used by rules to provide execution
control.

The syntax of the defmodule construct is:

~~~
<defmodule-construct> ::= (defmodule <module-name> [<comment>]
                             <port-spec>*)

<port-specification>  ::= (export <port-item>) |
                          (import <module-name> <port-item>)

<port-item>           ::= ?ALL |
                          ?NONE |
                          <port-construct> ?ALL |
                          <port-construct> ?NONE |
                          <port-construct> <construct-name>+

<port-construct>      ::= deftemplate | defclass |
                          defglobal | deffunction | defgeneric
~~~

## CONSTRAINT_ATTRIBUTES

Constraint attributes can be associated with deftemplate and defclass slots so
that type checking can be performed on slot values when template facts and
instances are created. The constraint information is also analyzed for the
patterns on the LHS of a rule to determine if the specified constraints
prevent the rule from ever firing.

The syntax for constraint attributes is:

~~~
<constraint-attribute> ::= <type-attribute>|
                           <allowed-constant-attribute> |
                           <range-attribute> |
                           <cardinality-attribute>
                           <default-attribute>

<type-attribute>       ::= (type <type-specification>)

<type-specification>   ::= <allowed-type>+ | ?VARIABLE

<allowed-type>         ::= SYMBOL | STRING | LEXEME |
                           INTEGER | FLOAT | NUMBER |
                           INSTANCE-NAME | INSTANCE-ADDRESS |
                           INSTANCE |
                           EXTERNAL-ADDRESS | FACT-ADDRESS

<allowed-constant-attribute>
                       ::= (allowed-symbols<symbol-list>) |
                           (allowed-strings <string-list>) |
                           (allowed-lexemes <lexeme-list> |
                           (allowed-integers<integer-list>) |
                           (allowed-floats<float-list>) |
                           (allowed-numbers<number-list>) |
                           (allowed-instance-names <instance-list>) |
                           (allowed-values<value-list>) |

<symbol-list>          ::= <symbol>+ | ?VARIABLE

<string-list>          ::= <string>+ | ?VARIABLE

<lexeme-list>          ::= <lexeme>+ | ?VARIABLE

<integer-list>         ::= <integer>+ | ?VARIABLE

<float-list>           ::= <float>+ | ?VARIABLE

<number-list>          ::= <number>+ | ?VARIABLE

<instance-name-list>   ::= <instance-name>+ | ?VARIABLE

<value-list>           ::= <constant>+ | ?VARIABLE

<range-attribute>      ::= (range <range-specification>
                                  <range-specification>)

<range-specification>  ::= <number> | ?VARIABLE

<cardinality-attribute>
                    ::= (cardinality <cardinality-specification>
                                     <cardinality-specification>)

<cardinality-specification> ::= <integer> | ?VARIABLE
~~~

# FUNCTION_SUMMARY

This section gives a general overview of the available CLIPS functions.

- Subtopics:
|    PREDICATE_FUNCTIONS        DEFRULE_FUNCTIONS
|    MULTIFIELD_FUNCTIONS       AGENDA_FUNCTIONS
|    STRING_FUNCTIONS           DEFGLOBAL_FUNCTIONS
|    IO_FUNCTIONS               DEFFUNCTION_FUNCTIONS
|    MATH_FUNCTIONS             GENERIC_FUNCTION_FUNCTIONS
|    PROCEDURAL_FUNCTIONS       COOL_FUNCTIONS
|    MISCELLANEOUS_FUNCTIONS    DEFMODULE_FUNCTIONS
|    DEFTEMPLATE_FUNCTIONS      SEQUENCE_EXPANSION_FUNCTIONS
|    FACT_FUNCTIONS

### PREDICATE_FUNCTIONS

The following functions perform predicate tests and return
either TRUE or FALSE.

NUMBERP: Returns TRUE for integers and floats.
> (numberp <expression>)

FLOATP: Returns TRUE for floats.
> (floatp <expression>)

INTEGERP: Returns TRUE for integers.
> (integerp <expression>)

LEXEMEP: Returns TRUE for symbols and strings.
> (numberp <expression>)

STRINGP: Returns TRUE for strings.
> (stringp <expression>)

SYMBOLP: Returns TRUE for symbols.
> (symbolp <expression>)

EVENP: Returns TRUE for even numbers.
> (evenp <expression>)

ODDP: Returns TRUE for odd numbers.
> (oddp <expression>)

MULTIFIELDP: Returns TRUE for multifield values.
> (multifieldp <expression>)

POINTERP: Returns TRUE for external addresses.
> (pointerp <expression>)

EQ: Returns TRUE if the 1st argument is equal in type and value
to all subsequent arguments.
> (eq <expression> <expression>+)

NEQ: Returns TRUE if the 1st argument is not equal in type and
     value to all subsequent arguments.
> (neq <expression> <expression>+)

=: Returns TRUE if the 1st argument is equal in value
   to all subsequent arguments.
> (= <numeric-expression> <numeric-expression>+)

<>: Returns TRUE if the 1st argument is not equal in value
    to all subsequent arguments.
> (<> <numeric-expression> <numeric-expression>+)

\>: Returns TRUE if each argument is greater in value than the
    argument following it.
> (> <numeric-expression> <numeric-expression>+)

\>=: Returns TRUE if each argument is greater than or equal to
    in value than the argument following it.
> (>= <numeric-expression> <numeric-expression>+)

<: Returns TRUE if each argument is less in value than the
   argument following it.
> (< <numeric-expression> <numeric-expression>+)

<=: Returns TRUE if each argument is less than or equal to
    in value than the argument following it.
> (<= <numeric-expression> <numeric-expression>+)

AND: Returns TRUE if all arguments evaluate to a non-FALSE value.
> (and <expression>+)

OR: Returns TRUE if any argument evaluates to a non-FALSE value.
> (or <expression>+)

NOT: Returns TRUE if its only argument evaluates to FALSE.
> (not <expression>)

### MULTIFIELD_FUNCTIONS

The following functions operate on multifield values.

CREATE\$: Appends its arguments together to create a multifield value.
> (create\$ <expression>*)

NTH\$: Returns the specified field of a multifield value.
> (nth\$ <integer-expression> <multifield-expression>)

MEMBER\$: Returns the position of a single-field value within a multifield
value.
> (member\$ <single-field-expression> <multifield-expression>)

SUBSETP: Returns TRUE if the first argument is a subset of the second argument.
> (subsetp <multifield-expression> <multifield-expression>)

DELETE\$: Deletes the specified range from a multifield value.
> (delete\$ <multifield-expression>
>          <begin-integer-expression> <end-integer-expression>)

EXPLODE\$: Creates a multifield value from a string.
> (explode\$ <string-expression>)

IMPLODE\$: Creates a string from a multifield value.
> (implode\$ <multifield-expression>)

SUBSEQ\$: Extracts the specified range from a multifield value.
> (subseq\$ <multifield-expression>
>         <begin-integer-expression> <end-integer-expression>)

REPLACE\$: Replaces the specified range of a multifield value with a set of values.
> (replace\$ <multifield-expression>
>           <begin-integer-expression> <end-integer-expression>
>           <single-or-multifield-expression>+)

INSERT\$: Inserts one or more values in a multifield.
> (insert\$ <multifield-expression> <integer-expression>
>          <single-or-multifield-expression>+)

FIRST\$: Returns the first field of a multifield.
> (first\$ <multifield-expression>)

REST\$: Returns all but the first field of a multifield.
> (rest\$ <multifield-expression>)

LENGTH\$: Returns the number of fields in a multifield value.
> (length\$ <multifield-expression>)

DELETE-MEMBER\$: Deletes specific values contained within a multifield value and returns the modified multifield value.
> (delete-member\$ <multifield-expression> <expression>+)

REPLACE-MEMBER\$: Replaces specific values contained within a multifield value and returns the modified multifield value.
> (replace-member\$ <multifield-expression> <substitute-expression>
>                  <search-expression>+)

### STRING_FUNCTIONS

The following functions perform operations that are related to strings.

STR-CAT: Concatenates its arguments to form a single string.
> (str-cat <expression>*)

SYM-CAT: Concatenates its arguments to form a single symbol.
> (sym-cat <expression>*)

SUB-STRING: Retrieves a subportion from a string.
> (sub-string <integer-expression> <integer-expression> <string-expression>)

STR-INDEX: Returns the position of the first argument within the second argument.
> (str-index <lexeme-expression> <lexeme-expression>)

EVAL: Evaluates a string as though it were entered at the command prompt.
      Only allows functions to be evaluated.
> (eval <lexeme-expression>)

BUILD: Evaluates a string as though it were entered at the command prompt.
Only allows constructs to be evaluated.
> (build <lexeme-expression>)

UPCASE: Converts lowercase characters in a string or symbol to uppercase.
> (upcase <lexeme-expression>)

LOWCASE: Converts uppercase characters in a string or symbol to lowercase.
> (lowcase <lexeme-expression>)

STR-COMPARE: Lexigraphically compares two strings.
> (str-compare <lexeme-expression> <lexeme-expression>)

STR-LENGTH: Returns the length of a string.
> (str-length <lexeme-expression>)

CHECK-SYNTAX: Allows the text representation of a construct or function call to be checked for syntax and semantic errors.
> (check-syntax <construct-or-function-string>)

STRING-TO-FIELD: Parses a string and converts its contents to a primitive data type.
> (string-to-field  <string-or-symbol-expression>)

### IO_FUNCTIONS

The following functions perform I/O operations.

OPEN: Opens a file.
> (open <file-name> <logical-name> [<mode>])
> <mode> ::= "r" | "w" | "r+" | "a" | "wb"

CLOSE: Closes a file.
> (close [<logical-name>])

PRINTOUT: Sends unformated output to the specified logical name.
> (printout <logical-name> <expresion>*)

READ: Reads a single-field value from the specified logical name.
> (read [<logical-name>])

READLINE: Reads an entire line as a string from the specified logical name.
> (readline [<logical-name>])

FORMAT: Sends formated output to the specified logical name.
> (format <logical-name> <string-expression> <expression>*)

RENAME: Changes the name of a file.
> (rename <old-file-name> <new-file-name>)

REMOVE: Deletes a file.
> (remove <file-name>)

GET-CHAR: Allows a single character to be retrieved from a logical name.
> (get-char [<logical-name>])

READ-NUMBER: Allows a user to input a single number using the localized format.
> (read-number [<logical-name>])

SET-LOCALE: Allows a locale to be specified for the numeric format behavior of the format and read-number functions.
> (set-locale [<locale-string>])

### MATH_FUNCTIONS

The math functions have been divided into three broad categories. The
basic math functions are always provided with CLIPS. The trigonometric
and extended math functions are included as part of the extended math
package.

| Subtopics:
|     BASIC_MATH_FUNCTIONS       EXTENDED_MATH_FUNCTIONS
|     TRIGONOMETRIC_FUNCTIONS

### BASIC_MATH_FUNCTIONS

The following functions perform basic mathematical operations.

+: Returns the sum of its arguments.
> (+ <numeric-expression> <numeric-expression>+)

\-: Returns the first argument minus all subsequent arguments.
> (- <numeric-expression> <numeric-expression>+)

\*: Returns the product of its arguments.
> (* <numeric-expression> <numeric-expression>+)

/: Returns the first argument divided by all subsequent arguments.
> (/ <numeric-expression> <numeric-expression>+)

DIV: Returns the first argument divided by all subsequent arguments
     using integer division.
> (div <numeric-expression> <numeric-expression>+)

MAX: Returns the value of its largest numeric argument.
> (max <numeric-expression>+)

MIN: Returns the value of its smallest numeric argument.
> (min <numeric-expression>+)

ABS: Returns the absolute value of its only argument.
> (abs <numeric-expression>)

FLOAT: Converts its only argument to a float.
> (float <numeric-expression>)

INTEGER: Converts its only argument to an integer.
> (integer <numeric-expression>)

### TRIGONOMETRIC_FUNCTIONS

The following trigonometric functions take one numeric argument
and return a float.  The argument is expected to be in radians.
These functions are part of the extended math package.

~~~
    FUNCTION         RETURNS
    -----------------------------------
    acos             arccosine
    acosh            hyperbolic arccosine
    acot             arccotangent
    acoth            hyperbolic arccotangent
    acsc             arccosecant
    acsch            hyperbolic arccosecant
    asec             arcsecant
    asech            hyperbolic arcsecant
    asin             arcsine
    asinh            hyperbolic arcsine
    atan             arctangent
    atanh            hyperbolic arctangent
    cos              cosine
    cosh             hyperbolic cosine
    cot              cotangent
    coth             hyperbolic tangent
    csc              cosecant
    csch             hyperbolic cosecant
    sec              secant
    sech             hyperbolic secant
    sin              sine
    sinh             hyperbolic sine
    tan              tangent
    tanh             hyperbolic tangent
~~~

### EXTENDED_MATH_FUNCTIONS

The following functions perform extended mathematical operations
and are included as part of the extended math package.

DEG-GRAD: Converts its only argument from degrees to gradients.
> (deg-grad <numeric-expression>)

DEG-RAD: Converts its only argument from degrees to radians.
> (deg-rad <numeric-expression>)

GRAD-DEG: Converts its only argument from gradients to degrees.
> (grad-deg <numeric-expression>)

RAD-DEG: Converts its only argument from radians to degrees.
> (rad-deg <numeric-expression>)

PI: Returns the value of pi.
> (pi)

SQRT: Returns the square root of its only argument.
> (sqrt <numeric-expression>)

\**: Raises its first argument to the power of its second argument.
> (** <numeric-expression> <numeric-expression>)

EXP: Raises the value e to the power of its only argument.
> (exp <numeric-expression>)

LOG: Returns the logarithm base e of its only argument.
> (log <numeric-expression>)

LOG10: Returns the logarithm base 10 of its only argument.
> (log10 <numeric-expression>)

ROUND: Rounds its argument toward the closest integer or negative infinity if exactly between two integers.
> (round <numeric-expression>)

MOD: Returns the remainder of the result of dividing its first argument by its second argument (assuming that the result of division must be an integer).
> (mod <numeric-expression> <numeric-expression>)

### PROCEDURAL_FUNCTIONS

The following are functions which provide procedural programming
capabilities as found in languages such as Pascal, C, and Ada.

BIND: Binds a variable to a new value.
> (bind <variable> <expression>*)

IF: Allows conditional execution of a group of actions.
> (if <expression> then <action>* [else <action>*])

WHILE: Allows conditional looping.
> (while <expression> [do] <action>*)

LOOP-FOR-COUNT: Allows simple iterative looping.
> (loop-for-count <range-spec> [do] <action>*)
><range-spec>  ::= <end-index> |
>                  (<loop-variable> [<start-index> <end-index>])
> <start-index> ::= <integer-expression>
> <end-index>   ::= <integer-expression>

PROGN: Evaluates all arguments and returns the value of the last
argument evaluated.
> (progn <expression>*)

PROGN$: Performs a set of actions for each field of a multifield value.
> (progn$ <list-spec> <expression>*)
> <list-spec> ::= <multifield-expression> |
>                (<list-variable> <multifield-expression>)

RETURN: Immediately terminates the currently executing deffunction,
generic function method, message-handler, defrule RHS, or
certain instance set query functions and if a value is
specified, returns this value as the result of the executing
construct.
> (return [<expression>])

BREAK: Immediately terminates the currently iterating while loop,
progn execution, or certain instance set query functions.
> (break)

SWITCH: Allows a particular group of actions to be performed based
on a specified value.

~~~
 (switch <test-expression>
    <case-statement>*
    [<default-statement>])
 <case-statement> ::= (case <comparison-expression> then <action>*)
 <default-statement> ::= (default <action>*)
~~~

### MISCELLANEOUS_FUNCTIONS

The following are additional functions for use within CLIPS.

GENSYM: Returns a special sequenced symbol.
> (gensym)

GENSYM*: Returns a special unique sequenced symbol.
> (gensym*)

SETGEN: Sets the starting number used by gensym and gensym*.
> (setgen <integer-expression>)

RANDOM: Returns a "random" integer value.
> (random [<start-integer-expression> <end-integer-expression>])

SEED: Seeds the random number generator used by random.
> (seed <integer-expression>)

TIME: Returns a float representing the elapsed seconds since
the system reference time.
> (time)

LENGTH: Returns an integer for the number of fields in a multifield value
or the length in characters of a string or symbol.
> (length <lexeme-or-multifield-expression>)

GET-FUNCTION_RESTRICTIONS: Returns the restriction string associated with
a CLIPS or user defined function.
> (get-function-restrictions <function-name>)

SORT: Allows a list of values to be sorted based on a user specified
comparison function.
> (sort <comparison-function-name> <expression>*)

FUNCALL: Constructs a function call from its arguments and then
evaluates the function call.
> (funcall (function-name> <expression>*)

TIMER: Returns the number of seconds elapsed evaluating a series of
expressions.
> (timer <expression>*)

### DEFTEMPLATE_FUNCTIONS

The following functions provide ancillary capabilities for the deftemplate
construct.

DEFTEMPLATE-MODULE: Returns the module in which the specified deftemplate is
defined.
> (deftemplate-module <deftemplate-name>)

DEFTEMPLATE-SLOT-ALLOWED-VALUES: Returns a multifield containing the allowed values for a deftemplate slot.
> (deftemplate-slot-allowed-values <deftemplate-name> <slot-name>)

DEFTEMPLATE-SLOT-CARDINALITY: Returns a multifield containing the minimum and maximum cardinality allowed for a multifield slot.
> (deftemplate-slot-cardinality <deftemplate-name> <slot-name>)

DEFTEMPLATE-SLOT-DEFAULTP: Returns either static, dynamic, or FALSE to indicate whether the deftemplate slot has a default.
> (deftemplate-slot-defaultp <deftemplate-name> <slot-name>)

DEFTEMPLATE-SLOT-DEFAULT-VALUE: Returns the default value for the deftemplate slot.
> (deftemplate-slot-default-value <deftemplate-name> <slot-name>)

DEFTEMPLATE-SLOT-EXISTP: Returns TRUE if the specified deftemplate slot exists, otherwise FALSE.
> (deftemplate-slot-existp <deftemplate-name> <slot-name>)

DEFTEMPLATE-SLOT-MULTIP: Returns TRUE if the specified deftemplate slot is a multifield slot, otherwise FALSE.
> (deftemplate-slot-multip <deftemplate-name> <slot-name>)

DEFTEMPLATE-SLOT-NAMES: Returns the slot names associated with the deftemplate in a multifield value.
> (deftemplate-slot-names <deftemplate-name>)

DEFTEMPLATE-SLOT-RANGE: Returns a multifield containing the minimum and maximum numeric range allowed for a slot.
> (deftemplate-slot-range <deftemplate-name> <slot-name>)

DEFTEMPLATE-SLOT-SINGLEP: Returns TRUE if the specified deftemplate slot is a single-field slot, otherwise FALSE.
> (deftemplate-slot-singlep <deftemplate-name> <slot-name>)

DEFTEMPLATE-SLOT-TYPES: Returns a multifield containing the primitive types allowed for a slot.
> (deftemplate-slot-types <deftemplate-name> <slot-name>)

GET-DEFTEMPLATE-LIST: Returns the list of all deftemplates in the specified module (or the current module if unspecified).
> (get-deftemplate-list [<module-name>])

### ENTRY-FACT_FUNCTIONS

The following actions are used for assert, retracting, and modifying facts.

ASSERT: Adds a fact to the fact-list.
> (assert <RHS-pattern>+)

RETRACT: Removes a fact from the fact-list.

~~~
 (retract <retract-specifier>+ | *)
 <retract-specifier> ::= <fact-specifier> | <integer-expression>
~~~

MODIFY: Modifies a deftemplate fact in the fact-list.
> (modify <fact-specifier> <RHS-slot>*)

DUPLICATE: Duplicates a deftemplate fact in the fact-list.
> (duplicate <fact-specifier> <RHS-slot>*)

ASSERT-STRING: Converts a string into a fact and asserts it.
> (assert-string <string-expression>)

FACT-INDEX: Returns the fact index of a fact address.
> (fact-index <fact-address>)

FACT-EXISTP: Returns TRUE if the fact specified by its fact-index or fact-address arguments exists, otherwise FALSE.
> (fact-existp <fact-address-or-index>)

FACT-RELATION: Returns the deftemplate (relation) name associated with the fact.
> (fact-relation <fact-address-or-index>)

FACT-SLOT-NAMES: Returns the slot names associated with the fact.
> (fact-slot-names <fact-address-or-index>)

FACT-SLOT-VALUE: Returns the value of the specified slot from the specified fact.
> (fact-slot-value <fact-address-or-index> <slot-name>)

GET-FACT-LIST: Returns a multifield containing the list of visible facts.
> (get-fact-list [<module-name>])

### DEFFACTS_FUNCTIONS

The following functions provide ancillary capabilities for the deffacts
construct.

GET-DEFFACTS-LIST: Returns the list of all deffacts in the specified module (or the current module if unspecified).
> (get-deffacts-list [<module-name>])

DEFFACTS-MODULE: Returns the module in which the specified deffacts is defined.
> (deffacts-module <deffacts-name>)

### DEFRULE_FUNCTIONS

The following functions provide ancillary capabilities for the defrule
construct.

GET-DEFRULE-LIST: Returns the list of all defrules in the specified module (or the current module if unspecified).
> (get-defrule-list [<module-name>])

DEFRULE-MODULE: Returns the module in which the specified defrule is defined.
> (defrule-module <defrule-name>)

### AGENDA_FUNCTIONS

The following functions provide ancillary capabilities for manipulating the
agenda.

GET-FOCUS: Returns the module name of the current focus.
> (get-focus)

GET-FOCUS-STACK: Returns all of the module names in the focus stack as a multifield value.
> (get-focus-stack)

POP-FOCUS: Removes the current focus from the focus stack and returns the module name of the current focus.
> (pop-focus)

### DEFGLOBAL_FUNCTIONS

The following functions provide ancillary capabilities for the defglobal
construct.

GET-DEFGLOBAL-LIST: Returns the list of all defglobals in the specified module (or the current module if unspecified).
> (get-defglobal-list [<module-name>])

DEFGLOBAL-MODULE: Returns the module in which the specified defglobal is defined.
> (defglobal-module <defglobal-name>)

### DEFFUNCTION_FUNCTIONS

The following functions provide ancillary capabilities for the deffunction
construct.

GET-DEFFUNCTION-LIST: Returns the list of all deffunctions in the specified module (or the current module if unspecified).
> (get-deffunction-list [<module-name>])

DEFFUNCTION-MODULE: Returns the module in which the specified deffunction is defined.
> (deffunction-module <deffunction-name>)

### GENERIC_FUNCTION_FUNCTIONS

The following functions provide ancillary capabilities for generic
function methods.

GET-DEFGENERIC-LIST: Returns the list of all defgenerics in the specified module (or the current module if unspecified).
> (get-defgeneric-list [<module-name>])

DEFGENERIC-MODULE: Returns the module in which the specified defgeneric is defined.
> (defgeneric-module <defgeneric-name>)

GET-DEFMETHOD-LIST: Returns the list of all defmethods in the current module (or just the methods associated with the specified defgeneric).
> (get-defmethod-list [<defgeneric-name>])

TYPE: Returns a symbol which is the name of the type (or class) of its of argument.
> (type <expression>)

NEXT-METHODP: If called from a method for a generic function, the function next-methodp will return the symbol TRUE if there is another method shadowed by the current one. Otherwise, the function will return the symbol FALSE.
> (next-methodp)

CALL-NEXT-METHOD: Calls the next shadowed method.
> (call-next-method)

OVERRIDE-NEXT-METHOD: Calls the next shadowed method allowing new arguments to be provided.
> (override-next-method <expression>*)

CALL-SPECIFIC-METHOD: Calls a particular method of a generic function without regards to method precedence.
> (call-specific-method <generic-function> <method-index> <expression>*)

GET-METHOD-RESTRICTIONS: Returns a multifield value containing information about the restrictions for the specified method.
> (get-method-restrictions <generic-function-name> <method-index>)

### COOL_FUNCTIONS

The functions manipulating the CLIPS Object-Oriented Language (COOL)
are divided into five categories.

| Subtopics:
| CLASS_FUNCTIONS                    INSTANCE_SLOT_FUNCTIONS
| INSTANCE_MANIPULATION_FUNCTIONS    MESSAGE-HANDLER_FUNCTIONS
| DEFINSTANCES_FUNCTIONS             INSTANCE_PREDICATE_FUNCTIONS

### CLASS_FUNCTIONS

The following functions are used with classes.

GET-DEFCLASS-LIST: Returns the list of all defclasses in the specified module (or the current module if unspecified).
> (get-defclass-list [<module-name>])

DEFCLASS-MODULE: Returns the module in which the specified defclass is defined.
> (defclass-module <defclass-name>)

CLASS-EXISTP: Returns TRUE if the specified class is defined, FALSE otherwise.
> (class-existp <class-name>)

SUPERCLASSP: Returns TRUE if the first class is a superclass of the second class, FALSE otherwise.
> (superclassp <class1-name> <class2-name>)

SUBCLASSP: Returns TRUE if the first class is a subclass of the second class, FALSE otherwise.
> (subclassp <class1-name> <class2-name>)

SLOT-EXISTP: Returns TRUE if the specified slot is present in the class, FALSE otherwise. If the inherit keyword is specified, then the slot may be inherited.
> (slot-existp <class-name> <slot-name> [inherit])

SLOT-WRITABLEP: Returns TRUE if the specified slot is writable, otherwise FALSE.
> (slot-writablep <class-name> <slot-name>)

SLOT-INITABLEP: Returns TRUE if the specified slot is initializable, otherwise FALSE.
> (slot-initablep <class-name> <slot-name>)

SLOT-PUBLICP: Returns TRUE if the specified slot is public, otherwise FALSE.
> (slot-initablep <class-name> <slot-name>)

SLOT-DIRECT-ACCESSP: Returns TRUE if the specified slot can be accessed directly, otherwise FALSE.
> (slot-direct-accessp <class-name> <slot-name>)

MESSAGE-HANDLER-EXISTP: Returns TRUE if the specified message-handler is defined (directly, not by inheritance) for the class, FALSE otherwise.
> (message-handler-existp <class-name> <handler-name> [<handler-type>])
> <handler-type> ::= around | before | primary | after

CLASS-ABSTRACTP: Returns TRUE if the specified class is abstract, FALSE otherwise.
> (class-abstractp <class-name>)

CLASS-REACTIVEP: Returns TRUE if the specified class is reactive, FALSE otherwise.
> (class-reactivep <class-name>)

CLASS-SUPERCLASSES: Returns the names of the direct superclasses of a class in a multifield variable. If the optional "inherit" argument is given, indirect superclasses are also included.
> (class-superclasses <class-name> [inherit])

CLASS-SUBCLASSES: Returns the names of the direct subclasses of a class in a multifield variable. If the optional "inherit" argument is given, indirect subclasses are also included.
> (class-subclasses <class-name> [inherit])

CLASS-SLOTS: Returns the names of the explicitly defined slots of a class in a multifield variable. If the optional inherit keyword is given, inherited slots are also included.
> (class-slots <class-name> [inherit])

GET-DEFMESSAGE-HANDLER-LIST: Returns the class names, message names, and
message types of the message-handlers directly
attached to a class in a multifield variable. If
the optional inherit keyword is given, inherited
message-handlers are also included.
> (get-defmessage-handler-list <class-name> [inherit])

SLOT-FACETS: Returns the facet values for the specified slot of a class in a
multifield value.
> (slot-facets <class-name> <slot-name>)

SLOT-SOURCES: Returns the names of the classes which provide facets for a
slot of a class in a multifield variable.
> (slot-sources <class-name> <slot-name>)

SLOT-TYPES: Returns the names of the primitive types allowed for a slot
in a multifield variable.
> (slot-types <class-name> <slot-name>)

SLOT-CARDINALITY: Returns the minimum and maximum number of fields allowed
for a multislot in a multifield variable.
> (slot-cardinality <class-name> <slot-name>)

SLOT-ALLOWED-VALUES: Returns the allowed values for a slot in a
multifield value.
> (slot-allowed-values <class-name> <slot-name>)

SLOT-RANGE: Returns the minimum and maximum numeric values allowed
for a slot.
> (slot-range <class-name> <slot-name>)

SLOT-DEFAULT-VALUE: Returns the default value associated with a slot.
> (slot-default-value <class-name> <slot-name>)

SET-CLASS-DEFAULTS-MODE: Sets the defaults mode used when classes are
defined.
> (set-class-defaults-mode <mode>)
> <mode> ::= convenience | conservation

GET-CLASS-DEFAULTS-MODE: Returns the current defaults mode used when
classes are defined.
> (get-class-defaults-mode)

SLOT-ALLOWED-CLASSES: Returns the allowed classes for a slot in a
multifield value.
> (slot-allowed-classes <class-name> <slot-name>)

### MESSAGE-HANDLER_FUNCTIONS

The following functions are used with message-handlers.

NEXT-HANDLERP: Returns TRUE if there is another message-handler available
for execution, FALSE otherwise.
> (next-handlerp)

CALL-NEXT-HANDLER: Calls the next shadowed handler.
> (call-next-handler)

OVERRIDE-NEXT-HANDLER: Calls the next shadowed handler and allows the
arguments to be changed.
> (override-next-handler <expression>*)

### DEFINSTANCES_FUNCTIONS

The following functions are used with definstances.

GET-DEFINSTANCES-LIST: Returns the list of all definstances in the specified
module (or the current module if unspecified).
> (get-definstances-list [<module-name>])

DEFINSTANCES-MODULE: Returns the module in which the specified definstance
is defined.
> (definstances-module <definstances-name>)

### INSTANCE_MANIPULATION_FUNCTIONS

The following manipulation functions are used with instances.

INIT-SLOTS: Implements the init message-handler attached to the class
USER. This function should never be called directly unless
an init message-handler is being defined such that the one
attached to USER will never be called.
> (init-slots)

UNMAKE-INSTANCE: Deletes the specified instance by sending it
the delete message.
> (unmake-instance <instance-expression> | *)

DELETE-INSTANCE: Deletes the active instance when called from within
the body of a message-handler.
> (delete-instance)

CLASS: Returns a symbol which is the name of the class of its argument.
> (class <object-expression>)

INSTANCE-NAME: Returns a symbol which is the name of its instance argument.
> (instance-name <instance-expression>)

INSTANCE-ADDRESS: Returns the address of its instance argument.
> (instance-address <instance-expression>)

SYMBOL-TO-INSTANCE-NAME: Converts a symbol to an instance name.
> (symbol-to-instance-name <symbol-expression>)

INSTANCE-NAME-TO-SYMBOL: Converts an instance name to a symbol.
> (instance-name-to-symbol <instance-name-expression>)

### INSTANCE_PREDICATE_FUNCTIONS

The following predicate functions are used with instances.

INSTANCEP: Returns TRUE if its argument is an instance name or instance
address, FALSE otherwise.
> (instancep <expression>)

INSTANCE-ADDRESSP: Returns TRUE if its argument is an instance address,
FALSE otherwise.
> (instance-addressp <expression>)

INSTANCE-NAMEP: Returns TRUE if its argument is an instance name,
FALSE otherwise.
> (instance-namep <expression>)

INSTANCE-EXISTP: Returns TRUE if the specified instance exists,
FALSE otherwise.
> (instance-existp <instance-expression>)

### INSTANCE_SLOT_FUNCTIONS

The following functions are used to manipulate instance slots.

DYNAMIC-GET: Returns the value of the specified slot of the active instance.
> (dynamic-get <slot-name-expression>)

DYNAMIC-PUT: Sets the value of the specified slot of the active instance.
> (put <slot-name-expression> <expression>*)

SLOT-REPLACE\$: Allows the replacement of a range of fields in a multifield
slot value.
> (slot-replace\$ <instance-expression> <mv-slot-name>
>                <range-begin> <range-end> <expression>+)

DIRECT-SLOT-REPLACE\$: Allows the replacement of a range of fields in a
multifield slot value of the active instance from
within a message-handler.
> (direct-slot-replace\$ <mv-slot-name> <range-begin> <range-end> <expression>+)

SLOT-INSERT\$: Allows the insertion of one or more values in a multifield
slot value.
> (slot-insert\$ <instance-expression> <mv-slot-name> <index> <expression>+)

DIRECT-SLOT-INSERT\$: Allows the insertion of one or more values in a
multifield slot value of the active instance from
within a message-handler.
> (direct-slot-insert\$ <mv-slot-name> <index> <expression>+)

SLOT-DELETE\$: Allows the deletion of a range of fields in a multifield
slot value.
> (slot-delete\$ <instance-expression> <mv-slot-name> <range-begin> <range-end>)

DIRECT-SLOT-DELETE\$: Allows the deletion of a range of fields in a multifield
slot value of the active instance from within a
message-handler.
> (direct-slot-delete\$ <mv-slot-name> <range-begin> <range-end>)

### DEFMODULE_FUNCTIONS

The following functions provide ancillary capabilities for the defmodule
construct.

GET-DEFMODULE-LIST: Returns the list of all defmodules.
> (get-defmodule-list)

### SEQUENCE_EXPANSION_FUNCTIONS

The following functions provide ancillary capabilities for the sequence
expansion operator.

EXPAND\$: When used inside of a function call, expands its arguments
as separate arguments to the function. The \$ operator is
merely a shorthand notation for the expand\$ function call.
> (expand\$ <multifield-expression>)

SET-SEQUENCE-OPERATOR-RECOGNITION: Sets the sequence operator recognition
behavior.
> (set-sequence-operator-recognition <boolean-expression>)

GET-SEQUENCE-OPERATOR-RECOGNITION: Returns the current value of the sequence
operator recognition behavior.
> (get-sequence-operator-recognition)

# COMMAND_SUMMARY

This section gives a general overview of the available CLIPS commands.

| Subtopics:
|     ENVIRONMENT_COMMANDS       DEFFUNCTION_COMMANDS
|     DEBUGGING_COMMANDS         GENERIC_FUNCTION_COMMANDS
|     DEFTEMPLATE_COMMANDS       COOL_COMMANDS
|     FACT_COMMANDS              DEFMODULE_COMMANDS
|     DEFFACTS_COMMANDS          MEMORY_COMMANDS
|     DEFRULE_COMMANDS           TEXT_PROCESSING_COMMANDS
|     AGENDA_COMMANDS            PROFILING_COMMANDS
|     DEFGLOBAL_COMMANDS

### ENVIRONMENT_COMMANDS

The following commands control the CLIPS environment.

LOAD: Loads constructs from a file.
> (load <file-name>)

LOAD*: Loads constructs from a file without displaying informational
messages.
> (load* <file-name>)

SAVE: Saves constructs to a file.
> (save <file-name>)

BLOAD: Loads a binary image from a file.
> (bload <file-name>)

BSAVE: Saves a binary image to a file.
> (bsave <file-name>)

CLEAR: Clears the CLIPS environment.
> (clear)

EXIT: Exits the CLIPS environment.
> (exit)

RESET: Resets the CLIPS environment.
> (reset)

BATCH: Executes commands from a file.
> (batch <file-name>)

BATCH*: Executes commands from a file. Unlike the batch command,
evaluates all of the commands in the specified file before
returning rather than replacing standard input.
> (batch* <file-name>)

OPTIONS: Lists the settings of CLIPS compiler flags.
> (options)

SYSTEM: Appends its arguments together to form a command which is
then sent to the operating system.
> (system <lexeme-expression>*)

SET-AUTO-FLOAT-DIVIDEND: Sets the auto-float dividend behaviour.
> (set-auto-float-dividend <boolean-expression>)

GET-AUTO-FLOAT-DIVIDEND: Returns the current value of the auto-float
dividend behaviour.
> (get-auto-float-dividend)

SET-DYNAMIC-CONSTRAINT-CHECKING: Sets the dynamic constraint checking
behaviour.
> (set-dynamic-constraint-checking <boolean-expression>)

GET-DYNAMIC-CONSTRAINT-CHECKING: Returns the current value of the dynamic
constraint checking behaviour.
> (get-dynamic-constraint-checking)

SET-STATIC-CONSTRAINT-CHECKING: Sets the static constraint checking
behaviour.
> (set-static-constraint-checking <boolean-expression>)

GET-STATIC-CONSTRAINT-CHECKING: Returns the current value of the static
constraint checking behaviour.
> (get-static-constraint-checking)

APROPOS: Displays all symbols currently defined in CLIPS which contain
a specified substring
> (apropos <lexeme>)

### DEBUGGING_COMMANDS

The following commands control the CLIPS debugging features.

DRIBBLE-ON: Sends trace information to the specified file.
> (dribble-on <file-name>)

DRIBBLE-OFF: Closes the trace file.
> (dribble-off)

WATCH: Enables trace information for the specified item.
> (watch <watch-item>)

~~~
<watch-item> ::= all |
                 compilations |
                 statistics |
                 focus |
                 messages |
                 deffunctions <deffunction-name>* |
                 globals <global-name>* |
                 rules <rule-name>* |
                 activations <rule-name>* |
                 facts <deftemplate-name>* |
                 instances <class-name>* |
                 slots <class-name>* |
                 message-handlers <handler-spec-1>* [<handler-spec-2>]) |
                 generic-functions <generic-name>* |
                 methods <method-spec-1>* [<method-spec-2>]

<handler-spec-1> ::= <class-name> <handler-name> <handler-type>
<handler-spec-2> ::= <class-name> [<handler-name> [<handler-type>]]

<method-spec-1> ::= <generic-name> <method-index>
<method-spec-2> ::= <generic-name> [<method-index>]
~~~

UNWATCH: Disables trace information for the specified item.
> (unwatch <watch-item>)

LIST-WATCH-ITEMS: Displays the current state of watch items.
> (list-watch-items [<watch-item>])

### DEFTEMPLATE_COMMANDS

The following commands manipulate deftemplates.

PPDEFTEMPLATE: Displays the text of a given deftemplate.
> (ppdeftemplate <deftemplate-name>)

LIST-DEFTEMPLATES: Displays the list of all deftemplates in the specified
module (or the current module if none specified).
> (list-deftemplates [<module-name>])

UNDEFTEMPLATE: Deletes a deftemplate.
> (undeftemplate <deftemplate-name>)

### FACT_COMMANDS

The following commands display information about facts.

FACTS: Display the facts in the fact-list.
> (facts [<module-name>]
>       [<start-integer-expression>
>       [<end-integer-expression>
>       [<max-integer-expression>]]])

LOAD-FACTS: Asserts facts loaded from a file.
> (load-facts <file-name>)

SAVE-FACTS: Saves facts to a file.
> (save-facts <file-name> [<save-scope> <deftemplate-names>*])
> <save-scope> ::= visible | local

DEPENDENCIES: Lists the partial matches from which a fact or
instance receives logical support.
> (dependencies <fact-or-instance-specifier>)

DEPENDENTS: Lists all facts or instances which receive logical support
from a fact or instance.
> (dependents <fact-or-instance-specifier>)

SET-FACT-DUPLICATION: Sets the fact duplication behavior.
> (set-fact-duplication <boolean-expression>)

GET-FACT-DUPLICATION: Returns the fact duplication behavior.
> (get-fact-duplication)

PPFACT: Displays the text of a given fact.
> (ppfact <fact-specifier> [<logical-name> [<ignore-defaults-flag>]])

### DEFFACTS_COMMANDS

The following commands manipulate deffacts.

PPDEFFACTS: Displays the text of a given deffacts.
> (ppdeffacts <deffacts-name>)

LIST-DEFFACTS: Displays the list of all deffacts in the specified
module (or the current module if none specified).
> (list-deffacts [<module-name>])

UNDEFFACTS: Deletes a deffacts.
> (undeffacts <deffacts-name>)

### DEFRULE_COMMANDS

The following commands manipulate defrules.

PPDEFRULE: Displays the text of a given rule.
> (ppdefrule <rule-name>)

LIST-DEFRULES: Displays the list of all defrules in the specified
module (or the current module if none specified).
> (list-defrules [<module-name>])

UNDEFRULE: Deletes a defrule.
> (undefrule <rule-name>)

MATCHES: Displays the facts which match the patterns of a rule.
> (matches <rule-name>)

SET-BREAK: Sets a breakpoint on a rule.
> (set-break <rule-name>)

REMOVE-BREAK: Removes a breakpoint on a rule.
> (remove-break [<rule-name>])

SHOW-BREAKS: Displays all rules having breakpoints.
> (show-breaks [<module-name>])

REFRESH: Places all current activations of a rule on the agenda.
> (refresh <rule-name>)

SET-INCREMENTAL-RESET: Sets the incremental reset behavior.
> (set-incremental-reset <boolean-expression>)

GET-INCREMENTAL-RESET: Returns the incremental reset behavior.
> (get-incremental-reset)

### AGENDA_COMMANDS

The following commands manipulate the agenda.

AGENDA: Displays all activations on the agenda of the specified module.
> (agenda [<module-name>])

RUN: Starts execution of rules.  Rules fire until agenda is empty or
the number of rule firings limit specified by the first argument
is reached (infinity if unspecified).
> (run [<integer-expression>])

FOCUS: Pushes one or more modules onto the focus stack.
> (focus <module-name>+)

HALT: Stops rule execution.
> (halt)

SET-STRATEGY: Sets the current conflict resolution strategy.
> (set-strategy <strategy>)
> <strategy> ::= depth | breadth | simplicity | complexity | lex | mea | random

GET-STRATEGY: Returns the current conflict resolution strategy.
> (get-strategy)

LIST-FOCUS-STACK: Lists all module names on the focus stack.
> (list-focus-stack)

CLEAR-FOCUS-STACK: Removes all modules from the focus stack.
> (clear-focus-stack)

SET-SALIENCE-EVALUATION: Sets the salience evaluation behavior.
> (set-salience-evaluation <behavior>)
> <behavior> ::= when-defined | when-activated | every-cycle

GET-SALIENCE-EVALUATION: Returns the salience evaluation behavior.
> (get-salience-evaluation)

REFRESH-AGENDA: Forces reevaluation of salience of rules on the agenda
of the specified module.
> (refresh-agenda [<module-name>])

### DEFGLOBAL_COMMANDS

The following commands manipulate defglobals.

PPDEFGLOBAL: Displays the text required to define a given global variable.
> (ppdefglobal <global-variable-name>)

LIST-DEFGLOBALS: Displays the list of all defglobals in the specified
module (or the current module if none specified).
> (list-defglobals [<module-name>])

UNDEFGLOBAL: Deletes a global variable.
> (undefglobal <global-variable-name>)

SHOWS-DEFGLOBALS: Displays the name and current value of all defglobals
in the specified module (or the current module if none
specified).
> (show-defglobals [<module-name>])

SET-RESET-GLOBALS: Sets the reset global variables behavior.
> (set-reset-globals <boolean-expression>)

GET-RESET-GLOBALS: Returns the reset global variables behavior.
> (get-reset-globals)

### DEFFUNCTION_COMMANDS

The following commands manipulate deffunctions.

PPDEFFUNCTION: Displays the text of a given deffunction.
> (ppdeffunction <deffunction-name>)

LIST-DEFFUNCTIONS: Displays the list of all deffunctions in the specified
module (or the current module if none specified).
> (list-deffunctions [<deffunction-name>])

UNDEFFUNCTION: Deletes a deffunction.
> (undeffunction <deffunction-name>)

### GENERIC_FUNCTION_COMMANDS

The following commands manipulate generic functions.

PPDEFGENERIC: Displays the text of a given generic function header.
> (ppdefgeneric <generic-function-name>)

PPDEFMETHOD: Displays the text of a given method.
> (ppdefmethod <generic-function-name> <index>)

LIST-DEFGENERICS: Displays the names of all generic functions in the specified
module (or the current module if none specified).
> (list-defgenerics [<module-name>])

LIST-DEFMETHODS: Displays a list of generic function methods.
> (list-defmethods [<generic-function-name>])

UNDEFGENERIC: Deletes a generic function.
> (undefgeneric <generic-function-name>)

UNDEFMETHOD: Deletes a generic function method.
> (undefmethod <generic-function-name> <index>)

PREVIEW-GENERIC: Lists all applicable methods for a particular generic
function call in order of decreasing precedence.
> (preview-generic <generic-function-name> <expression>*)

### COOL_COMMANDS

The commands manipulating the CLIPS Object-Oriented Language (COOL)
are divided into four categories.

| Subtopics:
|     CLASS_COMMANDS                MESSAGE-HANDLER_COMMANDS
|     DEFINSTANCES_COMMANDS         INSTANCES_COMMANDS

### CLASS_COMMANDS

The following commands manipulate defclasses.

PPDEFCLASS: Displays the text of a given defclass.
> (ppdefclass <class-name>)

LIST-DEFCLASSES: Displays the list of all defclasses in the specified
module (or the current module if none specified).
> (list-defclasses [<module-name>])

UNDEFCLASS: Deletes a defclass, all its subclasses, and all
associated instances.
> (undefclass <class-name>)

DESCRIBE-CLASS: Provides a verbose description of a class.
> (describe-class <class-name>)

BROWSE-CLASSES: Provides a rudimentary display of the inheritance
                relationships between a class and all its subclasses.
> (browse-classes [<class-name>])

### MESSAGE-HANDLER_COMMANDS

> The following commands manipulate defmessage-handlers. Note that
> <handler-type> is defined as follows:
> <handler-type> ::= around | before | primary | after

PPDEFMESSAGE-HANDLER: Displays the text of a given defmessage-handler.
> (ppdefmessage-handler <class-name> <handler-name> [<handler-type>])

LIST-DEFMESSAGE-HANDLERS: Displays a list of all (or some) defmessage-
handlers.
> (list-defmessage-handlers [<class-name> [<handler-name> [<handler-type>]]])

UNDEFMESSAGE-HANDLER: Deletes a defmessage-handler.
> (undefmessage-handler <class-name> <handler-name> [<handler-type>])

PREVIEW-SEND: Displays a list of all the applicable message-handlers for
a message sent to an instance of a particular class.
> (preview-send <class-name> <message-name>)

### DEFINSTANCES_COMMANDS

The following commands manipulate definstances.

PPDEFINSTANCES: Displays the text of a given definstances.
> (ppdefinstances <definstances-name>)

LIST-DEFINSTANCES: Displays the list of all definstances in the specified
module (or the current module if none specified).
> (list-definstances [<module-name>])

UNDEFINSTANCES: Deletes a definstances.
> (undefinstances <definstances-name>)

### INSTANCES_COMMANDS

The following commands manipulate instances of user-defined classes.

INSTANCES: Displays a list of instances.
> (instances [<module-name> [<class-name> [inherit]]])

PPINSTANCE: Prints the slots of the active instance when called from
within the body of a message-handler.
> (ppinstance)

SAVE-INSTANCES: Saves all instances to the specified file.
> (save-instances <file-name>)

LOAD-INSTANCES: Loads instances from the specified file.
> (load-instances <file-name>)

RESTORE-INSTANCES: Loads instances from the specified file.
> (restore-instances <file-name>)

### DEFMODULE_COMMANDS

The following commands manipulate defmodules.

PPDEFMODULE: Displays the text of a given defmodule.
> (ppdefmodule <defmodule-name>)

LIST-DEFMODULES: Displays the list of all defmodules.
> (list-defmodules)

SET-CURRENT-MODULE: Sets the current module.
> (set-current-module <module-name>)

GET-CURRENT-MODULE: Returns the current module.
> (get-current-module)

### MEMORY_COMMANDS

The following commands display CLIPS memory status information.

MEM-USED: Returns the number of bytes of memory CLIPS is using.
> (mem-used)

MEM-REQUESTS: Returns the number of times CLIPS has requested memory
from the operating system.
> (mem-requests)

RELEASE-MEM: Releases all free memory held internally by CLIPS to
the operating system. Returns the amount of memory freed.
> (release-mem)

CONSERVE-MEM: Turns on or off the storage of information used for the
save and pretty-print commands.
> (conserve-mem <status>)
> <status> ::= on | off

### TEXT_PROCESSING_COMMANDS

The following commands can be used by users to maintain their own
information system similar to the help facility.

FETCH: Loads the named file into the internal lookup table.
> (fetch <file-name>)

PRINT-REGION: Looks up the specified entry in a particular file which has
been previously loaded into the lookup table and prints the
contents of that entry to the specified logical name.
> (print-region <logical-name> <lookup-file> <topic-field>*)

GET-REGION: Looks up a specified entry in a particular file which has been
loaded previously into the lookup table and returns the contents
of that entry as a string.
> (get region <file-name> <topic-field>*)

TOSS: Unloads the named file from the internal lookup table.
> (toss <file-name>)

### PROFILING_COMMANDS

The following commands provide the ability to profile CLIPS programs
for performance.

SET-PROFILE-PERCENT-THRESHOLD: Sets the minimum percentage of time that
must be spent executing a construct or user
function for it to be displayed by the
profile-info command.
> (set-profile-percent-threshold <number in the range 0 to 100>)

GET-PROFILE-PERCENT-THRESHOLD: Returns the current value of the
profile percent threshold.
> (get-profile-percent-threshold)

PROFILE-RESET: Resets all profiling information currently collected
for constructs and user functions.
> (profile-reset)

PROFILE-INFO: Displays profiling information currently collected for
constructs or user functions.
> (profile-info)

PROFILE: Enables/disables profiling of constructs and user
         functions.
> (profile constructs | user-functions | off)

# INTEGRATED_EDITOR

CLIPS includes a fully integrated version of the full screen MicroEMACS
editor. You may call the editor from CLIPS, compile full buffers or just
sections of the editor (incremental compile), temporarily exit the editor back
to CLIPS, or permanently exit the editor.  Since the editor is full screen,
portions of it are highly machine dependent.  As it is currently set up, the
editor will run on VAX VMS machines using VT100- or VT240-compatible
terminals, UNIX systems which support TERMCAP, the IBM PC, and most IBM
compatibles.

| Subtopics:
|    USING_THE_EDITOR           EXTENDED_COMMANDS
|    CONTROL_COMMANDS           META_COMMANDS

### USING THE EDITOR

The editor may be called from CLIPS with the following command:

>    (edit ["<file-name>"])

The file name is optional. If one is given, that file would be loaded.  If no
file name is given, the editor is entered without loading a file.  Once in the
file, all of the EMACS commands listed below are applicable.  To exit the
editor and clear all buffers, use <Ctrl-Z> or <Ctrl-X><Ctrl-C>.  To
temporarily exit the editor and retain the information in the buffers, use
<Ctrl-X> Q.  To compile a rules section, mark a region and type
<Ctrl-X><Ctrl-T>. To compile the entire buffer, use <Meta-T>. The editor can
use extensive amounts of memory and a flag is available in clips.h to remove
all of the editor code.

When using the editor on multiuser machines like the VAX or many UNIX
environments, be careful with the control S and control Q commands; they could
conflict with terminal XON/XOFF communications. All of the control S commands
have a work around built into the editor. The save file command, normally
<Ctrl-X><Ctrl-S>, is also <Meta> Z. The forward search command, normally
<Ctrl-S>, is also <Meta> J. The control Q command is rarely needed in a CLIPS
file and, therefore, has no substitute.

The following two special characters should be noted when using the editor.

| <del>                 Delete previous character.
|                       (also <ctrl-H> on some terminals)
| <esc>                 Meta command prefix.
|                       (also <ctrl-[> on some terminals)

### CONTROL_COMMANDS

These commands are entered by pressing the control key along with the
designated character.

| <ctrl-@>          Set mark at current position.
| <ctrl-A>          Move cursor to beginning of line.
| <ctrl-B>          Move cursor BACK one character.
| <ctrl-C>          Start a new interactive command shell.  Be careful!
| <ctrl-D>          DELETE character under cursor.
| <ctrl-E>          Move cursor to END of line.
| <ctrl-F>          Move cursor FORWARD one character.
| <ctrl-G>          Abort any command.
| <ctrl-H>          (backspace) delete previous character.
| <ctrl-I>          Insert a TAB.
| <ctrl-J>          Insert a CR-LF and indent next line.
| <ctrl-K>          KILL (delete) to end of line.
| <ctrl-L>          Redisplay screen.
| <ctrl-M>          Insert a CR-LF.
| <ctrl-N>          Move cursor to NEXT line.
| <ctrl-O>          OPEN a new line.
| <ctrl-P>          Move to PREVIOUS line.
| <ctrl-Q>          QUOTE the next character (insert the next character typed).
| <ctrl-R>          Reverse SEARCH.
| <ctrl-S>          Forward SEARCH (also <Meta-J>).
| <ctrl-T>          TRANSPOSE characters.
| <ctrl-U>          Enter repeat count for next command.
| <ctrl-V>          VIEW the next screen (scroll up one screen).
| <ctrl-W>          KILL region (all text between cursor and last mark set).
| <ctrl-X>          Extended command prefix - see below.
| <ctrl-Y>          YANK (undelete) last text killed.
| <ctrl-Z>          Quick save of file in current buffer (only) and exit.

### EXTENDED_COMMANDS

These commands are entered by first pressing the control key along with the
'x' character and then pressing the designated character.

| <ctrl-X>(             Begin keyboard Macro.
| <ctrl-X>)             End keyboard Macro.
| <ctrl-X>!             Execute a single external command.
| <ctrl-X>=             Show current cursor column and line number.
| <ctrl-X>:             Go to a specific line number.
| <ctrl-X>1             Display current window only.
| <ctrl-X>2             Split the current window.
| <ctrl-X>B             Switch to a different BUFFER.
| <ctrl-X>E             EXECUTE keyboard Macro.
| <ctrl-X>F             Set FILL column.
| <ctrl-X>K             KILL a buffer (other than current buffer).
| <ctrl-X>M             MATCH parenthesis (or {} or []).
| <ctrl-X>N             Move to NEXT window.
| <ctrl-X>P             Move to PREVIOUS window.
| <ctrl-X>R             Global search and REPLACE (backwards).
| <ctrl-X>S             Global SEARCH and replace (forwards).
| <ctrl-X>Z             Enlarge current window by repeat count <ctrl-U> lines.
|
| <ctrl-X><ctrl-B>      Show active BUFFERS.
| <ctrl-X><ctrl-C>      Exit without saving buffers.
| <ctrl-X><ctrl-F>      FIND file.  Load if not already in buffer.
| <ctrl-X><ctrl-N>      Scroll current window up by repeat count lines.
| <ctrl-X><ctrl-P>      Scroll current window down by repeat count lines.
| <ctrl-X><ctrl-R>      RENAME file.  Change file name for buffer.
| <ctrl-X><ctrl-S>      SAVE (write) current buffer into its file.
| <ctrl-X><ctrl-V>      VISIT a file.  Read file and display in current window.
| <ctrl-X><ctrl-W>      WRITE buffer to file.  Option to change name of file.
| <ctrl-X><ctrl-Z>      Reduce current window by repeat count lines.

### META_COMMANDS

These commands are entered by first pressing the meta key (Activated by <esc>
or <ctrl-[>) and then pressing the designated character.

| <meta>!                Move current line to repeat count lines from top of
|                        window.
| <meta>>                Move cursor to end of buffer.
| <meta><                Move cursor to beginning of buffer.
| <meta>.                Set mark.
| <meta>B                Move cursor BACK one word.
| <meta>C                CAPITALIZE first letter of word.
| <meta>D                DELETE next word.
| <meta>F                Move cursor FORWARD one word.
| <meta>J                SEARCH forward (same as <ctrl-S>).
| <meta>L                LOWERCASE (lowercase) next word.
| <meta>R                Query search and REPLACE (backwards).
| <meta>S                Query SEARCH and replace (forwards).
| <meta>U                UPPERCASE (uppercase) next word.
| <meta>V                VIEW the previous screen (scroll down one screen).
| <meta>W                COPY region into kill buffer.
| <meta>Z                SAVE current buffer into file (same as
|                        <ctrl-X><ctrl-S>).
| <meta><del>            DELETE previous word.

# HISTORY

## V6.21

*   Bug Fixes - The following bugs were fixed by the 6.21 release:

    *   The C GetDefglobalValue macro did not have the correct number of arguments.

    *   The C RtnArgCount macro did not have the correct number of arguments.

    *   Erroneous error generated for object pattern under some circumstances.

    *   The C Save macro did not have the correct number of arguments.

    *   The C Eval and Build functions did not have the correct number
        of arguments.

    *   The progn$ index variable did not always return the correct
        value.

    *   The member$ function did not always return the correct value.

    *   C++ style comments in the code caused errors when using strict ANSI C compilation.

    *   The C LoadFactsFromString function did not have the correct number of arguments.

    *   Prior bug fix to the PutFactSlot C function prevented memory
        associated with the fact to be garbage collected after the
        fact had been retracted. The original bug is now fixed through
        a new API which allows embedded programs to temporarily disable
        garbage collection. See section 1.4 of The Advanced Programming
        Guide for more details.

## V6.22

*   Bug Fixes - The following bugs were fixed by the 6.22 release:

    *   Numerous fixes for functions and macros that did not accept
        the correct number of arguments as specified in the Advanced
        Programming Guide. The following functions and macros were
        corrected: Agenda, BatchStar, EnvGetActivationSalience,
        EnvBatchStar, EnvFactDeftemplate, EnvFactExistp, EnvFactList,
        EnvFactSlotNames, EnvGetNextInstanceInClassAndSubclasses,
        EnvLoadInstancesFromString, EnvRestoreInstancesFromString,
        EnvSetOutOfMemoryFunction, FactDeftemplate, FactExistp,
        FactList, FactSlotNames, GetNextInstanceInClassAndSubclasses,
        LoadInstancesFromString, RestoreInstancesFromString, and
        SetOutOfMemoryFunction.

## V6.23

*   Fact-Set Query Functions - Six new functions similar to the instance
    set query functions have been added for determining and performing
    actions on sets of facts that satisfy user-defined queries (see
    section 12.9.12 of the Basic Programming Guide): any-factp, find-fact,
    find-all-facts, do-for-fact, do-for-all-facts, and
    delayed-do-for-all-facts. The GetNextFactInTemplate function (see
    section 4.4.17 of the Advanced Programming Guide) allows iteration
    from C over the facts belonging to a specific deftemplate.

*   Bug Fixes - The following bugs were fixed by the 6.23 release:

    *   Passing the wrong number of arguments to a deffunction through
        the funcall function could cause unpredictable behavior
        including memory corruption.

    *   A large file name (at least 60 characters) passed into the fetch
        command causes a buffer overrun.

    *   A large file name (at least 60 characters) passed into the
        constructs-to-c command causes a buffer overrun.

    *   A large defclass or defgeneric name (at least 500 characters)
        causes a buffer overrun when the profile-info command is called.

    *   A large module or construct name (at least 500 characters)
        causes a buffer overrun when the get-<construct>-list command is
        called.

    *   The FalseSymbol and TrueSymbol constants were not defined as
        described in the Advanced Programming Guide. These constants
        have have now been defined as macros so that their corresponding
        environment companion functions (EnvFalseSymbol and EnvTrueSymbol)
        could be defined. See the Advanced Programming Guide for more
        details.

    *   The slot-writablep function returns TRUE for slots having
        initialize-only access.

    *   Files created by the constructs-to-c function for use in a
        run-time program generate compilation errors.

*   Command and Function Changes - The following commands and functions
    have been enhanced:

    *   funcall (see section 12.7.10 of the Basic Programming Guide).
        Multifield arguments are no longer expanded into multiple
        arguments before being passed to the target function of the
        funcall. The expand$ function can be placed around an argument
        to revert to the old behavior.

*   Compiler Support - The following compilers are now supported. See
    the Interfaces Guide for more details.

    *   Metrowerks CodeWarrior 9.4 for Mac OS X and Windows.

    *   Xcode 1.2 for Mac OS X.

## V6.24

*   Allowed Classes Constraint Attribute - The allowed-classes constraint
    attribute allows a slot containing an instance value to be restricted
    to the specified list of classes (see section 11.2 of the Basic
    Programming Guide).

*   New Functions and Commands - Several new functions and commands
    have been added. They are:

    *   deftemplate-slot-allowed-values (see section 12.8.2 of the BPG)

    *   deftemplate-slot-cardinality (see section 12.8.3 of the BPG)

    *   deftemplate-slot-defaultp (see section 12.8.4 of the BPG)

    *   deftemplate-slot-default-value (see section 12.8.5 of the BPG)

    *   deftemplate-slot-existp (see section 12.8.6 of the BPG)

    *   deftemplate-slot-multip (see section 12.8.7 of the BPG)

    *   deftemplate-slot-names (see section 12.8.8 of the BPG)

    *   deftemplate-slot-range (see section 12.8.9 of the BPG)

    *   deftemplate-slot-singlep (see section 12.8.10 of the BPG)

    *   deftemplate-slot-type (see section 12.8.11 of the BPG)

    *   get-char (see section 12.4.2.9 of the BPG)

    *   get-region (see section 13.15.2.3 of the BPG)

    *   ppfact (see section 13.4.6 of the BPG)

    *   read-number (see section 12.4.2.10 of the BPG)

    *   set-locale (see section 12.4.2.11 of the BPG)

    *   slot-allowed-classes (see section 12.16.1.27 of the BPG)

*   Command and Function Changes   The following commands and functions
    have been enhanced:

    *   format (see section 12.4.2.6 of the Basic Programming Guide). The
        formatting of printed numbers can be changed to use a native locale
        with the set-locale function. The documentation has been updated to
        include the effect of the precision argument on the d, g, o, and x
        format flags.

*   Behavior Changes - The following changes have been made to behavior:

    *   The message displayed when a construct is redefined and compilations
        are being watched is now more prominent.

*   Bug Fixes - The following bugs were fixed by the 6.24 release:

    *	The DescribeClass macros were incorrectly defined.

    *	The sort function leaks memory when called with a multifield value
        of length zero.

    *	Link error occurred for the SlotExistError function when OBJECT_SYSTEM
        is set to 0 in setup.h.

    *	An error when calling the Eval function causes a subsequent call to
        DeallocateEnvironmentData to fail.

    *	Loading a binary instance file from a run-time program caused a bus
        error.

    *	Incorrect activations could occur with the exists CE.

    *	Compilation errors occurred when compiling CLIPS source as C++ files.

    *	The AssignFactSlotDefaults function did not correctly handle defaults
        for multifield slots.

    *	The slot-default-value function crashed when no default existed for a
        slot (the ?NONE value was specified).

    *	CLIPS crashed on AMD64 processor in the function used to generate hash
        values for integers.

    *	A syntax error was not generated for the last deffunction or defmethod
        in a file if it was missing the final closing right parenthesis.

*   Compiler Support - The following compilers are now supported. See
    the Interfaces Guide for more details.

    *   Metrowerks CodeWarrior 9.6 for Mac OS X.

    *   Xcode 2.3 for Mac OS X.

    *   Microsoft Visual C++ .NET 2003 for Windows.

# SUPPORT INFORMATION

CLIPS executables, documentation, and source code are available for
download from http://www.ghg.net/clips/download/.

Questions regarding CLIPS can be sent via electronic mail to
clipsYYYY@ghg.net where YYYY is the current year (for example, 2004).
Include the words 'CLIPS USER' in the subject line.

An electronic conferencing facility, sponsored by Distributed Computing
Systems (http://www.discomsys.com), is also available to CLIPS users.
Subscribers to this facility may send questions, observations, answers,
editorials, etc., in the form of electronic mail to the conference. All
subscribers will have a copy of these messages reflected back to them at
their respective electronic mail addresses. To subscribe, send a single
line message to clips-request@discomsys.com containing the word
"subscribe". The subject field is ignored but the address found in the
Reply:, Reply to:, or From: field will be entered in the
distribution list. Upon subscription you will receive a mail message
instructing you how to participate in the conference from that point
forward. Save this mail message. You may need the instructions later if
you wish to unsubscribe from the list server.

To send your own messages to members of the conference you need simply
address your mail to clips@discomsys.com. Your message will be reflected
to all other members of the conference.

If you wish to remove yourself from the conference and discontinue
receiving mail simply send a message to clips-request@discomsys.com with
"unsubscribe" as the message text. If you want to unsubscribe using
another email account than the one you subscribed with, then append the
original subscribing email account to the text of the message. For
example: "unsubscribe john.doe@account.net". Do not send unsubscribe
messages to clips@discomsys.com! This sends a mail message to every
member of the list. If you need to get in contact with the list
administrator (for trouble unsubscribing or other questions about the
list), send email to clips-owner@discomsys.com.

A CLIPS World Wide Web page can be accessed using the URL
http://www.ghg.net/clips/CLIPS.html.

Usenet users can also find information and post questions about CLIPS to the
comp.ai.shells news group.

The CLIPS Developers' Forum, a thread-based message board, is available
at http://www.cpbinc.com/clips. This board exists to provide a site for
discussion of research, development, and implementation of the CLIPS
expert systems and related technologies. The hosting services for this
web page are provided by CPB, Inc. Questions pertaining to this forum
can be sent to clips@cpbinc.com.
