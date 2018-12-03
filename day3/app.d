import std.stdio;
import std.array;
import std.algorithm;
import std.conv;
import std.typecons;
import std.regex;
import std.range;

struct Claim {
    int id;
    int y, x;
    int h, w;
    bool overlapped = false;
}

void main()
{
    auto f = File("input.txt", "r");
    auto lines = f.byLineCopy.array;

    Claim[] claims;

    // Level 1

    foreach(line; lines) {
        auto m = line.matchFirst(regex(r"#([0-9]+) @ ([0-9]+),([0-9]+): ([0-9]+)x([0-9]+)"));
        auto claim = Claim();
        claim.id = m[1].to!int;
        claim.y = m[2].to!int;
        claim.x = m[3].to!int;
        claim.h = m[4].to!int;
        claim.w = m[5].to!int;
        claims ~= claim;
    }

    auto claimMap = new int[1000][1000];
    auto claimMapIds = new Claim*[1000][1000];
    int overlapped = 0;

    foreach(ref claim; claims) {
        foreach(y; 0 .. claim.h) {
            foreach(x; 0 .. claim.w) {
                claimMap[claim.x + x][claim.y + y]++;
                if(claimMap[claim.x + x][claim.y + y] == 2) {
                    overlapped++;
                }
                if(claimMapIds[claim.x + x][claim.y + y]) {
                    claim.overlapped = true;
                    claimMapIds[claim.x + x][claim.y + y].overlapped = true;
                }
                claimMapIds[claim.x + x][claim.y + y] = &claim;
            }
        }
    }

    writeln("Level 1: ", overlapped);

    // Level 2

    writeln("Level 2: ", claims.filter!(c => !c.overlapped).take(1).array[0].id);
}