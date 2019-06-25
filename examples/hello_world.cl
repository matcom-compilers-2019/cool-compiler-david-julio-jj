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
    main() :Object {
        let a:A2I <- new A2I in {
            a.init(2);
            out_int(a.get_value());
        }
    };
};