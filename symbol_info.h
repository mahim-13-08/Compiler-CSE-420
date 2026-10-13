#include<bits/stdc++.h>
using namespace std;

class symbol_info
{
    string name;
    string type;

public:

    symbol_info()
    {
        name="";
        type="";
    }

    symbol_info(string n,string t)
    {
        name=n;
        type=t;
    }

    void set_name(string n)
    {
        name=n;
    }

    void set_type(string t)
    {
        type=t;
    }

    string get_name()
    {
        return name;
    }

    string get_type()
    {
        return type;
    }
};