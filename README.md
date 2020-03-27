# mo-parsec

A Parsec based parser combinator library for Motoko.

This is a minimal parsec implementation based directly on a port, from OCaml, of
[Opal](0), which is itself derived from Haskell's influential [Parsec](1) library.

The library and example was implemented primarily to exercise Motoko new type argument inference, but may be of more general use.

* [src](src) contains the [`Parsec`](src/Parsec.mo) library.
* [test](test) contains a sample lambda calculus lexer and parser that you can run with wasmtime.

## Building

```
cd test; make
```

to build the sample; you may need to edit the `Makefile` to suit your installation.

## Documentation

There is currently no documentation, but see
Opal's [README](https://github.com/pyrocat101/opal/README.md) for a good overview of the available combinators, whose names
and types are largely preserved (modulo naming conventions and uncurrying).

Since Motoko does not have symbolic identifiers, symbolic Opal combinators are explicitly named in `Parsec.mo`. Here's a rough guide:


| Opal | Parsec  |
|------|---------|
| `>>=` | `bind` |
| `<\|>` | `choose` |
| `=>`  | `map` |
| `>>`  | `right` |
| `<<`  | `left` |
| `<~>` | `cons` |

Opal functions that rely on OCaml's polymorphic equality and comparison require additional arguments in Parsec. Some Opal combinators taking OCaml lists
take Motoko immutable arrays instead (e.g. `choice`).


## Disclaimer

The library is not well-tested, use at your own risk.

## References & Credits

[0] https://github.com/pyrocat101/opal

[1] https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/parsec-paper-letter.pdf

Thanks to Christoph Hegemann for the lambda calculus sample and feedback.

## API

```swift
module {

 Lazy : module {

  type t<A> = {force : () -> A};

  t : <A>(() -> A) -> t<A>
 };

 LazyStream : module {
  type t<A> = ?(A, Lazy.t<t<A>>);

  ofFunc : <A>(() -> ?A) -> LazyStream.t<A>;

  ofIter : <A>Iter<A> -> LazyStream.t<A>;

  ofText : Text -> LazyStream.t<Char>
 };

 type Input<Token> = LazyStream.t<Token>;

 type Monad<Token, Result> = ?(Result, Input<Token>);

 type Parser<Token, Result> = Input<Token> -> Monad<Token, Result>;

 any : <Token>Input<Token> -> Monad<Token, Token>;

 between : <Token, A, B, C>(Parser<Token, A>, Parser<Token, B>, Parser<Token, C>) -> Parser<Token, B>;

 bind : <Token, A, B>(Parser<Token, A>, A -> Parser<Token, B>) -> Parser<Token, B>;

 chainl : <Token, A, B>(Parser<Token, A>, Parser<Token, (A, A) -> A>, A) -> Parser<Token, A>;

 chainl1 : <Token, A, B>(Parser<Token, A>, Parser<Token, (A, A) -> A>) -> Parser<Token, A>;

 chainr : <Token, A, B>(Parser<Token, A>, Parser<Token, (A, A) -> A>, A) -> Parser<Token, A>;

 chainr1 : <Token, A, B>(Parser<Token, A>, Parser<Token, (A, A) -> A>) -> Parser<Token, A>;

 choice : <Token, A>[Parser<Token, A>] -> Parser<Token, A>;

 choose : <Token, A>(Parser<Token, A>, Parser<Token, A>) -> Parser<Token, A>;

 cons : <Token, A>(Parser<Token, A>, Parser<Token, List<A>>) -> Parser<Token, List<A>>;

 count : <Token, A>(Nat, Parser<Token, A>) -> Parser<Token, List<A>>;

 delay : <Token, Result>(() -> Parser<Token, Result>) -> Parser<Token, Result>;

 endBy : <Token, A, B>(Parser<Token, A>, Parser<Token, B>) -> Parser<Token, List<A>>;

 endBy1 : <Token, A, B>(Parser<Token, A>, Parser<Token, B>) -> Parser<Token, List<A>>;

 eof : <Token, A>A -> Parser<Token, A>;

 exactly : <Token>((Token, Token) -> Bool, Token) -> Parser<Token, Token>;

 explode : Text -> List<Char>;

 implode : List<Char> -> Text;

 left : <Token, A, B>(Parser<Token, A>, Parser<Token, B>) -> Parser<Token, A>;

 many : <Token, A>Parser<Token, A> -> Parser<Token, List<A>>;

 many1 : <Token, A>Parser<Token, A> -> Parser<Token, List<A>>;

 map : <Token, A, B>(Parser<Token, A>, A -> B) -> Parser<Token, B>;

 mzero : <Token, A>() -> Parser<Token, A>;

 noneOf : <Token>((Token, Token) -> Bool, [Token]) -> Parser<Token, Token>;

 oneOf : <Token>((Token, Token) -> Bool, [Token]) -> Parser<Token, Token>;

 option : <Token, A>(A, Parser<Token, A>) -> Parser<Token, A>;

 optional : <Token, A>Parser<Token, A> -> Parser<Token, ()>;

 pair : <Token, A, B>(Parser<Token, A>, Parser<Token, B>) -> Parser<Token, (A, B)>;

 parse : <Token, A>(Parser<Token, A>, LazyStream.t<Token>) -> ?A;

 range : <Token>((Token, Token) -> Bool, Token, Token) -> Parser<Token, Token>;

 ret : <Token, A>A -> Parser<Token, A>;

 right : <Token, A, B>(Parser<Token, A>, Parser<Token, B>) -> Parser<Token, B>;

 satisfy : <Token>(Token -> Bool) -> Parser<Token, Token>;

 sepBy : <Token, A, B>(Parser<Token, A>, Parser<Token, B>) -> Parser<Token, List<A>>;

 sepBy1 : <Token, A, B>(Parser<Token, A>, Parser<Token, B>) -> Parser<Token, List<A>>;

 skipMany : <Token, A>Parser<Token, A> -> Parser<Token, ()>;

 skipMany1 : <Token, A>Parser<Token, A> -> Parser<Token, ()>;

 token : <Token, A>(Token -> ?A) -> Parser<Token, A>

 type CharParsers = {

  alphaNum : Input<Char> -> Monad<Char, Char>;

  digit : Input<Char> -> Monad<Char, Char>;

  hexDigit : Input<Char> -> Monad<Char, Char>;

  letter : Input<Char> -> Monad<Char, Char>;

  lexeme : <A>Parser<Char, A> -> Parser<Char, A>;

  lower : Input<Char> -> Monad<Char, Char>;

  newline : Input<Char> -> Monad<Char, Char>;

  octDigit : Input<Char> -> Monad<Char, Char>;

  space : Input<Char> -> Monad<Char, Char>;

  spaces : Input<Char> -> Monad<Char, ()>;

  tab : Input<Char> -> Monad<Char, Char>;

  token : Text -> Parser<Char, Text>;

  upper : Input<Char> -> Monad<Char, Char>
 };

 CharParsers : () -> CharParsers;
}
```


