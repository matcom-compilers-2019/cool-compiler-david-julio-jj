# Referencias del Lenguaje Cool

## Classes

Todo codigo en cool esta organizado dentro de clases, la definicion de una clase debe estar contenida en un solo archivo fuente, la definicion de clases tiene la siguiente forma:

```Cool
class <type> [ inherits type ] {
    <feature list>
};
```

Todos **los nombres de clase son visibles globalmente, y empiezan con letra mayuscula**. No existe la redefinicio de clases.

## Features

El cuerpo de una clase consiste en la definicion de una lista de features. Un feature no es mas que un atributo o un metodo. Supongamos que tenemos una **class A**, un atributo de la **clase A** representa a una variable que es parte del estado del objeto **class A**, y un metodo de la **class A** es un procedimiento (procedure) que puede manipular las variables y los objetos de la **class A**.

Los nombres de los Feature's deben empezar con miniscula, y ningun nombre de metodo o variable puede aparecer mas de una vez al definirlos. Pero un metodo y una variable pueden tener el mismo nombre.

Ejemplo:

```Cool
class Cons inherits List {
    xcar : Int;
    xcdr : List;

    isNil() : Bool { false };

    init(hd: Int, tl: List) : Cons {
        xcar <- hd;
        xcdr <- tl;
        self;
    }
}
```

## Inheritance

## Types

## SELF_TYPE

## Type Checking

## Attributes

## Void

## Methods

## Expresions

## Constants

## Identifiers

## Assignment

## Dispatch

## Conditionals

## Loops

## Blocks

## Let

## Case

## New

## isVoid

## Arithmetic and Comparison Operations

## Basic Classes

    Object:
    ...
    
    IO:
    ...
    
    Int:
    ...
    
    String:
    ...
    
    Bool:
    ...
    
    Main Class:
    ...

## Lexical Structure

    Integers, Identifiers, and Special Notation:
    ...
    
    Strings:
    ...
    
    Comments:
    ...
    
    Keywords:
    ...
    
    White Space:
    ...

## Cool Syntax

## Precedence

## Type Rules

## Type Eviorments

## Type Checking Rules

    Eviorment and the Store:
    ...

## Syntax for Cool Objects

## Class definitions

## Operational Rules