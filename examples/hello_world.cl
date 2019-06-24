class Main inherits IO {
    x: Int;
    main() : Object {
        (let z : Int <- 2 in
	{
	   out_string("Pinga");
	   out_int(z);
	}
     )
    };
};
