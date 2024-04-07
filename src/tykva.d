import std.stdio;

void main(string[] args) {
    foreach (argc, argv; args)
        arg(argc, argv);
}

void arg(size_t argc, string argv) {
    writefln("argv[%d] = <%s>", argc, argv);
}
