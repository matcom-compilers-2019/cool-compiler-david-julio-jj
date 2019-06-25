class A2I{
    value: Int;
    init(a: Int): SELF_TYPE{
        {
            value <- a;
            self;
        }
    };
    get_value():Int{
        value
    };
};

class Main inherits IO{
    main() : Object {
        if "H" = "H"
        then
            out_string("siiii")
        else
            out_string("Noooo")
        fi
    };
};