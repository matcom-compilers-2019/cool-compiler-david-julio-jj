class A {
   var : Int <- 0;
   value() : Int { var ;};
   set_var(num : Int) : SELF_TYPE {
      {
         var <- num;
         self;
      }
   };
};

class Main inherits IO{
    a : A <- new A;
    main() :SELF_TYPE {
        {
            a.set_var(1);
            out_int(a.value());
        }
    };
};