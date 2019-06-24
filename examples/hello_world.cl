class Main inherits IO {
    main() : Object {
        case 4 of
        a: Bool => out_string("No\n");
        b: Int => out_string("Si\n");
        esac
    };
};
