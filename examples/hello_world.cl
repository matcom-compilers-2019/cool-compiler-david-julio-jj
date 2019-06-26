(*
 *  A contribution from Anne Sheets (sheets@cory)
 *
 *  Tests the arithmetic operations and various other things
 *)

class Main inherits IO {
   main() : Object {
     if is_even(in_int())
     then out_string("Is Even")
     else out_string("Is Odd")
     fi
   };

   is_even(num : Int) : Bool {
      (let x : Int <- num in
            if x < 0 then is_even(~x) else
            if 0 = x then true else
        if 1 = x then false else
              is_even(x - 2)
        fi fi fi
      )
   };
};