class Main inherits IO {
    x : String;
    y : Int;
    main() : Object {
        {
            x <- "Pepe";
            y <- x.length();
            out_string(x);
            out_int(y);
        }
    };
};
