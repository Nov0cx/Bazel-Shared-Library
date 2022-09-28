#include "Other.hpp"

#ifdef API
#undef API
#endif
#include "Library.hpp"

#include <iostream>

void yes()
{
    std::cout << "Yes!" << std::endl;
}