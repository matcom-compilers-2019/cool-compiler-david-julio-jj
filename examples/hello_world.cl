class Main inherits IO {

    main() : SELF_TYPE {
        out_int(if true then 0 else 1 fi + if true then 1 else 0 fi + if true then 6 else 0 fi + if false then 1 else 10 fi)
    };
};
