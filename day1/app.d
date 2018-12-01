import std.stdio;
import std.array;
import std.algorithm;
import std.conv;

void main()
{
    auto f = File("input.txt", "r");
    auto numbers = f.byLine.map!(l => l.to!int).array;

    writeln("Level 1: ", numbers.sum);

    int current = 0;
    int[int] frequencies;
    frequencies[current]++;
    inf: while (true)
        foreach (n; numbers)
        {
            current += n;
            frequencies[current]++;
            if (frequencies[current] == 2)
                break inf;
        }

    writeln("Level 2: ", current);
}
