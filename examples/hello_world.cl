class Main inherits IO {
<<<<<<< HEAD
    main() : SELF_TYPE {
	    out_string(in_string())
=======
    pal(s : String) : Bool {
	if s.length() = 0
	then true
	else if s.length() = 1
	then true
	else if s.substr(0, 1) = s.substr(s.length() - 1, s.length())
	then pal(s.substr(1, s.length() -2))
	else false
	fi fi fi
    };

    i : Int;

    main() : SELF_TYPE {
	{
            i <- ~1;
	    out_string("enter a string\n");
	    if pal("AnA")
	    then out_string("that was a palindrome\n")
	    else out_string("that was not a palindrome\n")
	    fi;
	}
>>>>>>> 9d74eb3ebfd2cffc68bec440e23d3f797bd5fcca
    };
};
