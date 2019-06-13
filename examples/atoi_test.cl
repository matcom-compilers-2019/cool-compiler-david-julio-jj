class Main inherits IO {
   newline() : Object {
	out_string("\n")
   };

   prompt() : String {
	{
	   out_string("Enter a number>");
	   in_string();
	}
   };

   main() : Object {
     (let z : A2I <- new A2I in
	while true loop  
	   (let s : String <- prompt() in
		if s = "stop" then 
		    abort() -- we don't bother to terminate gracefully
		else
		   (let i : Int <- z.a2i(s) in
			(let news : String <- z.i2a(i) in
			   {
			     out_int(i);
			     newline();
			     out_string(news);
			     newline();
			   }
	                )
                  )
		fi
	   )
        pool
     )
   };
};
