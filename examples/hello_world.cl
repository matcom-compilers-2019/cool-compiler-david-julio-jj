class Main inherits IO {
    a : Int <- 1;
    main() : Object {
        if isvoid(a)
        then out_string("Es void")
        else out_string("No es void")
        fi;
    };
};
