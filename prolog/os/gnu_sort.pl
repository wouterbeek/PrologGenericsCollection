:- module(
  gnu_sort,
  [
    gnu_sort/2 % +File:atom
               % +Options:list(nvpair)
  ]
).

/** <module> GNU sort

Support for calling GNU sort from within Prolog.

@author Wouter Beek
@version 2015/08-2015/09
*/

:- use_module(library(cli_ext)).
:- use_module(library(error)).
:- use_module(library(option)).
:- use_module(library(process_ext)).

:- predicate_options(gnu_sort/2, 2, [
     buffer_size(+nonneg),
     duplicates(+boolean),
     output(+atom),
     parallel(+positive_integer),
     temporary_directory(+atom),
     utf8(+boolean)
   ]).





%! gnu_sort(+File:atom, +Options:list(nvpair)) is det.

gnu_sort(File, _):-
  var(File), !,
  instantiation_error(File).
gnu_sort(File, _):-
  \+ exists_file(File), !,
  existence_error(file, File).
gnu_sort(File, _):-
  \+ access_file(File, read), !,
  permission_error(read, file, File).
gnu_sort(File, Opts):-
  (   option(utf8(true), Opts)
  ->  Env = []
  ;   Env = ['LC_ALL'='C']
  ),
  gnu_sort_args(Opts, Args),
  run_process(sort, [file(File)|Args], [env(Env),program('GNU sort')]).

gnu_sort_args([], []).
gnu_sort_args([buffer_size(Size)|T1], [Arg|T2]):- !,
  long_flag('buffer-size', Size, Arg),
  gnu_sort_args(T1, T2).
gnu_sort_args([duplicates(false)|T1], ['--unique'|T2]):- !,
  gnu_sort_args(T1, T2).
gnu_sort_args([output(File)|T1], [Arg|T2]):- !,
  long_flag(output, File, Arg),
  gnu_sort_args(T1, T2).
gnu_sort_args([parallel(Threads)|T1], [Arg|T2]):- !,
  long_flag(parallel, Threads, Arg),
  gnu_sort_args(T1, T2).
gnu_sort_args([temporary_directory(Dir)|T1], [Arg|T2]):- !,
  long_flag('temporary-directory', Dir, Arg),
  gnu_sort_args(T1, T2).
gnu_sort_args([_|T1], L2):-
  gnu_sort_args(T1, L2).
