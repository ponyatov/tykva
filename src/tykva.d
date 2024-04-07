import std.stdio;

void main(string[] arg) {
    foreach (argc, argv; arg)
        arg(argc, argv);
}

void arg(int argc, string argv) {
    writefln("argv[%i] = <%s>", argc, argv);
}
