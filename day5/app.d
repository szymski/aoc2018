import std.stdio;
import std.array;
import std.algorithm;
import std.string;
import std.conv;
import std.typecons;
import std.regex;
import std.range;

void main()
{
    auto f = File("input.txt", "r");
    auto originalLine = f.readln.replace("\n", "");

    // Level 1

    string line = originalLine;

    for(int i = 0; i < cast(int)line.length - 1;) {
        char next = line[i + 1];
        if(isDifferentPolarity(line[i], next)) {
            line = line[0 .. i] ~ line[i + 2 .. $];
            i = max(0, i - 1);
        }
        else
            i++;
    }

    writeln("Level 1: ", line.length);

    // Level 2

    int[] lengths = new int[26];

    foreach(c; 0 .. 26) {
        string character = "" ~ cast(char)('a' + c);

        line = originalLine.removeLetters(character);

        for(int i = 0; i < cast(int)line.length - 1;) {
            char next = line[i + 1];
            if(isDifferentPolarity(line[i], next)) {
                line = line[0 .. i] ~ line[i + 2 .. $];
                i = max(0, i - 1);
            }
            else
                i++;
        }

        lengths[c] = line.length;
    }

    writeln("Level 2: ", lengths.sort!"a < b".front);
}

bool isDifferentPolarity(char a, char b) {
    return ((a + ('a' - 'A') == b) || (b + ('a' - 'A')) == a) && a != b;
}

string removeLetters(string text, string letter) {
    return text.replace(letter.toUpper, "").replace(letter.toLower, "");
}