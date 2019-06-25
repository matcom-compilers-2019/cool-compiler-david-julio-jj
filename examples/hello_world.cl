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
    a : A2I;
    main() : Object {
        {
            a <- new A2I;
            a.init(3);
            out_int(a.get_value());
        }
    };
};